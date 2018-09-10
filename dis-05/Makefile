.PHONY: test sol clean

test:
	ocamlbuild calculator.byte && ./calculator.byte

sol:
	ocamlbuild calculator_sol.byte && ./calculator_sol.byte

clean:
	ocamlbuild -clean
