# Datasets

This directory collects a series of well-known datasets. Each of them has been converted into a format (that is explained in the remainder of this README file) that makes it ready to be imported in the indoor positioning database by means of the procedure LINK 

The following datasets are included:
* [**UJI1**](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/UJI1): it has been collected at the Universitat Jaume I, and in the literature it is usually referred to as UJIIndoorLoc. It models a large and complex multi-building scenario. 
* **[DSI1](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/DSI1), [DSI2](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/DSI2), [DSI_trajectories](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/DSI_trajectories)**: these datasets have been collected in the same building of the University of Minho, Portugal. The first one is obtained from the second one by removing fingerprints sampled at the same reference position. As for the third one, it contains a single trajectory of fingeprints collected by a user. 
* **[LIB1](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/LIB1), [LIB2](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/LIB2)**: they model a two-floor library at the Universitat Jaume I, Spain. The main difference between them is in the acquisition date: 2016 for the former, and 2017 for the latter. 
* **[SIM001](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM001), [SIM002](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM002), [SIM003](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM003), [SIM004](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM004), [SIM005](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM005), [SIM006](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM006), [SIM007](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM007), [SIM008](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM008), [SIM009](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM009), [SIM010](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/SIM010)**: these are synthetic datasets, generated accoording to a simple path loss model with additive Gaussian noise.
* **[TUT1](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT1), [TUT2](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT2), [TUT3](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT3), [TUT4](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT4), [TUT5](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT5), [TUT6](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT6), [TUT7](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets/raw_db/TUT7)**:

They key idea is that each premise, at its most detailed level of representation, includes a set of tiles. For instance, a building floor might have been associated to a tessellation following a grid strategy. Then, fingerprints may be collected at specific tiles. Also the adjacency and reachability relationships among premises are modeled at the tile level. For more information, please refer to the paper presenting the database.


## Dataset format

Each dataset should be described by a series of CSV (comma-separated) files. Some of them are mandatory, while others can be omitted:
* **dataset_metadata.csv**: it containes metadata about the datasets (e.g., the link to the origianal paper/repository) (OPTIONAL)
* **devices.csv**: it contains all information regarding the devices that have been used to collect the fingerprints (OPTIONAL)
* **users.csv**: it contains all information regarding the users that have collected the fingerprints (OPTIONAL)
* **places.csv**: it contains all information regarding the structure of the premises that are useful for positioning purposes (MANDATORY)
* **tessellations.csv**: it contains all information regarding the defined tessellations and their tiles (MANDATORY)
* **adjacences.csv**: it contains all information related to the adjacences and reachability among tiles (OPTIONAL)
* **fingerprints.csv**: it contains all the meta-information pertaining to the collected fingerprints (MANDATORY)
* **wifi_obs.csv**: it contains all information related to the wifi observations pertaining to the fingerprints (OPTIONAL)
* \[other possible observation files related to the fingerprints\] 



**IMPORTANT!** 
In every file described in the following:
* optional values left unassigned are to be denoted with the word NULL
* the word nan should not be used anywhere in the files
* the character `_` should not be used anywhere in the files
* the usage of the string `none` alone within a field must be avoided
* float separator is "."
* field separator is ","
* strings should not have any kind of enclosing characters 


### dataset_metadata.csv:
* A single row composed of two fields without headers:
  * link to the paper or repository of the original datasets collectors (OPTIONAL, string)
  * free textual description of the datasets (OPTIONAL, string)


### devices.csv:
* Columns:
  * **device_id** : identifier of the device that has been used to collect the fingerprints (MANDATORY, string)
  * **device_model** : the model of the device that has been used to collect the fingerprints, e.g., A50 (OPTIONAL: must be specified if device_manufacturer is specified, string)
  * **device_manufacturer** : the manufacturer of the device that has been used to collect the fingerprints, e.g., Samsung (OPTIONAL: must be specified if device_model is specified, string)
  * **device_type** : 'smartphone', 'tablet', or 'other' (OPTIONAL: must be specified if device_model or device_manufacturer are specified, string)
  * **notes** : free annotation related to the device (OPTIONAL, string)
* Usage notes:
  * the file includes information regarding all single devices that have been used to collect the fingerprints
  * there may be two entries with the same device_model/device_manufacturer/device_type but with a different device_id; this corresponds to a case when two distinct devices with the same characteristics have been used to collect the fingerprints


### users.csv:
* Columns:
  * **user_id** : identifier of the user that has collected some fingerprints (MANDATORY, string)
  * **username** : mnemonic of the user that has collected some fingerprints (OPTIONAL, string)
  * **type** : either 'trusted' for users that collected fingerprints at database creation time, or 'online', for users that use the system for positioning purposes (MANDATORY, string)
  * **notes** : free annotation related to the user (OPTIONAL, string)
* Usage notes:
  * the file includes information regarding all users that have been colecting the fingerprints, either in the offline or online phase of the positioning system


