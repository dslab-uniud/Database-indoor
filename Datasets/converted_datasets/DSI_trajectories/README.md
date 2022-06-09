# DSI_trajectories

This directory contains the dataset DSI_trajectories, converted to satisfy the format expected by the indoor database loading procedure.

DSI_trajectories has been collected in the same building of the University of Minho, Portugal as the datasets DSI1 and DSI2. As a difference with respect to the latter two ones, DSI_trajectories includes fingerprint trajectories.. [Link to the original source](https://zenodo.org/record/3778646#.YnPqGNpByUk)


## Files included

* files in the format expected by the indoor database loading procedure:
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/devices.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/fingerprints.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/tessellations.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/users.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/DSI_trajectories/wifi_obs.csv)
* the tessellation strategy used to import the dataset is the _crowd_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/DSI/DSI_trajectories/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/dsi_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
