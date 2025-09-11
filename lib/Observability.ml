module Otel = Opentelemetry
module Trace = Otel.Trace

let url = "https://api.honeycomb.io/"

let headers service_name =
  let team = Sys.getenv "HONEYCOMB_TEAM" in
  [ ("x-honeycomb-team", team); ("x-honeycomb-dataset", service_name) ]

let setup_logger () =
  let current_reporter = Logs.reporter () in
  let reporter = Opentelemetry_logs.attach_otel_reporter current_reporter in
  Logs.set_reporter reporter

let setup_ambient_context () =
  let ambient_context = Ambient_context_lwt.storage () in
  Ambient_context.set_storage_provider ambient_context

let setup service_name =
  Otel.Globals.service_name := service_name;
  setup_ambient_context ();
  setup_logger ();
  let config =
    Opentelemetry_client_ocurl.Config.make ~headers:(headers service_name) ~url
      ()
  in
  Opentelemetry_client_ocurl.with_setup ~config ()