### places.csv:
* Columns:
  * **building** : name of the building (MANDATORY, string)
  * **floor** : name of the floor (OPTIONAL: must be specified if site is specified, string)
  * **floor_number** : number of the floor (OPTIONAL: must be specified if floor is specified, string)
  * **site** : name of the site (OPTIONAL, string)
  * **site_height** : the height in meters of the site (OPTIONAL, numeric)
  * **site_area** : the area in square meters of the site (OPTIONAL, numeric)
  * **floor_height** : the height in meters of the site (OPTIONAL, numeric)
  * **floor_area** : the area in square meters of the site (OPTIONAL, numeric)
  * **building_area** : the area in square meters of the building (OPTIONAL, numeric)
* Usage notes:
  * the file describes the containment relationships among buildings, floors, and sites
  * floor and site can be NULL; of course, if site is not NULL, then also floor must not be NULL, since a given site must be contained in a floor
  * character "_" MUST NOT BE USED within building, floor, and site names
  * floor : name of the floor (possibly, just its number as in dataset UJI1)
  * floor_number : number of the floor (e.g., from 0 to n) 



### tessellations.csv:
* Columns:
  * **building** : name of the building, among those that are in the file "places.csv" (MANDATORY, string)
  * **floor** : name of the floor, among those that are in the file "places.csv" (MANDATORY, string)
  * **site** : name of the site, among those that are in the file "places.csv" (OPTIONAL: has to be specified if the tile is of type logical or zone, string)
  * **tile** : name of the tile (MANDATORY, string)
  * **tessellation_type** : 'logical', 'zone', 'grid', 'crowd' (MANDATORY, string)
  * **coord_a_x** : coordinate x of the first point referred to the tile (OPTIONAL, float)
  * **coord_a_y** : coordinate y of the first point referred to the tile (OPTIONAL, float)
  * **coord_b_x** : coordinate x of the second point referred to the tile (OPTIONAL, float)
  * **coord_b_y** : coordinate y of the second point referred to the tile (OPTIONAL, float)
  * **coord_c_x** : coordinate x of the third point referred to the tile (OPTIONAL, float)
  * **coord_c_y** : coordinate y of the third point referred to the tile (OPTIONAL, float)
  * **coord_d_x** : coordinate x of the fourth point referred to the tile (OPTIONAL, float)
  * **coord_d_y** : coordinate y of the fourth point referred to the tile (OPTIONAL, float)
* Usage notes:
  * the file stores information regarding fingerprints that are collected within the indoor premises
  * for logical tiles, only the first pair of coordinates may be given a value. If left without a value, then the coordinates of the logical tile
		  will be derived by averaging the coordinates of all training radio map fingerprints pertaining to the tile. The tile is contained into a specific site or floor. Observe that multiple logical tiles may be associated to a same site or floor. This is the case of the tessellation used in dataset UJI1
  * for zone tiles, all pairs of coordinates should be given a value. The coordinates determine the convex hull of the tile. The tile is contained 
		  into a specific site or floor
  * for grid tiles, all pairs of coordinates should be given a value. The tiles should define a grid within a given floor, thus the cells should all
		  have the same shape and size, and they are not linked to a specific site, but to a floor; thus, site is NULL
  * a tile of type crowd can only be associated to a floor. Vice-versa, a floor must contain at most one tile of type crowd, which acts as a kind of dummy container for all fingerprints collected in a crowdsourced fashion within the floor. A crowd tile does not have any coordinates, by its nature
  * given a floor, the structure of the file allows to implicitly specify up to one tessellation for each kind, uniform with respect to the kind tiles included in it
  * the same tile cannot belong to two different tessellations (thus there must not be repeated tile names within the same floor)
  * character "_" MUST NOT BE USED within tile names



### adjacences.csv:
* Columns:
  * **tile_1_building** : name of the building (as specified in the file places.csv) of the departure tile (MANDATORY, string)
  * **tile_1_floor** : name of the floor (as specified in the file places.csv) of the departure tile (MANDATORY, string)
  * **tile_1_site** : name of the site (as specified in the file places.csv) of the departure tile (MANDATORY, string)
  * **tile_1_tile** : name of the tile (as specified in the file places.csv) of the departure tile (MANDATORY, string)
  * **tile_2_building** : name of the building (as specified in the file places.csv) of the arrival tile (MANDATORY, string)
  * **tile_2_floor** : name of the floor (as specified in the file places.csv) of the arrival tile (MANDATORY, string)
  * **tile_2_site** : name of the site (as specified in the file places.csv) of the arrival tile (MANDATORY, string)
  * **tile_2_tile** : name of the tile (as specified in the file places.csv) of the arrival tile (MANDATORY, string)	
  * **walkable** : 1 = tiles are adjacent and walkalble, 0 = tiles are adjacent but not walkable (MANDATORY, integer)
  * **cost** : walkability cost between the tiles, >= 0 (MANDATORY, numeric) 
* Usage notes:
  * this file models adjacency and traversability relationships between couples of tiles 




