module Otel = Opentelemetry
module Trace = Otel.Trace

let url = "https://api.honeycomb.io/"
let service_name = "dream-hello-world"

let headers =
  let team = Sys.getenv "HONEYCOMB_TEAM" in
  [ ("x-honeycomb-team", team); ("x-honeycomb-dataset", service_name) ]

let setup_logger () =
  (* Get the Dream logger *)
  let current_reporter = Logs.reporter () in
  (* Now attach our logger *)
  let reporter = Opentelemetry_logs.attach_otel_reporter current_reporter in
  (* Now set this as the global logger *)
  Logs.set_reporter reporter

let setup () =
  Otel.Globals.service_name := service_name;
  setup_logger ();
  let config = Opentelemetry_client_ocurl.Config.make ~headers ~url () in
  Opentelemetry_client_ocurl.with_setup ~config ()
