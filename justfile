#!/usr/bin/env -S just --justfile

recipes:
    just --list --unsorted

[group("colmena")]
build:
    colmena build --evaluator streaming

[group("colmena")]
apply:
    colmena apply --evaluator streaming

[group("colmena")]
switch:
    colmena apply-local --sudo switch

[group("colmena")]
boot:
    colmena apply-local --sudo boot

[group("colmena")]
local: switch diff

[group("colmena")]
deploy: build apply boot diff

[group("utility")]
up:
    npins update

[group("utility")]
diff n="1":
    #!/usr/bin/env bash
    readarray -t lines < <( find /nix/var/nix/profiles | tail -n $(({{ n }} + 2)) )
    nvd diff ${lines[0]} ${lines[{{ n }}]}

[group("utility")]
inputs:
    #!/usr/bin/env nu
    cat ./npins/sources.json | from json | get pins | transpose name info | get name

[group("utility")]
deps:
    #!/usr/bin/env nu
    cat ./npins/sources.json | from json | get pins

[group("utility")]
repl:
    colmena repl

[group("wrapper")]
pins +ARGS:
    npins {{ ARGS }}

[group("wrapper")]
col *ARGS:
    colmena {{ ARGS }}

[group("wrapper")]
out +ARGS:
    nilla {{ ARGS }}
