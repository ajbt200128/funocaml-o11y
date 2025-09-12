open Funocaml_o11y

let get path handler = Dream.get path handler

let () =
  Dream.run
  @@ Dream.pipeline [ Dream.logger; Dream.livereload; Dream.memory_sessions ]
  @@ Dream.router
       [
         get "/" (fun _request -> Dream_html.respond Index.html);
         get "/chat" (fun _request -> Dream_html.respond Chat.html);
         get "/websocket" (fun _request -> Dream.websocket Chat.handle_client);
         get "/greet" (fun request -> Dream_html.respond (Greet.html request));
         get "/error" (fun _request -> Dream.html (Error.html ()));
         get "/long" (fun _request -> Dream.html Computation.(html ()));
       ]
