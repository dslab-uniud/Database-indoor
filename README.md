---

<div align="center">  
  
  
# A Framework for Indoor Positioning including Building Topology
  
</div>

## Description 

This is the home page of the relational indoor positioning database project, developed within the Data Science and Automatic Verification Laboratory at the University of Udine, Italy.

The database aims to pose itself as an integrated and generalizable framework to store, manage and leverage fingeprint positioning data collected by multiple sensors within indoor premises.

<p align="center">
<img src="https://user-images.githubusercontent.com/11720495/167165947-d5138baf-c243-4f97-ba53-7a44d8e56aae.png" alt="Overall Entity-Relationship diagram" />
</p>

The database schema, which is depcited in the figure above, is divided into four main sub-schemas:
* **fingerprint sub-schema**: it stores information regarding collected (trajectories of) fingerprints, such as their exact sampling location (e.g., if they belong to the radio-map), the users that collected them, and the employed devices
* **observation sub-schema**: it stores information regarding a series of data that may have been observed by multiple sensors, including Wi-Fi, Bluetooth, GNSS, Cellular and Inertial Measurement Unit signals, that are all linked to a fingerprint
* **place sub-schema**: it stores informaton regarding the structure of indoor premises, including all and limited to the data that are useful for positioning purposes (such as containment and adjacency relationships between locations), without any pretense (or actual need) of being capable of representing the actual layout of the premises
* **data_source sub-schema**: it stores informaton regarding data lineage

The current repository includes:
* the code to set up the database within a Postgres database instance: link
* the code to import a new dataset into the database: link
* the code of some queries that show how to use the database: link
* some well-known and widely-used datasets that have already been converted into the format expected by the import procedure: [link](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets)

The database is highly modular, and can be easily extended to handle specific usage needs.

### Usage of the online implementation of the system

The system can be accessed at the address [http://158.110.145.70:5050/](http://158.110.145.70:5050/). Upon connection, users will find a _pgAdmin_ web server interface, asking for the login data. 
A read-only user, that has the privileges to perform `SELECT` operations over the _public_ and _evaluation_support_ schemas of the database _Open_Fingerprinting_ has been provided, with the following credentials: 
```
username = tester@indoor.uniud.it
password = tSUD22$Indo0r
```
The database comes already populated with information originating from the datasets listed [here](https://github.com/dslab-uniud/Database-indoor/tree/main/Datasets)

### Entity-Relationship diagram notation

Here we describe, by means of a series of examples, the notation employed in the above Entity-Relationship diagram. The figure below depicts a strong entity set named _Person_, that has a primary key composed of the attributes _Name_ and _Surname_. Each entity of _Person_ may have at most one _Email_ address, and one or more _Phone_ numbers. In addition, it always has a _Birthdate_, based on which the value for the derived attribute _Age_ is established.

<p align="center">
<img src="https://user-images.githubusercontent.com/11720495/167114573-43821183-cbf9-47da-a196-970795fa8fbf.png" alt="Strong entity set notation" />
</p>

The folliwing figure reports the case of a weak entity set, named _Song_, that has the attribute _Title_ as its partial identifier. Its identifying relationship is _Belongs to_, thus, the title of a song is unique within a given album. The entity set _Album_ has _Name_ as its primary key. Each album contains one or more songs, and a song belongs to one and only one album (the constraint `1:1` is assumed by default by our notation, and thus has been omitted on the _Song_ side of the relationship).

<p align="center">
<img src="https://user-images.githubusercontent.com/11720495/167114364-410bc3cb-febd-4525-862b-20d69ee77e41.png" alt="Weak entity set notation" />
</p>

The notation for a total and disjoint specialization is showed below. Each entity of entity set _Professor_ is uniquely identified by its _SSN_, and it corresponds to either a _Full_ or an _Associate_ professor.

<p align="center">
<img src="https://user-images.githubusercontent.com/11720495/167114699-341eac19-d438-4d24-82e2-06615a9f3aca.png" alt="Total specialization notation" />
</p>

Finally, we report the case of a partial specialization. Here, an entity of entity set _Employee_, uniquely identified by its _SSN_, can also be an entity of entity set _Supervisor_. This is quite natural, since supervisors are themselves employees, but not all employees are supervisors.

<p align="center">
<img src="https://user-images.githubusercontent.com/11720495/167114720-6c3cd3ea-e23c-44fe-9150-06199218ba6f.png" alt="Partial specialization notation" />
</p>


<!---
### Citation   
```
@article{DBLP:journals/artmed/BernardiniBGMS21,
  author    = {Andrea Bernardini and
               Andrea Brunello and
               Gian Luigi Gigli and
               Angelo Montanari and
               Nicola Saccomanno},
  title     = {{AIOSA:} An approach to the automatic identification of obstructive
               sleep apnea events based on deep learning},
  journal   = {Artif. Intell. Medicine},
  volume    = {118},
  pages     = {102133},
  year      = {2021},
  url       = {https://doi.org/10.1016/j.artmed.2021.102133},
  doi       = {10.1016/j.artmed.2021.102133},
  timestamp = {Mon, 03 Jan 2022 22:00:55 +0100},
  biburl    = {https://dblp.org/rec/journals/artmed/BernardiniBGMS21.bib},
  bibsource = {dblp computer science bibliography, https://dblp.org}
}
```   
-->
