let html =
  let open Dream_html in
  let open HTML in
  html []
    [
      head [] [];
      body []
        [
          form []
            [
              input [ type_ "submit"; value "Send" ];
              input [ type_ "text"; id "message"; size "64"; autofocus ];
            ];
          script []
            {|
      let message = document.getElementById("message");
      let chat = document.querySelector("body");
      let socket = new WebSocket("ws://" + window.location.host + "/websocket");

      socket.onmessage = function (event) {
        let item = document.createElement("div");
        item.innerText = event.data;
        chat.appendChild(item);
      };

      document.querySelector("form").onsubmit = function () {
        if (socket.readyState != WebSocket.OPEN)
          return false;
        if (!message.value)
          return false;

        socket.send(message.value);
        message.value = "";
        return false;
      };
    |};
        ];
    ]

let clients : (int, Dream.websocket) Hashtbl.t = Hashtbl.create 5

let track =
  let last_client_id = ref 0 in
  fun websocket ->
    last_client_id := !last_client_id + 1;
    Hashtbl.replace clients !last_client_id websocket;
    !last_client_id

let forget client_id = Hashtbl.remove clients client_id

let send message =
  Metrics.message_sent ();
  Hashtbl.to_seq_values clients
  |> List.of_seq
  |> Lwt_list.iter_p (fun client -> Dream.send client message)

let handle_client client =
  let client_id = track client in
  let rec loop () =
    match%lwt Dream.receive client with
    | Some message ->
        let%lwt () = send message in
        loop ()
    | None ->
        forget client_id;
        Dream.close_websocket client
  in
  loop ()
