# docker build -t redacto/build .
FROM ocaml/opam2
RUN sudo apt-get install -y m4 vim
RUN opam update
RUN opam install \
  core \
  merlin \
  ocamlformat \
  --verbose
