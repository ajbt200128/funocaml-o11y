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

let html () =
  let time_start = Unix.gettimeofday () in
  long_running_computation ();
  let time_end = Unix.gettimeofday () in
  let duration = time_end -. time_start in
  Printf.sprintf "Long computation finished in: %.2f seconds" duration
