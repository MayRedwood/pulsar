recipes:
    just --list --unsorted

up:
    npins update

build:
    colmena build --evaluator streaming

apply:
    colmena apply --evaluator streaming

switch:
    colmena apply-local --sudo switch

boot:
    colmena apply-local --sudo boot

local: switch diff

deploy: build apply boot diff

# pins +ARGS:
#     npins {{ ARGS }}
# hive *ARGS:
#     colmena {{ ARGS }}
# nilla +ARGS:
#     nilla {{ ARGS }}

diff n="1":
    #!/usr/bin/env bash
    readarray -t lines < <( find /nix/var/nix/profiles | tail -n $(({{ n }} + 2)) )
    nvd diff ${lines[0]} ${lines[{{ n }}]}
