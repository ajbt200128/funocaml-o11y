all: build

funocaml-o11y.opam: dune-project
	opam exec -- dune build funocaml-o11y.opam

build: funocaml-o11y.opam
	opam exec -- dune build

run: funocaml-o11y.opam
	opam exec -- dune exec funocaml-o11y

clean:
	opam exec -- dune clean

format:
	opam exec -- dune build @fmt --auto-promote

setup:
	opam update -y
	opam switch create . --with-dev-setup -y

install-deps:
	opam install . --deps-only --with-dev-setup -y

shell:
	nix develop .
