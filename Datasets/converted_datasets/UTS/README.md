# UTS

This directory contains the dataset UTS, converted to satisfy the format expected by the indoor database loading procedure.

The dataset has been collected at the FEIT Building at University of Technology Sydney (UTS), and it is referred to as UTSIndoorLoc. It models a large and complex multi-floor scenario. More information can be found in the paper [A Novel Convolutional Neural Network Based Indoor Localization Framework With WiFi Fingerprinting]([https://ieeexplore.ieee.org/document/7275492](https://ieeexplore.ieee.org/document/8792196)).

## Files included

* files in the format expected by the indoor database loading procedure:
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/devices.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/users.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/tessellations.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/fingerprints.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/UTS/wifi_obs.csv)
* the tessellation strategy used to import the dataset is the _logical_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/UTS/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/uts_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
