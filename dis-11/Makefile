.PHONY: test build clean

test:
	ocamlbuild -use-ocamlfind test_trie.byte && ./test_trie.byte

build:
	ocamlbuild -use-ocamlfind trie.byte

clean:
	ocamlbuild -clean
