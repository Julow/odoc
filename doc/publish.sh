#!/usr/bin/env bash

dune build @docgen

git checkout origin/gh-pages

rsync -av _build/default/doc/odoc/ .

