open Opentelemetry
open Metrics

let now = Timestamp_ns.now_unix_ns
let send_metrics = Metrics.emit

let count_request () =
  (* Our metric type here is sum, as opposed to a guage or histogram, since what
     we are measuring can be added together, where as a guage is for metrics you
     can't "add", such as the size of the major heap, and a histogram is for
     recording a distribution of a population *)
  [
    sum
      ~name:"server.requests.total"
        (* Aggregation temporality is if we are sending the /change/ in the
         metric (delta) or the final value (cumulative) *)
      ~aggregation_temporality:Metrics.Aggregation_temporality_delta
        (* monotonic means the sum is always increasing *)
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
