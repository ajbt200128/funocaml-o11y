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

let with_middleware service_name (f : Dream.middleware -> 'a) =
  Dream.initialize_log ();
  Observability.setup service_name @@ fun _scope ->
  let middleware (inner_handler : Dream.handler) request =
    let attrs = request_attributes request in
    Trace.with_ "http.request" ~kind:Opentelemetry_proto.Trace.Span_kind_server
      ~attrs (fun scope ->
        Metrics.count_request ();
        try%lwt inner_handler request
        with exn ->
          let exn_str = Printexc.to_string exn in
          Otel.Scope.set_status scope
            Otel.Span_status.(make ~message:exn_str ~code:Status_code_ok);
          raise exn)
  in
  f middleware
