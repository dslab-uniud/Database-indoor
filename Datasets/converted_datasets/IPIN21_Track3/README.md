# IPIN21_Track3

This directory contains the dataset IPIN21_Track3, converted to satisfy the format expected by the indoor database loading procedure.

The dataset was used within the "IPIN 2021 Indoor Localization Competition: Track 3 Smartphone-based (off-site)", and it is interesting as it includes fingerprint trajectories. In addition, fingerprints are quite heterogeneous since they may contain information pertaining to Bluetooth, GNSS, IMU, or WiFi signals. Here, only the training data split is considered. [Link to the original source](http://indoorloc.uji.es/ipin2021track3/)


## Files included

* files in the format expected by the indoor database loading procedure:
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/devices.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/fingerprints.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/tessellations.csv)
  * [users.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/users.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/wifi_obs.csv)
  * [blue_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/blue_obs.csv)
  * [gnss_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/gnss_obs.csv)
  * [imu_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/IPIN21_Track3/imu_obs.csv)

* the tessellation strategy used to import the dataset is the _logical_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/IPIN21_Track3/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/ipin_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
