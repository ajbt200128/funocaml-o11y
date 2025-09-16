module Otel = Opentelemetry
module Trace = Otel.Trace

let url = "https://api.honeycomb.io/"
let service_name = "dream-hello-world"

let headers =
  (* Get your api token from the env *)
  let team_opt = Sys.getenv_opt "HONEYCOMB_TEAM" in
  match team_opt with
  | None -> failwith "HONEYCOMB_TEAM environment variable not set"
  | Some team ->
      (* alt: just paste it in your code, but don't commit it! **)
      [ ("x-honeycomb-team", team); ("x-honeycomb-dataset", service_name) ]

let setup_logger () =
  (* Get the Dream logger *)
  let current_reporter = Logs.reporter () in
  (* Now attach our logger *)
  let reporter = Opentelemetry_logs.attach_otel_reporter current_reporter in
  (* Now set this as the global logger *)
  Logs.set_reporter reporter

let setup () =
  (* Sets the service name *)
  Otel.Globals.service_name := service_name;
  setup_logger ();
  (* Point the backend to the honeycomb api and add headers for auth *)
  let config = Opentelemetry_client_ocurl.Config.make ~headers ~url () in
  Opentelemetry_client_ocurl.with_setup ~config ()