### fingerprints.csv:
* Columns:
  * **fingerprint_id** : identifier of a fingerprint used to link auxiliary information from observations files, such as "wifi_obs.csv" (MANDATORY, integer)
  * **coord_x** : coordinate x in which the fingerprint has been collected (OPTIONAL, float)
  * **coord_y** : coordinate y in which the fingerprint has been collected (OPTIONAL, float)
  * **coord_z** : coordinate z in which the fingerprint has been collected (OPTIONAL, float)
  * **building** : name of the building in which the fingerprint has been collected, among those that are in the file "tessellations.csv" (OPTIONAL: must be specified if floor is specified, string)
  * **floor** : name of the floor in which the fingerprint has been collected, among those that are in the file "tessellations.csv" (OPTIONAL: must be specified if site is specified, string)
  * **site** : name of the site in which the fingerprint has been collected, among those that are in the file "tessellations.csv" (OPTIONAL, string)
  * **tile** : name of the tile in which the fingerprint has been collected, among those that are in the file "tessellations.csv" (OPTIONAL: must be specified for radio map fingerprints, integer)
  * **user_id** : identifier of the user that has collected the fingerprint (OPTIONAL, string)
  * **device_id** : identifier of the device that has been used to collect the fingerprint (OPTIONAL, string)
  * **epoch** : time instant in which the fingerprint has been collected, in EPOCH (OPTIONAL, integer)
  * **set** : machine learning purpose of the fingerprint, among: 'training', 'validation', or 'test' (OPTIONAL)
  * **is_radio_map** : boolean value telling whether the fingerprint is part of the radio map or not (MANDATORY, string 'True' or 'False')
  * **preceded_by** : id of the fingerprint that precedes the current fingerprint (OPTIONAL, integer)
  * **followed_by** : id of the fingerprint that follows the current fingerprint (OPTIONAL, integer)
  * **notes** : free annotation related to the fingerprint (OPTIONAL, string)
* Usage notes:
  * if is_radio_map == 'True', then the fingerprint must be associated to a tile; otherwise, that may not be the case (e.g., for fingerprints collected during the online phase of the positioning system by a user that wants to be localized)
  * for each user_id, there must be a corresponding entry in file "users.csv"
  * for each device_id, there must be a corresponding entry in file "devices.csv"
  * of course, the consistency of the fields has always to be maintained; for instance, if a fingerprint is collected following a logical tessellation criterion, building, floor, (possibly) site, and tile must all be non-NULL
  * observe that no information regarding the predicted locations of fingerprints is recorded in this file
  * note that a fingerprint with an IMU observation must always have a preceding fingerprint, since the IMU values are those with respect to the previous fingerprint
		
		
		

### wifi_obs.csv:
* Columnns:
  * **fingerprint_id**: identifier of a fingerprint used to link information from file "fingerprints.csv" (MANDATORY, integer)
  * **AP-xxx-mac**: each attribute of this kind contains the received RSS (numeric) from the respective access point, labeled following the convention
 AP-xxx-mac. RSS values must be <= 0; APs that are not detected must have NULL as their RSS (MANDATORY, numeric)
* Usage notes:
  * in AP-xxx-mac, xxx represents the code of the access point used within the dataset (it can be a simple numeric incremental value as in the dataset UJI1), while mac represents the mac address of the respective access point (if not present, it can be set as the word NULL)
  * e.g., in the file I may find the attributes: AP-WAP1-NULL, AP-WAP2-NULL, ...
		
		
		

### bluetooth_obs.csv:
* Columnns:
  * **fingerprint_id**: identifier of a fingerprint used to link information from file "fingerprints.csv" (MANDATORY, integer)
  * **BL-xxx-mac**: each attribute of this kind contains the received RSS (numeric) from the respective access point, labeled following the convention
 BL-xxx-mac. RSS values must be <= 0; APs that are not detected must have NULL as their RSS (MANDATORY, numeric)
* Usage notes:
  * in BL-xxx-mac, xxx represents the code of the access point used within the dataset (it can be a simple numeric incremental value as in the dataset IPIN 2021), while mac represents the mac address of the respective bluetooth beacon (if not present, it can be set as the word NULL)
  * e.g., in the file I may find the attributes: BL-BLE001-NULL, BL-BLE002-NULL, ...	






## Current limitations (only concerning bulk importing from files)
* no support to specify a description for a place (field "description" of table "place")
* no support to specify the adjacencies between buildings (table "adjacent_to_building")
* no support to load information regarding predictions (table "estimation" and table "predicted at")
* no support to cell observations (tables: cell, cell_detection, observation_cellular)






## Final remarks on information sharing between datasets

The dataset has been designed to allow information sharing between datasets. For instance, if the same building appears into two different datasets, it appears only a single time within the database, connected to the two datasets.

During the import process, information sharing has only been partially implemented:
* if a device model is already present in the database public schema, then it will not be imported
* if a tuple of a data source is already present in the database public schema, then the import will halt

All other kinds of redundancies/information sharing will have - at least for now - to be handled after the import process, throught a series of update statements to be performed directly on the indoor positioning database.

