# SIM001

This directory contains the dataset SIM001, converted to satisfy the format expected by the indoor database loading procedure.

SIM datasets are all synthetic datasets, generated according to a simple path loss model with additive Gaussian noise. [Link to the original source](https://www.mdpi.com/1424-8220/17/12/2736).

## Files included

* files in the format expected by the indoor database loading procedure:
  * [adjacences.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/adjacences.csv)
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/devices.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/fingerprints.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/tessellations.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/users.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/SIM001/wifi_obs.csv)
* the tessellation strategy used to import the dataset is the _grid_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/SIM/SIM001/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/sim_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
