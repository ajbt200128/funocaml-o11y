let long_running_computation () =
  Dream.log "Starting a long computation...";
  let rec loop n =
    if n = 0 then ()
    else (
      Unix.sleep 1;
      loop (n - 1))
  in
  loop (Random.full_int 5)

let html () =
  let time_start = Unix.gettimeofday () in
  long_running_computation ();
  let time_end = Unix.gettimeofday () in
  let duration = time_end -. time_start in
  Printf.sprintf "Long computation finished in: %.2f seconds" duration
