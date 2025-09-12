open Funocaml_o11y
module Otel = Opentelemetry
module Trace = Otel.Trace

let get path handler =
  let name = "GET " ^ path in
  let handler x = Trace.with_ name (fun _scope -> handler x) in
  Dream.get path handler

let () =
  OMiddleware.with_middleware @@ fun observability ->
  Dream.run
  @@ Dream.pipeline
       [ Dream.logger; Dream.livereload; Dream.memory_sessions; observability ]
  @@ Dream.router
       [
         get "/" (fun _request -> Dream_html.respond Index.html);
         get "/chat" (fun _request -> Dream_html.respond Chat.html);
         get "/websocket" (fun _request -> Dream.websocket Chat.handle_client);
         get "/greet" (fun request -> Dream_html.respond (Greet.html request));
         get "/error" (fun _request -> Dream.html (Error.html ()));
         get "/long" (fun _request -> Dream.html Computation.(html ()));
       ]
