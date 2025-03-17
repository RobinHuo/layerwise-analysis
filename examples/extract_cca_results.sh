#!/usr/bin/env bash

model="$1"
logs="$2"
out="$3"

for log in "$logs"/*.json; do
    jq -r 'to_entries[] | [.key, .value] | @tsv' <"$log" |
        perl -e 'INIT {
                $, = " ";
                $model = $ARGV[0];
                (undef, $span, $split, $sample) = split(/_/, $ARGV[1]);
            }
            while (<STDIN>) {
                chomp;
                $_ .= "\t" . join("\t", $model, $span, $split, $sample) . "\n";
                print $_;
            }
        ' "$model" "$(basename "$log" .json)"
done >"$out"
