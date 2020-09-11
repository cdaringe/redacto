open OUnit2

let rd = "REDACTED"

let test_phone_hyphens _ =
  assert_equal (Replacements.no_phones rd "111-222-4444") rd

let test_phone_some_hyphens_1 _ =
  assert_equal (Replacements.no_phones rd "111-222-4444") rd

let test_phone_some_hyphens_2 _ =
  assert_equal (Replacements.no_phones rd "111-2223333") rd

let test_phone_classico _ =
  assert_equal (Replacements.no_phones rd "(111)222-3333") rd

let test_phone_classico_whitespace_1 _ =
  assert_equal (Replacements.no_phones rd "111 222 3333") rd

let test_phone_classico_whitespace_2 _ =
  assert_equal (Replacements.no_phones rd "(111)222 3333") rd

let test_phone_classico_whitespace_3 _ =
  assert_equal (Replacements.no_phones rd "(111) 222 3333") rd

let test_phone_classico_whitespace_4 _ =
  assert_equal (Replacements.no_phones rd "(111) 222  3333") "(111) 222  3333"

let test_phone_classico_whitespace_5 _ =
  assert_equal (Replacements.no_phones rd "(111)  222 3333") "(111)  222 3333"

let test_phone_no_hyphens _ =
  assert_equal (Replacements.no_phones rd "1112224444") "1112224444"

let test_credit_card_hyphens _ =
  assert_equal (Replacements.no_credit_cards rd "1231-3425-3453-5555") rd

let test_credit_card_no_hyphens _ =
  assert_equal (Replacements.no_credit_cards rd "1231342534535555") rd

let test_credit_card_underscores _ =
  assert_equal
    (Replacements.no_credit_cards rd "1231_3425_3453_5555")
    "1231_3425_3453_5555"

let time f x =
  let start = Unix.gettimeofday () in
  let res = f x in
  let stop = Unix.gettimeofday () in
  (stop -. start, res)

let range a b = List.init (b - a) (( + ) a)

let test_performance_many_inputs n _ =
  let to_process =
    List.map (fun _ -> Randocommando.rand_description ()) (range 0 n)
  in
  let redactify s =
    let _ = Redactor.redactify "" s in
    ()
  in
  let process_all = List.iter (fun s -> redactify s) in
  let seconds, _ = time process_all to_process in
  assert_bool
    (Printf.sprintf
       "%d redactions, %f seconds. expected average of < 0.01s/redaction"
       (List.length to_process) seconds)
    (seconds < float_of_int n *. 0.01)

(* Name the test cases and group them together *)
let suite =
  "suite"
  >::: [
         "test_phone_hyphens" >:: test_phone_hyphens;
         "test_phone_no_hyphens" >:: test_phone_no_hyphens;
         "test_phone_some_hyphens_1" >:: test_phone_some_hyphens_1;
         "test_phone_some_hyphens_2" >:: test_phone_some_hyphens_2;
         "test_phone_classico" >:: test_phone_classico;
         "test_phone_classico_whitespace_1" >:: test_phone_classico_whitespace_1;
         "test_phone_classico_whitespace_2" >:: test_phone_classico_whitespace_2;
         "test_phone_classico_whitespace_3" >:: test_phone_classico_whitespace_3;
         "test_phone_classico_whitespace_4" >:: test_phone_classico_whitespace_4;
         "test_phone_classico_whitespace_5" >:: test_phone_classico_whitespace_5;
         "test_credit_card_hyphens" >:: test_credit_card_hyphens;
         "test_credit_card_no_hyphens" >:: test_credit_card_no_hyphens;
         "test_credit_card_underscores" >:: test_credit_card_underscores;
         "test_performance_many_inputs" >:: test_performance_many_inputs 10000;
       ]

let () = run_test_tt_main suite
