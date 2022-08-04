# Database

This directory contains:
* the [DDL (Data Definition Language) SQL code](https://github.com/dslab-uniud/Database-indoor/blob/main/Database/DDL.sql) that can be used to deploy the relational indoor positioning database into a running Postgres database instance. Specifically, the DDL script builds 4 schemas:
  * **public**: the main database schema, where the indoor positioning data is stored (red circled areas in the picture above)
  * **evaluation_support**: it contains just the table ground_truth_info, which is useful for the evaluation of indoor positioning approaches (blue shaded area in the picture above)
  * **data_staging**: it holds temporary information that help to carry out the import process of new data into the database
  * **return_types**: it models the return types of some user defined functions
  * **communication**: it contains just a table, imported_ids, which is useful for technical data lineage purposes related to the data import process

* a set of files that can be used to handle the import process of data into the database
   * [data_import.ipynb](https://github.com/dslab-uniud/Database-indoor/blob/main/Database/data_import.ipynb): it performs the import of a new dataset, encoded according to [our proposed format](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/README.md), into the indoor positioning database
   * [merge_dataset_information.sql](https://github.com/dslab-uniud/Database-indoor/tree/main/Database/merge_dataset_information.sql): it contains a list of queries that can be used to merge information that are in common between two different datasets (e.g., if they consider the same premises)
   * [verify_dataset_info.sql](https://github.com/dslab-uniud/Database-indoor/tree/main/Database/verify_dataset_info.sql): it contains a set of queries that are useful to verify the correctness of the information stored in the database
* a [file](https://github.com/dslab-uniud/Database-indoor/blob/main/Database/exemplary_SQL.sql) containing some exemplary SQL queries that can be run over the data contained in the indoor positioning database


## Database logical schema

The overall logical schema implemented by the DDL script is as follows (clicking opens up a hi-res version of the picture):

<p align="center">
<img src="https://user-images.githubusercontent.com/45127628/170011003-fc2e5b72-3e69-4fe6-8d15-e3222fc01237.png" alt="Overall Logical Schema of the Database" />
</p>


## Implemented User Defined Functions

Some useful User Defined Functions have already been implemented within the DDL code that deploys the database. They include:
* `data_staging.copy_tables()`: it is a helper function, used within the import process, to move data from the data_staging to the public schema of the database
* `data_staging.truncate_tables(schemaname_in VARCHAR)`: it is a helper function, used within the import process, to truncate all the data contained within a given database schema; specifically, it is used to clean the data_staging schema at the beginning of each new import process
* `array_reverse(anyarray)`: given an array, it returns its reverse
* `euclidean_distance(l numeric[], r numeric[])`: given two numeric arrays representing coordinates, it returns the euclidean distance between the two
* `reachability_dijkstra(starting_tile_id_in integer, target_tile_set integer[], cost_or_hops varchar default 'hops')`: given two tile IDs and a strategy to calculate the path cost (either the number of hops or the cost stored into the table adjacent_to_tile), it returns the shortest path between the two input tiles in terms of IDs of the tiles thave have to be traversed, together with its cost and number of hops
* `FindRelatedTiles(object_id integer, object_type varchar)`: given an object identifier and its type, returns an array of tiles associated with it
* `MinimumShortestPath(start_id integer, end_id integer, start_obj_type varchar default 'tile', end_obj_type varchar default 'tile', cost_or_hops varchar default 'hops')`: given two object identifiers and their types, among fingerprint, estimation, tile, site, and floor, find the minimum shortest path between them
* `FPDistances(fp1_id integer, fp2_id integer, f1_type varchar default 'fingerprint', f2_type varchar default 'fingerprint')`: given two fingerprint (or estimation) identifiers, it returns the 2D and 3D euclidean distances between them and the minimum shortest path to go from the location associated with one fingeprint to that of the other
* `CharacterizingFP(obj_id integer)`: given a tile identifier returns the avarage (WiFi) fingerprint that represent it
* `GetTrajectory(f_id integer)`: given a fingerprint identifier returns the trajectory (array of fingerprint identifierds) to which it belongs
* `TrajectoriesInPlace(obj_id integer, obj_type varchar default 'tile')`: given a place identifier (tile, site, or floor) and its type returns all the trajectories passing trought it
