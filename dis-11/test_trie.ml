open OUnit2
open Trie

let black_box_tests = [
  "empty" >:: (fun _ -> assert_equal (empty |> to_list |> List.length) 0)
]

let glass_box_tests = [
  
]

let suite = "Set test suite" >::: black_box_tests @ glass_box_tests

let _ = run_test_tt_main suite
