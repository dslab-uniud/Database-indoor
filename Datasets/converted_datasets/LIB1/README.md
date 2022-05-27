# LIB1

This directory contains the dataset LIB1, converted to satisfy the format expected by the indoor database loading procedure.

The dataset models a two-floor library at the Universitat Jaume I, Spain. The data within it have been collected during the year 2016. More information can be found in the paper [Long-Term WiFi Fingerprinting Dataset for Research on Robust Indoor Positioning](https://www.mdpi.com/2306-5729/3/1/3).

## Files included

* files in the format expected by the indoor database loading procedure:
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/devices.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/users.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/tessellations.csv)
  * [adjacences.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/adjacences.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/fingerprints.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/LIB1/wifi_obs.csv)
* the tessellation strategy used to import the dataset is the _logical_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/LIB/LIB1/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/lib_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
