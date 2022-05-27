# Database

This directory contains:
* the DDL (Data Definition Language) SQL code that can be used to deploy the relational indoor positioning database into a running Postgres database instance
* a set of files that can be used to handle the import process of data into the database
   * [data_import.ipynb](https://github.com/dslab-uniud/Database-indoor/blob/main/Database/data_import.ipynb) that performs the import of a new dataset, encoded according to [our proposed format](https://github.com/dslab-uniud/Database-indoor/blob/main/Datasets/README.md), into the indoor positioning database
   * [merge_dataset_information.sql](https://github.com/dslab-uniud/Database-indoor/tree/main/Database/merge_dataset_information.sql): it contains a list of queries that can be used to merge information that are in common between two different datasets (e.g., if they consider the same premises)
   * [verify_dataset_info.sql](https://github.com/dslab-uniud/Database-indoor/tree/main/Database/verify_dataset_info.sql): it contains a set of queries that are useful to verify the correctness of the information stored in the database
* a file containing some exemplary SQL queries that can be run over the data contained in the indoor positioning database


The overall logical schema implemented by the DDL script is as follows (clicking opens up a hi-res version of the picture):

<p align="center">
<img src="https://user-images.githubusercontent.com/45127628/170011003-fc2e5b72-3e69-4fe6-8d15-e3222fc01237.png" alt="Overall Logical Schema of the Database" />
</p>

Specifically, the DDL script builds 4 schemas:
* **public**: the main database schema, where the indoor positioning data is stored (red circled areas in the picture above)
* **evaluation_support**: it contains just the table ground_truth_info, which is useful for the evaluation of indoor positioning approaches (blue shaded area in the picture above)
* **data_staging**: it holds temporary information that help to carry out the import process of new data into the database
* **return_types**: it models the return types of some user defined functions
* **communication**: it contains just a table, imported_ids, which is useful for technical data lineage purposes related to the data import process
