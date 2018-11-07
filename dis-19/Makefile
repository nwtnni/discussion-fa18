build:
	ocamlbuild -use-ocamlfind eval.byte

sol:
	ocamlbuild -use-ocamlfind eval_sol.byte && mv eval_sol.byte sol.byte

sol_mut:
	ocamlbuild -use-ocamlfind eval_sol_mut.byte && mv eval_sol_mut.byte sol_mut.byte

clean:
	ocamlbuild -clean
