(lang dune 3.19)

(name funocaml-o11y)

(generate_opam_files true)

(source
 (github ajbt200128/funocaml-o11y))

(authors "Austin Theriault <austin@cutedogs.org>")

(maintainers "Austin Theriault <austin@cutedogs.org>")

(license LICENSE)

(package
 (name funocaml-o11y)
 (synopsis "An OCaml observability example")
 (description "A small example binary that demonstrates how to use Opentelemetry in OCaml")
 (depends
   ocaml
   dune

   dream
   dream-html
   logs
   opentelemetry
   opentelemetry-client-ocurl
   opentelemetry-logs
   (ocaml-lsp-server :with-dev-setup)
   (ocamlformat :with-dev-setup)
   (ocamlmerlin-mlx :with-dev-setup)
))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
