open Funocaml_o11y
module Otel = Opentelemetry
module Trace = Otel.Trace

let long_running_computation () =
  Trace.with_ "long_running_computation" (fun _scope ->
      Dream.log "Starting a long computation...";
      let rec loop n =
        Trace.with_ "computation_step"
          ~attrs:[ ("step", `Int n) ]
          (fun _scope ->
            if n = 0 then ()
            else (
              Unix.sleep 1;
              loop (n - 1)))
      in
      loop (Random.full_int 5))

let get path handler =
  let name = "GET " ^ path in
  let handler x = Trace.with_ name (fun _scope -> handler x) in
  Dream.get path handler

let () =
  OMiddleware.with_middleware "dream-hello-world" @@ fun observability ->
  Dream.run
  @@ Dream.pipeline
       [ Dream.logger; Dream.livereload; Dream.memory_sessions; observability ]
  @@ Dream.router
       [
         get "/" (fun _ ->
             Dream.log "Hello";
             Dream_html.respond Index.html);
         get "/chat" (fun _ -> Dream_html.respond Chat.html);
         get "/websocket" (fun _ -> Dream.websocket Chat.handle_client);
         get "/greet" (fun _ ->
             Dream.log "Greeting requested!";
             Dream_html.respond (Greet.html "World"));
         get "/error" (fun _request -> failwith "This is an example error!");
         get "/long" (fun _request ->
             long_running_computation ();
             Dream.html "Long computation finished.");
       ]
