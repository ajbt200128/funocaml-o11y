open Opentelemetry
open Metrics

let now = Timestamp_ns.now_unix_ns
let send_metrics = Metrics.emit

let count_request () =
  [
    sum ~name:"server.requests.total"
      ~aggregation_temporality:Metrics.Aggregation_temporality_delta
      ~is_monotonic:true
      [ int ~now:(now ()) 1 ];
  ]
  |> send_metrics

let message_sent () =
  [
    sum ~name:"chat.messages.sent"
      ~aggregation_temporality:Metrics.Aggregation_temporality_delta
      ~is_monotonic:true
      [ int ~now:(now ()) 1 ];
  ]
  |> send_metrics
