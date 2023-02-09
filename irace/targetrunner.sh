#!/usr/bin/env bash

echo "$@" >> "${TMPDIR:-.}/targetrunner.log"

cmd='Gallium.run("'$*'") |> Gallium.NumberUtils.negate() |> Gallium.NumberUtils.to_r() |> IO.puts()'

result=$(gallium rpc "$cmd")

echo "$result" >> "${TMPDIR:-.}/targetrunner.log"
echo "$result"
