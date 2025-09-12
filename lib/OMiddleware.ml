module Otel = Opentelemetry
module Trace = Otel.Trace

let request_attributes (r : Dream.request) =
  let method_ = r |> Dream.method_ |> Dream.method_to_string in
  let session_id = Dream.session_id r in
  let session_label = Dream.session_label r in
  let session_attrs =
    let session_fields = Dream.all_session_fields r in
    List.map
      (fun (k, v) -> ("http.request.session." ^ k, `String v))
      session_fields
  in
  let header_attrs =
    let headers = Dream.all_headers r in
    (* Format headers as ("http.request.header.<key>", <value>) *)
    List.map (fun (k, v) -> ("http.request.header." ^ k, `String v)) headers
  in
  [
    ("http.request.method", `String method_);
    ("http.session.label", `String session_label);
    ("http.session.id", `String session_id);
  ]
  @ session_attrs @ header_attrs

let with_middleware (f : Dream.middleware -> 'a) =
  (* Initialize the dream logger so in setup we can attach to it *)
  Dream.initialize_log ();
  (* Setup observability *)
  Observability.setup () @@ fun _scope ->
  (* Create middleware *)
  let middleware (inner_handler : Dream.handler) request =
    Metrics.count_request ();
    let attrs = request_attributes request in
    (* Setup a top level span that indicates this is the entrypoint of the
       server *)
    Trace.with_ "http.request" ~kind:Opentelemetry_proto.Trace.Span_kind_server
      ~attrs (fun scope ->
        (* Try processing the request *)
        try%lwt inner_handler request
        with exn ->
          (* If there's an exception, record it *)
          let raw_backtrace = Printexc.get_raw_backtrace () in
          Otel.Scope.record_exception scope exn raw_backtrace;
          raise exn)
  in
  f middleware
