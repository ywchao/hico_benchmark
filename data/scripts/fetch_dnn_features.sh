#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )"
URL=http://napoli18.eecs.umich.edu/public_html/data/iccv_2015/precomputed_dnn_features.tar.gz
FILE=$DIR/precomputed_dnn_features.tar.gz

if [ ! -f "$FILE" ]; then
  echo "Downloading precomputed DNN features (1.4G)..."
  wget $URL -P $DIR;
fi

echo "Unzipping..."
tar -zxvf $FILE -C $DIR

echo "Done."
