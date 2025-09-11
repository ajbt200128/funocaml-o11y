all: build

funocaml-o11y.opam: dune-project funocaml-o11y.opam.template
	dune build funocaml-o11y.opam

build: funocaml-o11y.opam
	dune build

run: funocaml-o11y.opam
	dune exec funocaml-o11y

clean:
	dune clean

format:
	dune build @fmt --auto-promote

setup:
	opam switch create . --with-dev-setup -y
