recipes:
    just --list --unsorted

up:
    npins update

build:
    colmena build

apply:
    colmena apply

switch:
    colmena apply-local --sudo

deploy: build apply switch

pins +ARGS:
    npins {{ ARGS }}

hive *ARGS:
    colmena {{ ARGS }}

nilla +ARGS:
    nilla {{ ARGS }}
