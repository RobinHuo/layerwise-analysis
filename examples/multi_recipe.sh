#!/usr/bin/env bash

export ALIGNMENTS=~/projects/def-emd/huorobin/alignments
export RECIPE_STEP=2
export RH_MANIFEST=~/projects/def-emd/huorobin/hubert-training/LS.tsv
librispeech=~/scratch/LibriSpeech
user_dir=~/projects/def-emd/huorobin/fairseq/hubert-experiment
results=~/projects/def-emd/huorobin/results/cca
sample="${DATA_SAMPLE:-1}"
model_name="${MODEL_NAME:-hubert_small}"

while (( $# )); do
    ckpt="$1"
    shift
    [ -f "$ckpt" ] || { echo "Error: $ckpt does not exist!"; exit 2; }
    model="$(basename "$(dirname "$ckpt")")"
    ln -fs "$(realpath "$ckpt")" $model_name.pt
    rm -r data_samples logs save
    bash examples/recipe.sh "$librispeech" . "$user_dir"
    bash examples/extract_cca_results.sh "$model" logs/librispeech_$model_name "$results/$model.$sample.tsv"
done
