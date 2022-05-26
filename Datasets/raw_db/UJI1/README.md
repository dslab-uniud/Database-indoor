# UJI1

This directory contains the dataset UJI1, converted to satisfy the format expected by the indoor database loading procedure.

The dataset has been collected at the Universitat Jaume I, and in the literature it is usually referred to as UJIIndoorLoc. It models a large and complex multi-building scenario. More information can be found in the paper [UJIIndoorLoc: A new multi-building and multi-floor database for WLAN fingerprint-based indoor localization problems](https://ieeexplore.ieee.org/document/7275492).

## Files included

* files in the format expected by the indoor database loading procedure:
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/devices.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/users.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/tessellations.csv)
  * [adjacences.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/adjacences.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/fingerprints.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/UJI1/wifi_obs.csv)
* the tesselation strategy used to import the dataset is the _logical_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/raw_datasets/UJI1/), divided into training and test data. Such directory contains also (a subset of) the adjacency relationships between the tiles/places reconstructed looking at the [original map](http://indoorloc.uji.es/webviewer/#).
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_db/uji_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", "users.csv", and "adjacences.csv" which have been assembled by hand.
