open Core
open Async

let redactify (mask_text : string) (s : string) =
  List.fold ~f:(fun s fn -> fn mask_text s) ~init:s Replacements.all

let stdin = Lazy.force Reader.stdin

let stdout = Lazy.force Writer.stdout

let rec main () : unit Deferred.t =
  Reader.read_line stdin >>= function
  | `Eof -> Writer.flushed stdout
  | `Ok x ->
      Writer.write stdout @@ redactify "_redacted_" x;
      Writer.write stdout "\n";
      Writer.flushed stdout >>= main
