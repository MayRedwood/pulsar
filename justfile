#!/usr/bin/env -S just --justfile

recipes:
    just --list --unsorted

alias b := build
alias a := apply
alias d := deploy
alias man := manual
alias ls := list
alias in := inputs
alias up := update
alias r := run

[group("colmena")]
build:
    colmena build --evaluator streaming

[group("colmena")]
apply TYPE:
    colmena apply --evaluator streaming {{ TYPE }}

[group("colmena")]
deploy TYPE:
    colmena apply-local --sudo {{ TYPE }}

[group("colmena")]
switch: (deploy "switch") diff

[group("colmena")]
all: build (apply "boot") (deploy "boot") diff

[group('info')]
manual:
    man configuration.nix

[group("info")]
repl:
    colmena repl

[group('info')]
list *F:
    nvd list -r /nix/var/nix/profiles/system {{ F }}

[group("info")]
diff n="1":
    #!/usr/bin/env bash
    readarray -t lines < <( find /nix/var/nix/profiles | tail -n $(({{ n }} + 2)) )
    nvd diff ${lines[0]} ${lines[{{ n }}]}

[group("info")]
inputs:
    #!/usr/bin/env nu
    cat ./npins/sources.json | from json | get pins | transpose name info | get name

[group("info")]
deps:
    #!/usr/bin/env nu
    cat ./npins/sources.json | from json | get pins

[group("wrapper")]
update:
    npins update

[group("wrapper")]
pins *ARGS:
    npins {{ ARGS }}

[group("wrapper")]
col *ARGS:
    colmena {{ ARGS }}

[group("wrapper")]
out +ARGS:
    nilla {{ ARGS }}

[group("wrapper")]
run +BIN:
    {{ BIN }}
