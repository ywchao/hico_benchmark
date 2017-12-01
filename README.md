# HICO Benchmark

Code for reproducing the results in the following paper:

**HICO: A Benchmark for Recognizing Human-Object Interactions in Images**  
Yu-Wei Chao, Zhan Wang, Yugeng He, Jiaxuan Wang, and Jia Deng  
IEEE International Conference on Computer Vision (ICCV), 2015 

Check out the [project site](http://www.umich.edu/~ywchao/hico/) for more details.

### Citing HICO Benchmark

Please cite HICO Benchmark in your publications if it helps your research:

    @INPROCEEDINGS{chao:iccv2015,
      author = {Yu-Wei Chao and Zhan Wang and Yugeng He and Jiaxuan Wang and Jia Deng},
      title = {HICO: A Benchmark for Recognizing Human-Object Interactions in Images},
      booktitle = {Proceedings of the IEEE International Conference on Computer Vision},
      year = {2015},
    }

### Setup

1. Download and extract the HICO dataset.

    ```Shell
    wget http://napoli18.eecs.umich.edu/public_html/data/hico_20150920.tar.gz
    tar -zxvf hico_20150920.tar.gz
    ```

2. Clone this repo and change the directory.

    ```Shell
    git clone https://github.com/ywchao/hico_benchmark.git
    cd hico_benchmark
    ```

3. Create symlinks for the downloaded HICO dataset. `$HICO_ROOT` should contain `images`, `anno.mat`, and `README`.

    ```Shell
    ln -sf $HICO_ROOT ./external/hico_20150920
    ```

### Download pre-computed DNN features

Our pre-computed DNN features guarantee exact reproduction of the paper's results.

  ```Shell
  ./data/scripts/fetch_dnn_features.sh
  ```

This will populate the `data` folder with `precomputed_dnn_features`.

### Training and evaluating HOI classifiers
1. Start MATLAB `matlab` under `hico_benchmark`. You should see the message `added paths for the experiment!` followed by the MATLAB prompt `>>`.

2. Run `setup` to prepare the required files.
    - Generate the annotation file `anno_iccv.mat` from `anno.mat`. For the default evaluation setting, we add extra ground-truth negatives by sampling "unknown" images for each HOI class (see the paper for details). Using the provided sample set is necessary for exact reproduction of the paper's result.
    - Download and build `liblinear`.

3. The training code will use `parfor`. Uncomment and set `poolsize` in `config.m` according to your need, or leave it commented out if you want MATLAB to set it automatically.

4. Run `train_svm_vo` to start the training of HOI classifiers.
    - By default, the code will run training with DNN features from Alex's Net pretrained on ImageNet, i.e. the "DNN (ImageNet)" in the paper.
    - The code also supports training with the Fine-tune V, Fine-tune O, and Fine-tune VO features, i.e. the "DNN (fine-tune V)", "DNN (fine-tune O)", and "DNN (fine-tune VO)" in the paper. Simply comment out or uncomment each line below in `train_svm_vo.m` to select a feature type.

      ```Shell
      feat_type = 'imagenet';
      % feat_type = 'ft_verb';
      % feat_type = 'ft_object';
      % feat_type = 'ft_action';
      ```

5. Run `eval_default_run` or `eval_ko_run` to evaluate the trained HOI classifiers in the default or "Known Object (KO)" setting.
    - The code will output mean average precision (mAP) on 600 HOI classes.
    - Similar to `train_svm_vo.m`, you can select the feature type by editing `eval_default_run.m` and `eval_ko_run.m`.

### Notes on our training procedure:
- The HICO dataset provides positive and negative examples for each HOI category. Positive examples are images containing the HOI, e.g. images with "riding a bicycle." Negative examples are images containing the object but not the HOI, e.g. images with "bicycle" but not "riding a bicycle."
- We train one SVM classifier for each HOI category using these positives and negatives. In addition, we augment the negative examples by sampling additional images from the "Unknown" images (e.g. images containing no bicycles) until the total number of training examples (i.e. number of positives + number of negatives) is 5000. The limit of 5000 images is due to a memory limitation of our SVM training. The augmented training set is saved to `anno_iccv.mat`.
- We have been made aware that it may be possible to obtain significantly better results for the default evaluation setting by removing the 5000 limit, and that it may be possible to obtain significantly better results for the “Known Object” setting by doing away with the augmentation.
