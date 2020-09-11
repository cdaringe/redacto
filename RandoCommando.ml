open Core

let rand_price () = string_of_int (1 + Random.int 999)

let rand_chr () = Core.Caml.Char.chr (97 + Random.int 26)

let rec rand_voy () =
  let got = rand_chr () in
  match got with 'a' | 'e' | 'i' | 'o' | 'u' | 'y' -> got | _ -> rand_voy ()

let rec rand_con () =
  let got = rand_chr () in
  match got with 'a' | 'e' | 'i' | 'o' | 'u' | 'y' -> rand_con () | _ -> got

let rec rand_convoy acc syll_number () =
  match syll_number with
  | 0 -> acc
  | _ ->
      rand_convoy
        (acc ^ Char.escaped (rand_con ()) ^ Char.escaped (rand_voy ()))
        (syll_number - 1) ()

let rand_word () = rand_convoy "" (3 + Random.int 3) ()

let rand_name () = rand_convoy "" 3 ()

let rec rand_sentence acc word_number () =
  match word_number with
  | 0 -> acc ^ rand_word () ^ "."
  | _ -> rand_sentence (acc ^ rand_word () ^ " ") (word_number - 1) ()

let rand_description () = rand_sentence "" (10 + Random.int 10) ()

let sql_quote a_string = "'" ^ a_string ^ "'"

let generate_insert_user () =
  "INSERT INTO users VALUES (" ^ sql_quote (rand_name ()) ^ " ,1)"

let generate_insert_product p_id =
  "INSERT INTO products VALUES (" ^ string_of_int p_id ^ ", '" ^ rand_name ()
  ^ "', '" ^ rand_description () ^ "', " ^ rand_price () ^ ")"
