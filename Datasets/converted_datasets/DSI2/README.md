# DSI2

This directory contains the dataset DSI2, converted to satisfy the format expected by the indoor database loading procedure.

DSI~1 and DSI~2 have been collected in the same building of the University of Minho, Portugal. The first one is obtained from the second one by removing fingerprints (FPs) sampled at the same RP. [Link to the original source](https://zenodo.org/record/3778646#.YnPqGNpByUk)


## Files included

* files in the format expected by the indoor database loading procedure:
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/devices.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/fingerprints.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/tessellations.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/users.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI2/wifi_obs.csv)
* the tessellation strategy used to import the dataset is the _logical_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/DSI/DSI2/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/dsi_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
