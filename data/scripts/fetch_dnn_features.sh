#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
ID=161Y8knDilXygyjlbH0ZR3arut0WO3E3z
FILE=$DIR/precomputed_dnn_features.tar.gz

if [ ! -f "$FILE" ]; then
  echo "Downloading precomputed DNN features (1.4G)..."
  wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&id=$ID" -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1/p')&id=$ID" -O $FILE && rm -rf /tmp/cookies.txt
fi

echo "Unzipping..."
tar -zxvf $FILE -C $DIR

echo "Done."
