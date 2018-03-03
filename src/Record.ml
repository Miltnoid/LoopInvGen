open Core
open Exceptions
open SyGuS

let main zpath size forks seeds statefile logfile filename () =
  Utils.start_logging_to ~msg:"RECORD" logfile ;
  let s = SyGuS.load (Utils.get_in_channel filename)
  in if size < 1 then ()
     else begin
       let state_chan = Utils.get_out_channel statefile in
       let seeds = (if seeds = [] then [`Nondeterministic]
                   else List.map ~f:(fun s -> `Deterministic s) seeds)
       in Simulator.record_states s ~zpath ~size ~seeds ~state_chan
        ; Out_channel.close state_chan
     end

let spec =
  let open Command.Spec in (
    empty
    +> flag "-z" (required string)                ~doc:"FILENAME path to the z3 executable"
    +> flag "-s" (optional_with_default 512 int)  ~doc:"COUNT number of steps to simulate"
    +> flag "-f" (optional_with_default 3 int)    ~doc:"COUNT number of forks to create (not yet implemented)"
    +> flag "-r" (listed string)                  ~doc:"STRING random-string seed(s)"
    +> flag "-o" (optional string)                ~doc:"FILENAME output file for states, defaults to stdout"
    +> flag "-l" (optional string)                ~doc:"FILENAME output file for logs, defaults to null"
    +> anon (maybe_with_default "-" ("filename" %: file))
  )

let cmd =
  Command.basic_spec spec main
    ~summary: "Record program states for a given SyGuS-INV benchmark."

let () =
  Command.run
    ~version:"0.6b"
    ~build_info:("padhi @ " ^ (Core_extended.Logger.timestamp ()))
    cmd