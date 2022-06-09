# TUT4

This directory contains the dataset TUT4, converted to satisfy the format expected by the indoor database loading procedure.

All TUT datasets have been collected at the Tampere University, Finland. TUT1, TUT3, TUT4 (which is TUT3 with inverted training and test sets), and TUT6 all consider the same five-floor building, and differ from one another in their collection strategies. TUT1 relies on cell averaging with a grid size of 1 meter, TUT3 is based on crowdsourcing, and TUT6 is collected according to a logical tessellation criterion. As for TUT2, TUT5, and TUT7, they have been independently collected in the same three-floor university building. TUT5 follows an approach similar to TUT1, since it considers cell averaging with a 5 meter grid size, while the way in which TUT2 and TUT7 have been collected is similar to that of TUT6. [Link to the original source](https://zenodo.org/record/889798#.YnzCMhNBw-R).

## Files included

* files in the format expected by the indoor database loading procedure:
  * [dataset_metadata.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/TUT4/dataset_metadata.csv)
  * [devices.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/TUT4/devices.csv)
  * [fingerprints.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/TUT4/fingerprints.csv)
  * [places.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/TUT4/places.csv)
  * [tessellations.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/TUT4/tessellations.csv)
  * [wifi_obs.csv](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/converted_datasets/TUT4/wifi_obs.csv)
* the tessellation strategy used to import the dataset is the _crowd_ one.
* directory containing the [original dataset](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/raw_datasets/TUT/TUT4/) in Python pickle format.
* [Jupyter notebook](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/tut_convert.ipynb) to convert the original dataset into our proposed format. It generates all files except for "devices.csv", and "users.csv" which have been assembled by hand.
