open Async

let () =
  Command.run @@ Command.async ~summary:"" @@ Command.Param.return Redactor.main
