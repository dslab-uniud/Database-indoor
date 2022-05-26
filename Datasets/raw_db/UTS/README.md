# UTS

This directory contains the dataset UTS, converted to satisfy the format expected by the indoor database loading procedure.

The dataset has been collected at the FEIT Building at University of Technology Sydney (UTS), and it is refferred to as UTSIndoorLoc. It models a large and complex multi-floor scenario. More information can be found in the paper [A Novel Convolutional Neural Network Based Indoor Localization Framework With WiFi Fingerprinting]([https://ieeexplore.ieee.org/document/7275492](https://ieeexplore.ieee.org/document/8792196)).

## Files included

* files in the format expected by the indoor database loading procedure:
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/devices.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/users.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/tessellations.csv)
  * [adjacences.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/adjacences.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/fingerprints.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UTS/wifi_obs.csv)
* the tesselation strategy used to import the dataset is the _crowd_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/raw_datasets/UTS/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/uts_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
