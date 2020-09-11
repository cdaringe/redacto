(* https://github.com/solvvy/redact-pii/blob/a583ea6a6b43f72b74619b1ebd091900205495cb/src/built-ins/simple-regexp-patterns.ts *)

let re = Re2.create_exn

let replace ~re ~replacement input =
  Re2.replace_exn ~f:(fun _ -> replacement) re input

let redact re replacement = replace ~re ~replacement

let no_credit_cards_re =
  re {|\d{4}[ -]?\d{4}[ -]?\d{4}[ -]?\d{4}|\d{4}[ -]?\d{6}[ -]?\d{4}\d?/g}|}

let no_credit_cards = redact no_credit_cards_re

let no_phones_re =
  Re2.create_exn {p|(?:\d{10})*\(?\d{3}(\)|-| |\.)( )?\d{3}(-|\.| )?\d{4}|p}

let no_phones = redact no_phones_re

let all = [ no_phones; no_credit_cards ]

(* ; no_ssn] *)
