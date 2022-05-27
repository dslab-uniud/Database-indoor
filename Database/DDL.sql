BEGIN;



/******************************************************************************* PUBLIC SCHEMA *******************************************************************************/



DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;


COMMENT ON SCHEMA public is 'This is the main schema of the database, that is populated with the final, correct data.';


CREATE SEQUENCE indoor_seq START 1;


CREATE TABLE IF NOT EXISTS public.data_source
(
    id integer NOT NULL DEFAULT nextval('indoor_seq'),
    name character varying NOT NULL UNIQUE,
    notes character varying,
    url character varying,
    PRIMARY KEY (id)
);


COMMENT ON TABLE public.data_source IS 'Table used for data lineage purposes. Attribute ''name'' holds the unique name of the data source.';


CREATE TABLE IF NOT EXISTS public."user"
(
    id integer NOT NULL DEFAULT nextval('indoor_seq'),
    username character varying,
    code character varying NOT NULL,
    type_id integer NOT NULL,
    notes character varying,
    data_source_id integer NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT user_uc UNIQUE (code, data_source_id),
    CONSTRAINT user_uc2 UNIQUE (username, data_source_id)
);

COMMENT ON TABLE public."user"
    IS 'The users that collect the fingerprints. Type_id can be used to distinguish, for instance, between offline (trusted) and online users.';


CREATE TABLE IF NOT EXISTS public.user_type
(
    id integer DEFAULT nextval('indoor_seq'),
    description character varying NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT user_type_uc UNIQUE (description)
);

INSERT INTO public.user_type (description) VALUES 
('online'),
('trusted');

COMMENT ON TABLE public."user_type"
    IS 'The table collects the possible user types, for instance, offline (trusted) and online users.';



CREATE DOMAIN fingerprint_purpose AS TEXT
CHECK(
   VALUE = 'training'
OR VALUE = 'validation'
OR VALUE = 'test'
);

CREATE TABLE IF NOT EXISTS public.fingerprint
(
    id integer DEFAULT nextval('indoor_seq'),
    code integer NOT NULL,
    data_source_id integer NOT NULL,
    "timestamp" timestamp without time zone,
    coordinate_x numeric,
    coordinate_y numeric,
    coordinate_z numeric,
    preceded_by_fingerprint_id integer,
    followed_by_fingerprint_id integer,
    user_id integer,
    device_id integer,
    is_radio_map boolean NOT NULL,
    acquired_at_tile_place_id integer,
    ml_purpose fingerprint_purpose,
    notes character varying,
    PRIMARY KEY (id),
    CONSTRAINT fingerprint_uc UNIQUE (code, data_source_id)
);

COMMENT ON TABLE public.fingerprint
    IS 'Parent table of the fingerprint hierarchy, which has a partial specialization into radio map fingerprint (attribute is_radio_map). It is a weak entity with respect to the data source. Code is the partial identifier, and it represents, for instance, the row number in the original file. This is enforced by a unique constraint placed over (code, data_source_id), while fingerprint still has a surrogate key, named id. The timestamp is without timezone, so it is assumed that the original data is already converted to consider UTC time zone. Coordinate attributes pertain only to radio map fingerprints, as well as attribute acquired_at_tile_place_id. Attribute ml_purpose allows to keep track of the intended usage of the fingeprint in the original dataset, if any, among training, validation, test purposes.';




CREATE TABLE IF NOT EXISTS public.observation_cellular
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE public.observation_cellular
    IS 'Cellular data pertaining to the fingerprint, sensed around the environment.';




CREATE TABLE IF NOT EXISTS public.observation_wifi
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE public.observation_wifi
    IS 'WiFi data pertaining to the fingerprint, sensed around the environment.';




CREATE TABLE IF NOT EXISTS public.observation_gnss
(
    fingerprint_id integer,
    is_valid boolean,
    latitude numeric,
    longitude numeric,
    elevation numeric,
    num_satellites integer,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE public.observation_gnss
    IS 'GNSS data pertaining to the fingerprint, sensed around the environment.';



CREATE TABLE IF NOT EXISTS public.observation_imu
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE public.observation_imu
    IS 'IMU data pertaining to the fingerprint, sensed around the environment. In principle, an IMU observation contains differntial data with respect to a previous fingerprint.';




CREATE TABLE IF NOT EXISTS public.observation_imu_accelerometer
(
    fingerprint_id integer,
    epoch integer,
    axis_x numeric not null,
    axis_y numeric not null,
    axis_z numeric not null,
    PRIMARY KEY (fingerprint_id, epoch)
);

COMMENT ON TABLE public.observation_imu_accelerometer
    IS 'Accelerometer data pertaining to an IMU observation. In principle, an IMU observation may have several of these data, that can be discerned, among the same observation, by means of the attribute epoch. Being epoch of domain integer, this means that it can be used as a kind of timestamp, as well as a simple incremental value that orders the data within an obsvervation.';




CREATE TABLE IF NOT EXISTS public.observation_imu_gyroscope
(
    fingerprint_id integer,
    epoch integer,
    axis_x numeric not null,
    axis_y numeric not null,
    axis_z numeric not null,
    PRIMARY KEY (fingerprint_id, epoch)
);

COMMENT ON TABLE public.observation_imu_gyroscope
    IS 'Gyroscope data pertaining to an IMU observation. In principle, an IMU observation may have several of these data, that can be discerned, among the same observation, by means of the attribute epoch. Being epoch of domain integer, this means that it can be used as a kind of timestamp, as well as a simple incremental value that orders the data within an obsvervation.';



CREATE TABLE IF NOT EXISTS public.observation_imu_magnetometer
(
    fingerprint_id integer,
    epoch integer,
    axis_x numeric not null,
    axis_y numeric not null,
    axis_z numeric not null,
    PRIMARY KEY (fingerprint_id, epoch)
);

COMMENT ON TABLE public.observation_imu_magnetometer
    IS 'Magnetometer data pertaining to an IMU observation. In principle, an IMU observation may have several of these data, that can be discerned, among the same observation, by means of the attribute epoch. Being epoch of domain integer, this means that it can be used as a kind of timestamp, as well as a simple incremental value that orders the data within an obsvervation.';



CREATE TABLE IF NOT EXISTS public.observation_bluetooth
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE public.observation_bluetooth
    IS 'Bluetooth data pertaining to the fingerprint, sensed around the environment.';



CREATE TABLE IF NOT EXISTS public.cell
(
    id integer DEFAULT nextval('indoor_seq'),
    ci integer NOT NULL,
    lac integer NOT NULL,
    mnc integer NOT NULL,
    mcc integer NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT cell_uc UNIQUE (ci, lac, mnc, mcc) 
);

COMMENT ON TABLE public.cell
    IS 'A mobile network cell that can be sensed in the environment.';



CREATE TABLE IF NOT EXISTS public.ap
(
    id integer DEFAULT nextval('indoor_seq'),
    code character varying NOT NULL,
    mac character varying,
    PRIMARY KEY (id),
    CONSTRAINT ap_uc UNIQUE (mac)
);

COMMENT ON TABLE public.ap
    IS 'A WiFi access point that can be sensed around the environment.';



CREATE TABLE IF NOT EXISTS public.cell_detection
(
    cell_id integer,
    observation_cellular_fingerprint_id integer,
    rss numeric NOT NULL,
    PRIMARY KEY (cell_id, observation_cellular_fingerprint_id)
);


ALTER TABLE public.cell_detection 
ADD CONSTRAINT cell_detection_rss 
CHECK (rss <= 0);


COMMENT ON TABLE public.cell_detection
    IS 'A mobile network cell that has been sensed in the environment with a signal intensity recorded by attribute rss. Rss has a value <= 0, and it is considered to be expressed in dbm.';




CREATE TABLE IF NOT EXISTS public.ap_detection
(
    ap_id integer,
    observation_wifi_fingerprint_id integer,
    rss numeric NOT NULL,
    PRIMARY KEY (ap_id, observation_wifi_fingerprint_id)
);


ALTER TABLE public.ap_detection 
ADD CONSTRAINT ap_detection_rss 
CHECK (rss <= 0);


COMMENT ON TABLE public.ap_detection
    IS 'An access point that has been sensed in the environment with a signal intensity recorded by attribute rss. Rss has a value <= 0, and it is considered to be expressed in dbm.';





CREATE TABLE IF NOT EXISTS public.bluetooth_device
(
    id integer DEFAULT nextval('indoor_seq'),
    name character varying NOT NULL,
    PRIMARY KEY (id)
);

COMMENT ON TABLE public.bluetooth_device
    IS 'A Bluetooth device that can be sensed around the environment.';



CREATE TABLE IF NOT EXISTS public.bluetooth_detection
(
    bluetooth_device_id integer,
    observation_bluetooth_fingerprint_id integer,
    rss numeric NOT NULL,
    PRIMARY KEY (bluetooth_device_id, observation_bluetooth_fingerprint_id)
);


ALTER TABLE public.bluetooth_detection 
ADD CONSTRAINT bluetooth_detection_rss 
CHECK (rss <= 0);


COMMENT ON TABLE public.bluetooth_detection
    IS 'A Bluetooth device that has been sensed in the environment with a signal intensity recorded by attribute rss. Rss has a value <= 0, and it is considered to be expressed in dbm.';



CREATE TABLE IF NOT EXISTS public.cell_data_source
(
    cell_id integer,
    data_source_id integer,
    PRIMARY KEY (cell_id, data_source_id)
);

COMMENT ON TABLE public.cell_data_source
    IS 'Provides data lineage information to table cell.';



CREATE TABLE IF NOT EXISTS public.ap_data_source
(
    ap_id integer,
    data_source_id integer,
    PRIMARY KEY (ap_id, data_source_id)
);

COMMENT ON TABLE public.ap_data_source
    IS 'Provides data lineage information to table ap.';



CREATE TABLE IF NOT EXISTS public.bluetooth_device_data_source
(
    bluetooth_device_id integer,
    data_source_id integer,
    PRIMARY KEY (bluetooth_device_id, data_source_id)
);

COMMENT ON TABLE public.bluetooth_device_data_source
    IS 'Provides data lineage information to table bluetooth device.';




CREATE TABLE IF NOT EXISTS public.place
(
    id integer DEFAULT nextval('indoor_seq'),
    name character varying NOT NULL,
    description character varying, 
    PRIMARY KEY (id)
);

COMMENT ON TABLE public.place
    IS 'The parent entity of the place hierarchy';




CREATE TABLE IF NOT EXISTS public.place_data_source
(
    data_source_id integer,
    place_id integer,
    PRIMARY KEY (data_source_id, place_id)
);

COMMENT ON TABLE public.place_data_source
    IS 'Provides data lineage information to table place.';




CREATE TABLE IF NOT EXISTS public.contains
(
    container_place_id integer,
    contained_place_id integer,
    PRIMARY KEY (container_place_id, contained_place_id)
);

COMMENT ON TABLE public.contains
    IS 'It models containment relationships among places. A building may conitain several floors, and a floor may contain several sites or tiles directly.';




CREATE TABLE IF NOT EXISTS public.building
(
    place_id integer,
    area numeric,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE public.building
    IS 'A building is considered to be a structurally independent element in the indoor positionin domain, possibly connected to other elements by means, for instance, of a bridge.';


CREATE TABLE IF NOT EXISTS public.adjacent_to_building
(
    building_1_place_id integer,
    building_2_place_id integer,
    PRIMARY KEY (building_2_place_id, building_1_place_id)
);

COMMENT ON TABLE public.adjacent_to_building
    IS 'To be used for instance if two buildings have a wall in common.';


CREATE TABLE IF NOT EXISTS public.floor
(
    place_id integer,
    area numeric,
    height numeric,
    above_of_floor_place_id integer,
    below_of_floor_place_id integer,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE public.floor
    IS 'Information regarding all floors of a building should be stored in the database, even if they are not used for positioning purposes.';



CREATE TABLE IF NOT EXISTS public.site
(
    place_id integer,
    area numeric,
    height numeric,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE public.site
    IS 'A generic spatially restriced area in the indoor domain, for instance, a room or a corridor.';




CREATE DOMAIN tile_type AS TEXT
CHECK(
   VALUE = 'grid'
OR VALUE = 'zone'
OR VALUE = 'logical'
OR VALUE = 'crowd'
);


CREATE TABLE IF NOT EXISTS public.tile
(
    place_id integer,
    coordinate_a_x numeric,
    coordinate_a_y numeric,
    coordinate_b_x numeric,
    coordinate_b_y numeric,
    coordinate_c_x numeric,
    coordinate_c_y numeric,
    coordinate_d_x numeric,
    coordinate_d_y numeric,
    type tile_type NOT NULL,
    tessellation_id integer NOT NULL,
    PRIMARY KEY (place_id)
);


COMMENT ON TABLE public.tile
    IS 'For logical tiles, just coordinate_a_x and coordinate_a_y are to be possibly used. Crowd tiles do not have coordinate information. Finally, grid and zone tiles should have all four pair of coordinates.';


CREATE TABLE IF NOT EXISTS public.adjacent_to_tile
(
    tile_1_place_id integer,
    tile_2_place_id integer,
    walkable boolean,
    cost numeric,
    PRIMARY KEY (tile_2_place_id, tile_1_place_id),
    CONSTRAINT chk_adj CHECK (cost >= 0)
);

COMMENT ON TABLE public.adjacent_to_tile
    IS 'To be used for instance if two tiles are adjacent to one another. Walkable means that a user can physically move from one tile to the other, and cost represents the traversing cost, for instance, in terms of expected time.';



CREATE TABLE IF NOT EXISTS public.estimation
(
    id integer primary key,
    fingerprint_id integer,
    "timestamp" timestamp,
    notes varchar, 
    coordinate_x numeric,
    coordinate_y numeric,
    coordinate_z numeric,
    CONSTRAINT u_estimation UNIQUE(fingerprint_id, "timestamp")
);


COMMENT ON TABLE public.estimation
    IS 'It is an estimation related to a fingerprint. In general, a fingerprint may have more than one estimation.';




CREATE TABLE IF NOT EXISTS public.predicted_at
(
    estimation_id integer,
    place_id integer,
    confidence numeric,
    PRIMARY KEY (estimation_id, place_id)
);

COMMENT ON TABLE public.predicted_at
    IS 'It links a fingerprint estimation with one or more places. Confidence can be, for instance, the prediction probability.';



CREATE TABLE IF NOT EXISTS public.device
(
    id integer DEFAULT nextval('indoor_seq'),
    code character varying NOT NULL,
    data_source_id integer NOT NULL,
    device_model_id integer,
    notes character varying,
    PRIMARY KEY (id),
    CONSTRAINT device_uc UNIQUE (code, data_source_id)
);

COMMENT ON TABLE public.device
    IS 'A physical device that senses a fingerprint.';



CREATE TABLE IF NOT EXISTS public.device_model
(
    manufacturer character varying NOT NULL,
    name character varying NOT NULL,
    type_id integer NOT NULL,
    id integer DEFAULT nextval('indoor_seq'),
    PRIMARY KEY (id),
    CONSTRAINT device_model_uc UNIQUE (manufacturer, name)
);


CREATE TABLE IF NOT EXISTS public.device_model_type
(
    id integer DEFAULT nextval('indoor_seq'),
    description character varying NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT device_mode_type_uc UNIQUE (description)
);

INSERT INTO public.device_model_type (description) VALUES 
('smartphone'),
('tablet'),
('other');



CREATE TABLE IF NOT EXISTS public.tessellation
(
    id integer DEFAULT nextval('indoor_seq'),
    floor_place_id integer not null,
    data_source_id integer not null, 
    type tile_type NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT tessellation_uc UNIQUE (floor_place_id, data_source_id, type)
);

COMMENT ON TABLE public.tessellation
    IS 'It defines a strategy for the collection of fingerprints, and it acts as a container for tiles of its same type. Given a floor and a data source, there can be at most one tessellation of each kind. So, for instance, within the same dataset, a floor can have both a tessellation of type zone and grid, but not two different tessellations of type logical.';


/* Here, foreign key constraints are added to the previous tables*/


ALTER TABLE public."user"
    ADD FOREIGN KEY (type_id)
    REFERENCES public.user_type (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public."user"
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.fingerprint
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.fingerprint
    ADD FOREIGN KEY (user_id)
    REFERENCES public."user" (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.fingerprint
    ADD FOREIGN KEY (acquired_at_tile_place_id)
    REFERENCES public.tile (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.fingerprint
    ADD FOREIGN KEY (device_id)
    REFERENCES public.device (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.fingerprint
    ADD FOREIGN KEY (preceded_by_fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.fingerprint
    ADD FOREIGN KEY (followed_by_fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.cell_detection
    ADD FOREIGN KEY (cell_id)
    REFERENCES public.cell (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.cell_detection
    ADD FOREIGN KEY (observation_cellular_fingerprint_id)
    REFERENCES public.observation_cellular (fingerprint_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.ap_detection
    ADD FOREIGN KEY (ap_id)
    REFERENCES public.ap (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.ap_detection
    ADD FOREIGN KEY (observation_wifi_fingerprint_id)
    REFERENCES public.observation_wifi (fingerprint_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.bluetooth_detection
    ADD FOREIGN KEY (bluetooth_device_id)
    REFERENCES public.bluetooth_device (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.bluetooth_detection
    ADD FOREIGN KEY (observation_bluetooth_fingerprint_id)
    REFERENCES public.observation_bluetooth (fingerprint_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.cell_data_source
    ADD FOREIGN KEY (cell_id)
    REFERENCES public.cell (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.cell_data_source
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.ap_data_source
    ADD FOREIGN KEY (ap_id)
    REFERENCES public.ap (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.ap_data_source
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.bluetooth_device_data_source
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.bluetooth_device_data_source
    ADD FOREIGN KEY (bluetooth_device_id)
    REFERENCES public.bluetooth_device (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.place_data_source
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.place_data_source
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.contains
    ADD FOREIGN KEY (container_place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.contains
    ADD FOREIGN KEY (contained_place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.building
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.adjacent_to_building
    ADD FOREIGN KEY (building_1_place_id)
    REFERENCES public.building (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.adjacent_to_building
    ADD FOREIGN KEY (building_2_place_id)
    REFERENCES public.building (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.floor
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.floor
    ADD FOREIGN KEY (above_of_floor_place_id)
    REFERENCES public.floor (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.floor
    ADD FOREIGN KEY (below_of_floor_place_id)
    REFERENCES public.floor (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.site
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.tile
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.tile
    ADD FOREIGN KEY (tessellation_id)
    REFERENCES public.tessellation (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.adjacent_to_tile
    ADD FOREIGN KEY (tile_1_place_id)
    REFERENCES public.tile (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.adjacent_to_tile
    ADD FOREIGN KEY (tile_2_place_id)
    REFERENCES public.tile (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.estimation
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.predicted_at
    ADD FOREIGN KEY (place_id)
    REFERENCES public.place (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.predicted_at
    ADD FOREIGN KEY (estimation_id)
    REFERENCES public.estimation (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.device
    ADD FOREIGN KEY (device_model_id)
    REFERENCES public.device_model (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.device
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.device_model
    ADD FOREIGN KEY (type_id)
    REFERENCES public.device_model_type (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.tessellation
    ADD FOREIGN KEY (floor_place_id)
    REFERENCES public.floor (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.tessellation
    ADD FOREIGN KEY (data_source_id)
    REFERENCES public.data_source (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.observation_cellular
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.observation_wifi
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.observation_bluetooth
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.observation_gnss
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.observation_imu
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;


ALTER TABLE public.observation_imu_accelerometer
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.observation_imu (fingerprint_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.observation_imu_gyroscope
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.observation_imu (fingerprint_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE public.observation_imu_magnetometer
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.observation_imu (fingerprint_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;



END;











/******************************************************************************* EVALUATION SUPPORT SCHEMA *******************************************************************************/


DROP SCHEMA IF EXISTS evaluation_support CASCADE;
CREATE SCHEMA evaluation_support;

COMMENT ON SCHEMA public is 'This schema is used for supporting the evaluation phase of indoor positioning systems.';



CREATE TABLE IF NOT EXISTS evaluation_support.ground_truth_info
(
    fingerprint_id integer primary key references public.fingerprint(id),
    coordinate_x numeric,
    coordinate_y numeric,
    coordinate_z numeric,
    tile_place_id integer references public.tile(place_id), 
    site_place_id integer references public.site(place_id), 
    floor_place_id integer references public.floor(place_id), 
    building_place_id integer references public.building(place_id) 
);

COMMENT ON TABLE evaluation_support.ground_truth_info
    IS 'Ground truth information that may still be associated to online fingerprints, that are present in the public schema of the database.';



ALTER TABLE evaluation_support.ground_truth_info
    ADD FOREIGN KEY (fingerprint_id)
    REFERENCES public.fingerprint (id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE evaluation_support.ground_truth_info
    ADD FOREIGN KEY (tile_place_id)
    REFERENCES public.tile (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE evaluation_support.ground_truth_info
    ADD FOREIGN KEY (site_place_id)
    REFERENCES public.site (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE evaluation_support.ground_truth_info
    ADD FOREIGN KEY (floor_place_id)
    REFERENCES public.floor (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE evaluation_support.ground_truth_info
    ADD FOREIGN KEY (building_place_id)
    REFERENCES public.building (place_id)
    ON UPDATE CASCADE ON DELETE RESTRICT;








/******************************************************************************* DATA STAGING SCHEMA *******************************************************************************/

DROP SCHEMA IF EXISTS data_staging CASCADE;
CREATE SCHEMA data_staging;


COMMENT ON SCHEMA data_staging is 'This schema is used as a temporary data store during the import process.';




CREATE TABLE IF NOT EXISTS data_staging.data_source
(
    id integer NOT NULL DEFAULT nextval('indoor_seq'),
    name character varying NOT NULL,
    notes character varying,
    url character varying,
    PRIMARY KEY (id)
);

COMMENT ON TABLE data_staging.data_source IS 'Table used for data lineage purposes. Attribute ''name'' holds the unique name of the data source.';



CREATE TABLE IF NOT EXISTS data_staging."user"
(
    id integer NOT NULL DEFAULT nextval('indoor_seq'),
    username character varying,
    code character varying NOT NULL,
    type_id integer NOT NULL,
    notes character varying,
    data_source_id integer NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT user_uc UNIQUE (code, data_source_id),
    CONSTRAINT user_uc2 UNIQUE (username, data_source_id)
);


COMMENT ON TABLE data_staging."user"
    IS 'The users that collect the fingerprints. Type_id can be used to distinguish, for instance, between offline (trusted) and online users.';




CREATE TABLE IF NOT EXISTS data_staging.fingerprint
(
    id integer DEFAULT nextval('indoor_seq'),
    code integer NOT NULL,
    data_source_id integer NOT NULL,
    "timestamp" timestamp without time zone,
    coordinate_x numeric,
    coordinate_y numeric,
    coordinate_z numeric,
    preceded_by_fingerprint_id integer,
    followed_by_fingerprint_id integer,
    user_id integer,
    device_id integer,
    is_radio_map boolean NOT NULL,
    acquired_at_tile_place_id integer,
    ml_purpose fingerprint_purpose,
    notes character varying,
    PRIMARY KEY (id),
    CONSTRAINT fingerprint_uc UNIQUE (code, data_source_id)
);

COMMENT ON TABLE data_staging.fingerprint
    IS 'Parent table of the fingerprint hierarchy, which has a partial specialization into radio map fingerprint (attribute is_radio_map). It is a weak entity with respect to the data source. Code is the partial identifier, and it represents, for instance, the row number in the original file. This is enforced by a unique constraint placed over (code, data_source_id), while fingerprint still has a surrogate key, named id. The timestamp is without timezone, so it is assumed that the original data is already converted to consider UTC time zone. Coordinate attributes pertain only to radio map fingerprints, as well as attribute acquired_at_tile_place_id. Attribute ml_purpose allows to keep track of the intended usage of the fingeprint in the original dataset, if any, among training, validation, test purposes.';






CREATE TABLE IF NOT EXISTS data_staging.observation_cellular
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);


COMMENT ON TABLE data_staging.observation_cellular
    IS 'Cellular data pertaining to the fingerprint, sensed around the environment.';




CREATE TABLE IF NOT EXISTS data_staging.observation_wifi
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE data_staging.observation_wifi
    IS 'WiFi data pertaining to the fingerprint, sensed around the environment.';




CREATE TABLE IF NOT EXISTS data_staging.observation_gnss
(
    fingerprint_id integer,
    is_valid boolean,
    latitude numeric,
    longitude numeric,
    elevation numeric,
    num_satellites integer,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE data_staging.observation_gnss
    IS 'GNSS data pertaining to the fingerprint, sensed around the environment.';



CREATE TABLE IF NOT EXISTS data_staging.observation_imu
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE data_staging.observation_imu
    IS 'IMU data pertaining to the fingerprint, sensed around the environment. In principle, an IMU observation contains differntial data with respect to a previous fingerprint.';



CREATE TABLE IF NOT EXISTS data_staging.observation_imu_accelerometer
(
    fingerprint_id integer,
    epoch integer,
    axis_x numeric not null,
    axis_y numeric not null,
    axis_z numeric not null,
    PRIMARY KEY (fingerprint_id, epoch)
);

COMMENT ON TABLE data_staging.observation_imu_accelerometer
    IS 'Accelerometer data pertaining to an IMU observation. In principle, an IMU observation may have several of these data, that can be discerned, among the same observation, by means of the attribute epoch. Being epoch of domain integer, this means that it can be used as a kind of timestamp, as well as a simple incremental value that orders the data within an obsvervation.';



CREATE TABLE IF NOT EXISTS data_staging.observation_imu_gyroscope
(
    fingerprint_id integer,
    epoch integer,
    axis_x numeric not null,
    axis_y numeric not null,
    axis_z numeric not null,
    PRIMARY KEY (fingerprint_id, epoch)
);

COMMENT ON TABLE data_staging.observation_imu_gyroscope
    IS 'Gyroscope data pertaining to an IMU observation. In principle, an IMU observation may have several of these data, that can be discerned, among the same observation, by means of the attribute epoch. Being epoch of domain integer, this means that it can be used as a kind of timestamp, as well as a simple incremental value that orders the data within an obsvervation.';


CREATE TABLE IF NOT EXISTS data_staging.observation_imu_magnetometer
(
    fingerprint_id integer,
    epoch integer,
    axis_x numeric not null,
    axis_y numeric not null,
    axis_z numeric not null,
    PRIMARY KEY (fingerprint_id, epoch)
);

COMMENT ON TABLE data_staging.observation_imu_magnetometer
    IS 'Magnetometer data pertaining to an IMU observation. In principle, an IMU observation may have several of these data, that can be discerned, among the same observation, by means of the attribute epoch. Being epoch of domain integer, this means that it can be used as a kind of timestamp, as well as a simple incremental value that orders the data within an obsvervation.';



CREATE TABLE IF NOT EXISTS data_staging.observation_bluetooth
(
    fingerprint_id integer,
    is_valid boolean,
    PRIMARY KEY (fingerprint_id)
);

COMMENT ON TABLE data_staging.observation_bluetooth
    IS 'Bluetooth data pertaining to the fingerprint, sensed around the environment.';



CREATE TABLE IF NOT EXISTS data_staging.cell
(
    id integer DEFAULT nextval('indoor_seq'),
    ci integer NOT NULL,
    lac integer NOT NULL,
    mnc integer NOT NULL,
    mcc integer NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT cell_uc UNIQUE (ci, lac, mnc, mcc)
);


COMMENT ON TABLE data_staging.cell
    IS 'A mobile network cell that can be sensed in the environment.';



CREATE TABLE IF NOT EXISTS data_staging.ap
(
    id integer DEFAULT nextval('indoor_seq'),
    code character varying NOT NULL,
    mac character varying,
    PRIMARY KEY (id),
    CONSTRAINT ap_uc UNIQUE (mac)
);


COMMENT ON TABLE data_staging.ap
    IS 'A WiFi access point that can be sensed around the environment.';


CREATE TABLE IF NOT EXISTS data_staging.cell_detection
(
    cell_id integer,
    observation_cellular_fingerprint_id integer,
    rss numeric NOT NULL,
    PRIMARY KEY (cell_id, observation_cellular_fingerprint_id)
);

ALTER TABLE data_staging.cell_detection 
ADD CONSTRAINT cell_detection_rss 
CHECK (rss <= 0);

COMMENT ON TABLE data_staging.cell_detection
    IS 'A mobile network cell that has been sensed in the environment with a signal intensity recorded by attribute rss. Rss has a value <= 0, and it is considered to be expressed in dbm.';



CREATE TABLE IF NOT EXISTS data_staging.ap_detection
(
    ap_id integer,
    observation_wifi_fingerprint_id integer,
    rss numeric NOT NULL,
    PRIMARY KEY (ap_id, observation_wifi_fingerprint_id)
);


ALTER TABLE data_staging.ap_detection 
ADD CONSTRAINT ap_detection_rss 
CHECK (rss <= 0);


COMMENT ON TABLE data_staging.ap_detection
    IS 'An access point that has been sensed in the environment with a signal intensity recorded by attribute rss. Rss has a value <= 0, and it is considered to be expressed in dbm.';




CREATE TABLE IF NOT EXISTS data_staging.bluetooth_device
(
    id integer DEFAULT nextval('indoor_seq'),
    name character varying NOT NULL,
    PRIMARY KEY (id)
);


COMMENT ON TABLE data_staging.bluetooth_device
    IS 'A Bluetooth device that can be sensed around the environment.';



CREATE TABLE IF NOT EXISTS data_staging.bluetooth_detection
(
    bluetooth_device_id integer,
    observation_bluetooth_fingerprint_id integer,
    rss numeric NOT NULL,
    PRIMARY KEY (bluetooth_device_id, observation_bluetooth_fingerprint_id)
);

ALTER TABLE data_staging.bluetooth_detection 
ADD CONSTRAINT bluetooth_detection_rss 
CHECK (rss <= 0);

COMMENT ON TABLE data_staging.bluetooth_detection
    IS 'A Bluetooth device that has been sensed in the environment with a signal intensity recorded by attribute rss. Rss has a value <= 0, and it is considered to be expressed in dbm.';



CREATE TABLE IF NOT EXISTS data_staging.cell_data_source
(
    cell_id integer,
    data_source_id integer,
    PRIMARY KEY (cell_id, data_source_id)
);

COMMENT ON TABLE data_staging.cell_data_source
    IS 'Provides data lineage information to table cell.';



CREATE TABLE IF NOT EXISTS data_staging.ap_data_source
(
    ap_id integer,
    data_source_id integer,
    PRIMARY KEY (ap_id, data_source_id)
);


COMMENT ON TABLE data_staging.ap_data_source
    IS 'Provides data lineage information to table ap.';



CREATE TABLE IF NOT EXISTS data_staging.bluetooth_device_data_source
(
    bluetooth_device_id integer,
    data_source_id integer,
    PRIMARY KEY (bluetooth_device_id, data_source_id)
);



COMMENT ON TABLE data_staging.bluetooth_device_data_source
    IS 'Provides data lineage information to table bluetooth device.';




CREATE TABLE IF NOT EXISTS data_staging.place
(
    id integer DEFAULT nextval('indoor_seq'),
    name character varying NOT NULL,
    description character varying, 
    PRIMARY KEY (id)
);


COMMENT ON TABLE data_staging.place
    IS 'The parent entity of the place hierarchy';




CREATE TABLE IF NOT EXISTS data_staging.place_data_source
(
    data_source_id integer,
    place_id integer,
    PRIMARY KEY (data_source_id, place_id)
);

COMMENT ON TABLE data_staging.place_data_source
    IS 'Provides data lineage information to table place.';



CREATE TABLE IF NOT EXISTS data_staging.contains
(
    container_place_id integer,
    contained_place_id integer,
    PRIMARY KEY (container_place_id, contained_place_id)
);


COMMENT ON TABLE data_staging.contains
    IS 'It models containment relationships among places. A building may conitain several floors, and a floor may contain several sites or tiles directly.';



CREATE TABLE IF NOT EXISTS data_staging.building
(
    place_id integer,
    area numeric,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE data_staging.building
    IS 'A building is considered to be a structurally independent element in the indoor positionin domain, possibly connected to other elements by means, for instance, of a bridge.';




CREATE TABLE IF NOT EXISTS data_staging.adjacent_to_building
(
    building_1_place_id integer,
    building_2_place_id integer,
    PRIMARY KEY (building_2_place_id, building_1_place_id)
);


COMMENT ON TABLE data_staging.adjacent_to_building
    IS 'To be used for instance if two buildings have a wall in common.';



CREATE TABLE IF NOT EXISTS data_staging.floor
(
    place_id integer,
    area numeric,
    height numeric,
    above_of_floor_place_id integer,
    below_of_floor_place_id integer,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE data_staging.floor
    IS 'Information regarding all floors of a building should be stored in the database, even if they are not used for positioning purposes.';




CREATE TABLE IF NOT EXISTS data_staging.site
(
    place_id integer,
    area numeric,
    height numeric,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE data_staging.site
    IS 'A generic spatially restriced area in the indoor domain, for instance, a room or a corridor.';




CREATE TABLE IF NOT EXISTS data_staging.tile
(
    place_id integer,
    coordinate_a_x numeric,
    coordinate_a_y numeric,
    coordinate_b_x numeric,
    coordinate_b_y numeric,
    coordinate_c_x numeric,
    coordinate_c_y numeric,
    coordinate_d_x numeric,
    coordinate_d_y numeric,
    type tile_type NOT NULL,
    tessellation_id integer NOT NULL,
    PRIMARY KEY (place_id)
);

COMMENT ON TABLE data_staging.tile
    IS 'For logical tiles, just coordinate_a_x and coordinate_a_y are to be possibly used. Crowd tiles do not have coordinate information. Finally, grid and zone tiles should have all four pair of coordinates.';



CREATE TABLE IF NOT EXISTS data_staging.adjacent_to_tile
(
    tile_1_place_id integer,
    tile_2_place_id integer,
    walkable boolean,
    cost numeric,
    PRIMARY KEY (tile_2_place_id, tile_1_place_id)
);


COMMENT ON TABLE data_staging.adjacent_to_tile
    IS 'To be used for instance if two tiles are adjacent to one another. Walkable means that a user can physically move from one tile to the other, and cost represents the traversing cost, for instance, in terms of expected time.';




CREATE TABLE IF NOT EXISTS data_staging.device
(
    id integer DEFAULT nextval('indoor_seq'),
    code character varying NOT NULL,
    data_source_id integer NOT NULL,
    device_model_id integer,
    notes character varying,
    PRIMARY KEY (id),
    CONSTRAINT device_uc UNIQUE (code, data_source_id)
);


COMMENT ON TABLE data_staging.device
    IS 'A physical device that senses a fingerprint.';



CREATE TABLE IF NOT EXISTS data_staging.device_model
(
    manufacturer character varying NOT NULL,
    name character varying NOT NULL,
    type_id integer NOT NULL,
    id integer DEFAULT nextval('indoor_seq'),
    PRIMARY KEY (id),
    CONSTRAINT device_model_uc UNIQUE (manufacturer, name)
);



CREATE TABLE IF NOT EXISTS data_staging.tessellation
(
    id integer DEFAULT nextval('indoor_seq'),
    floor_place_id integer not null,
    data_source_id integer not null, 
    type tile_type NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT tessellation_uc UNIQUE (floor_place_id, data_source_id, type)
);

COMMENT ON TABLE data_staging.tessellation
    IS 'It defines a strategy for the collection of fingerprints, and it acts as a container for tiles of its same type. Given a floor and a data source, there can be at most one tessellation of each kind. So, for instance, within the same dataset, a floor can have both a tessellation of type zone and grid, but not two different tessellations of type logical.';




CREATE TABLE IF NOT EXISTS data_staging.ground_truth_info
(
    fingerprint_id integer primary key,
    coordinate_x numeric,
    coordinate_y numeric,
    coordinate_z numeric,
    tile_place_id integer, 
    site_place_id integer, 
    floor_place_id integer, 
    building_place_id integer
);

COMMENT ON TABLE data_staging.ground_truth_info
    IS 'Ground truth information that may be associated to fingerprints belonging to the test split of the datasets.';






CREATE TABLE data_staging.insert_order(
    table_name character varying primary key, 
    sort_order integer not null)
;

COMMENT ON TABLE data_staging.insert_order
    IS 'This table is used to control the copy process of information from the data_staging to the public schema.';


INSERT INTO data_staging.insert_order(table_name, sort_order) VALUES 
('data_source', 1),
('place', 2),
('place_data_source', 3),
('contains', 4),
('building', 5),
('adjacent_to_building', 6),
('site', 7),
('floor', 8),
('tessellation', 9),
('tile', 10),
('adjacent_to_tile', 11),
('user', 12),
('device_model', 13),
('device', 14),
('fingerprint', 15),
('observation_gnss', 16),
('observation_imu', 17),
('cell', 18),
('ap', 19),
('bluetooth_device', 20),
('bluetooth_device_data_source', 21),
('ap_data_source', 22),
('cell_data_source', 23),
('observation_cellular', 24),
('observation_wifi', 25),
('observation_bluetooth', 26),
('cell_detection', 27),
('ap_detection', 28),
('bluetooth_detection', 29),
('ground_truth_info', 30),
('observation_imu_accelerometer', 31),
('observation_imu_gyroscope', 32),
('observation_imu_magnetometer', 33);




CREATE TABLE data_staging.generated_ids(
    id integer DEFAULT nextval('indoor_seq'),
    dummy_field integer
);


COMMENT ON TABLE data_staging.insert_order
    IS 'This table is used during the import schema to generate new values for the surrogate keys.';



CREATE OR REPLACE FUNCTION data_staging.truncate_tables(schemaname_in IN VARCHAR) RETURNS void AS $$
DECLARE
    statements CURSOR FOR
        SELECT tablename FROM pg_tables
        WHERE  schemaname = schemaname_in AND tablename != 'insert_order' and tablename != 'generated_ids';
BEGIN
    FOR stmt IN statements LOOP
        EXECUTE 'TRUNCATE TABLE ' || schemaname_in || '.' || quote_ident(stmt.tablename) || ' CASCADE;';
    END LOOP;
END;
$$ LANGUAGE plpgsql;


COMMENT ON FUNCTION data_staging.truncate_tables is 'The function takes in input a schema name, and truncates all tables contained in the schema, with the exception of tables insert_order and generated_ids.';




CREATE OR REPLACE FUNCTION data_staging.copy_tables() RETURNS void AS $$
DECLARE
    statements CURSOR FOR
        SELECT table_name
        FROM data_staging.insert_order
        ORDER BY sort_order;
BEGIN
    FOR stmt IN statements LOOP
        EXECUTE CASE WHEN stmt.table_name = 'ground_truth_info' THEN 'INSERT INTO evaluation_support.' ELSE 'INSERT INTO ' END || quote_ident(stmt.table_name) || ' SELECT * FROM data_staging.' || quote_ident(stmt.table_name) || ';';
    END LOOP;
END;
$$ LANGUAGE plpgsql;


COMMENT ON FUNCTION data_staging.copy_tables is 'The function copies information from the schema data_staging to the schemas public and ground_gruth_info, following the order specified by the tuples in the table data_staging.insert_order.';




CREATE OR REPLACE FUNCTION data_staging.generate_vacuum_tables(kind_in varchar default '') 
RETURNS SETOF return_types.query_output AS $$
DECLARE 
    return_value return_types.query_output%ROWTYPE;
BEGIN

    DROP TABLE IF EXISTS tmp_generate_vacuum_tables_inner;
    CREATE TEMPORARY TABLE tmp_generate_vacuum_tables_inner (query varchar);

    INSERT INTO tmp_generate_vacuum_tables_inner
	SELECT 'vacuum ' || kind_in || ' analyze '
           || table_name
           || ';' 
    FROM   information_schema.tables
    WHERE  table_schema in ('communication', 'public', 'evaluation_support')
    ORDER  BY table_schema, table_name;
	
    FOR return_value IN 
        SELECT * FROM tmp_generate_vacuum_tables_inner
    LOOP
        return next return_value;
    END LOOP;
	
END;
$$ LANGUAGE plpgsql;


COMMENT ON FUNCTION data_staging.copy_tables is 'The function generates vacuum statements for the tables contained in the database. In takes in input a string that specifies the kind of vacuum to operate, e.g., full or analyze.';











/******************************************************************************* FUNCTION THAT CHECKS THE SATISFACTION OF DOMAIN CONSTRAINTS WITHIN THE DATABASE, RETURNING ALL ENCOUNTERED VIOLATIONS *******************************************************************************/




DROP SCHEMA IF EXISTS return_types CASCADE;
CREATE SCHEMA return_types;


create table return_types.reachability_output(
    starting_tile_id integer, 
    ending_tile_id integer, 
    path_ids integer[], 
    cost numeric, 
    n_hops integer);


CREATE TABLE return_types.tmp_violations(
    check_kind character varying, 
    problem_description character varying, 
    offending_ids integer[]);



CREATE TABLE return_types.query_output(
    query character varying);


COMMENT ON SCHEMA return_types IS 'This schema is used just to encode the return types of functions.';




CREATE OR REPLACE FUNCTION check_db_consistency(schema_in character varying)
RETURNS SETOF return_types.tmp_violations AS $$
DECLARE 
    return_value return_types.tmp_violations%ROWTYPE;
BEGIN

        CASE
            WHEN schema_in = 'public'
                THEN SET search_path TO public; 
            WHEN schema_in = 'data_staging'
                THEN SET search_path TO data_staging; 
            ELSE
                raise notice 'Wrong schema specified. Defaulting to public.';
                SET search_path TO public; 
        END CASE;

        

        DROP TABLE IF EXISTS tmp_violations_inner;
        CREATE TEMPORARY TABLE tmp_violations_inner (check_kind character varying, problem_description character varying, offending_ids integer[]);


        /* CODE TO CHECK GENERAL CONSISTENCY REQUIREMENTS */

        raise notice 'Checking general consistency requirements...';

        INSERT INTO tmp_violations_inner
        SELECT  'logical_tile_wrong_coordinates', 'ID of a logical tile that is using other coordinates than the first two ones', array[place_id]
        FROM    tile
        WHERE   type = 'logical' AND (coordinate_b_x IS NOT NULL OR coordinate_b_y IS NOT NULL OR coordinate_c_x IS NOT NULL OR coordinate_c_y IS NOT NULL OR coordinate_d_x IS NOT NULL OR coordinate_d_y IS NOT NULL);

        INSERT INTO tmp_violations_inner
        SELECT  'crowd_tile_wrong_coordinates', 'ID of a crowd tile that is specifying some coordinates', array[place_id]
        FROM    tile
        WHERE   type = 'crowd' AND (coordinate_a_x IS NOT NULL OR coordinate_a_y IS NOT NULL OR coordinate_b_x IS NOT NULL OR coordinate_b_y IS NOT NULL OR coordinate_c_x IS NOT NULL OR coordinate_c_y IS NOT NULL OR coordinate_d_x IS NOT NULL OR coordinate_d_y IS NOT NULL);

        INSERT INTO tmp_violations_inner
        SELECT  'grid_tile_wrong_coordinates', 'ID of a grid tile that does not specify all of the required coordinates', array[place_id]
        FROM    tile
        WHERE   type = 'grid' AND (coordinate_a_x IS NULL OR coordinate_a_y IS NULL OR coordinate_b_x IS NULL OR coordinate_b_y IS NULL OR coordinate_c_x IS NULL OR coordinate_c_y IS NULL OR coordinate_d_x IS NULL OR coordinate_d_y IS NULL);

        INSERT INTO tmp_violations_inner
        SELECT  'zone_tile_wrong_coordinates', 'ID of a zone tile that does not specify all of the required coordinates', array[place_id]
        FROM    tile
        WHERE   type = 'zone' AND (coordinate_a_x IS NULL OR coordinate_a_y IS NULL OR coordinate_b_x IS NULL OR coordinate_b_y IS NULL OR coordinate_c_x IS NULL OR coordinate_c_y IS NULL OR coordinate_d_x IS NULL OR coordinate_d_y IS NULL);

        INSERT INTO tmp_violations_inner
        SELECT  'tile_tessellation_mismatch', 'ID of a tile that belongs to a tessellation with different type', array[place_id]
        FROM    tile
                    JOIN tessellation ON tile.tessellation_id = tessellation.id
        WHERE tile.type != tessellation.type;

        INSERT INTO tmp_violations_inner
        SELECT  'crowd_tessellation_multiple_tiles', 'ID of a crowd tessellation containing multiple crowd tiles', array[tessellation.id]
        FROM    tessellation
                    JOIN tile on tile.tessellation_id = tessellation.id
        WHERE tile.type = 'crowd'
        GROUP BY tessellation.id
        HAVING count(*) > 1;

        INSERT INTO tmp_violations_inner
        SELECT  'radio_map_fingerprint_no_tile', 'ID of a radio map fingerprint without a related tile', array[id]
        FROM    fingerprint
        WHERE   is_radio_map and acquired_at_tile_place_id is null;

        INSERT INTO tmp_violations_inner
        SELECT  'estimation_without_estimates', 'ID of an estimation without estimated coordinates nor places', array[id]
        FROM    public.estimation
        WHERE   coordinate_x is null and coordinate_y is null and coordinate_z is null 
                and not exists (select *
                                from public.predicted_at
                                where predicted_at.estimation_id = estimation.id);




        /* CODE TO CHECK NON-OPTIONAL PARTICIPATIONS */

        raise notice 'Checking non-optional participations...';

        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_cell_source', 'ID of a cell without a data source', array[id]
        FROM cell
        WHERE NOT EXISTS (SELECT * FROM cell_data_source WHERE cell_id = cell.id); 
                

        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_ap_source', 'ID of an AP without a data source', array[id]
        FROM ap
        WHERE NOT EXISTS (SELECT * FROM ap_data_source WHERE ap_id = ap.id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_bluetooth_device_source', 'ID of a bluetooth_device without a data source', array[id]
        FROM bluetooth_device
        WHERE NOT EXISTS (SELECT * FROM bluetooth_device_data_source WHERE bluetooth_device_id = bluetooth_device.id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_device', 'ID of a device without any fingerprints', array[id]
        FROM device
        WHERE NOT EXISTS (SELECT * FROM fingerprint WHERE fingerprint.device_id = device.id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_device_model', 'ID of a device model without any devices', array[id]
        FROM device_model
        WHERE NOT EXISTS (SELECT * FROM device WHERE device.device_model_id = device_model.id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_user', 'ID of a user without any fingerprints', array[id]
        FROM "user"
        WHERE NOT EXISTS (SELECT * FROM fingerprint WHERE fingerprint.user_id = "user".id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_fingerprint', 'ID of a fingerprint without any observations', array[id]
        FROM fingerprint
        WHERE NOT EXISTS (SELECT * FROM observation_cellular WHERE observation_cellular.fingerprint_id = fingerprint.id) AND 
                NOT EXISTS (SELECT * FROM observation_wifi WHERE observation_wifi.fingerprint_id = fingerprint.id) AND 
                NOT EXISTS (SELECT * FROM observation_bluetooth WHERE observation_bluetooth.fingerprint_id = fingerprint.id) AND 
                NOT EXISTS (SELECT * FROM observation_gnss WHERE observation_gnss.fingerprint_id = fingerprint.id) AND 
                NOT EXISTS (SELECT * FROM observation_imu WHERE observation_imu.fingerprint_id = fingerprint.id);


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_imu', 'ID of an IMU observation without any actual observation data', array[fingerprint_id]
        FROM observation_imu
        WHERE NOT EXISTS (SELECT * FROM observation_imu_gyroscope WHERE observation_imu_gyroscope.fingerprint_id = observation_imu.fingerprint_id) AND 
                NOT EXISTS (SELECT * FROM observation_imu_accelerometer WHERE observation_imu_accelerometer.fingerprint_id = observation_imu.fingerprint_id) AND
                NOT EXISTS (SELECT * FROM observation_imu_magnetometer WHERE observation_imu_magnetometer.fingerprint_id = observation_imu.fingerprint_id);


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_data_source', 'ID of a data source without any places', array[id]
        FROM data_source
        WHERE NOT EXISTS (SELECT * FROM place_data_source WHERE place_data_source.data_source_id = data_source.id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_place', 'ID of a place not linked to any data sources', array[id]
        FROM place
        WHERE NOT EXISTS (SELECT * FROM place_data_source WHERE place_data_source.place_id = place.id); 


        INSERT INTO tmp_violations_inner
        SELECT 'missing_participation_tessellation', 'PK of a tessellation not containing any tiles', array[id, floor_place_id]
        FROM tessellation
        WHERE NOT EXISTS (SELECT * FROM tile WHERE tessellation.id = tile.tessellation_id); 



        /* CODE TO CHECK BUILDING AND TILE ADJACENCY (AND WALKABILITY) CONSISTENCY */

        raise notice 'Checking building and tile adjacencies...';

        INSERT INTO tmp_violations_inner
        SELECT 'non_simmetrical_building_adjacency', 'IDs of two buildings that do not have a symmetrical adjacency', array[building_1_place_id, building_2_place_id]
        FROM adjacent_to_building ad1
        WHERE NOT EXISTS (  SELECT *
                            FROM adjacent_to_building ad2
                            WHERE ad1.building_1_place_id = ad2.building_2_place_id
                                    AND ad1.building_2_place_id = ad2.building_1_place_id
                        );


        INSERT INTO tmp_violations_inner
        SELECT 'non_simmetrical_tile_adjacency', 'IDs of two tiles that do not have a symmetrical adjacency, or differ wrt the walkability property', array[tile_1_place_id, tile_2_place_id]
        FROM adjacent_to_tile ad1
        WHERE NOT EXISTS (  SELECT *
                            FROM adjacent_to_tile ad2
                            WHERE ad1.tile_1_place_id = ad2.tile_2_place_id
                                    AND ad1.tile_2_place_id = ad2.tile_1_place_id
                                    AND ((ad1.walkable = ad2.walkable) OR (ad1.walkable IS NULL AND ad2.walkable IS NULL))
                                    AND ((ad1.cost = ad2.cost) OR (ad1.cost IS NULL AND ad2.cost IS NULL))
                        );



        /* CODE TO CHECK COORDINATES CONSISTENCY */

        raise notice 'Checking coordinates consistency...';

        INSERT INTO tmp_violations_inner
        SELECT  'inconsistent_coordinates_fingerprint', 'ID of a fingerprint that has inconsistently set coordinates', array[fingerprint.id]
        FROM fingerprint
        WHERE coordinate_z IS NOT NULL AND (coordinate_x IS NULL or coordinate_y IS NULL) OR
                (coordinate_x IS NOT NULL AND coordinate_y IS NULL) OR
                (coordinate_x IS NULL AND coordinate_y IS NOT NULL);


        INSERT INTO tmp_violations_inner
        SELECT  'inconsistent_coordinates_estimation', 'ID of an estimate that has inconsistently set coordinates', array[estimation.id]
        FROM public.estimation
        WHERE coordinate_z IS NOT NULL AND (coordinate_x IS NULL or coordinate_y IS NULL) OR
                (coordinate_x IS NOT NULL AND coordinate_y IS NULL) OR
                (coordinate_x IS NULL AND coordinate_y IS NOT NULL);


        INSERT INTO tmp_violations_inner
        
        SELECT 'inconsistent_coordinates_gnss', 'ID of a gnss observation that has inconsistently set coordinates', array[fingerprint_id]
        FROM observation_gnss
        WHERE elevation IS NOT NULL AND (latitude IS NULL or longitude IS NULL) OR
                (latitude IS NOT NULL AND longitude IS NULL) OR
                (latitude IS NULL AND longitude IS NOT NULL);


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_coordinates_imu_accelerometer', 'ID of an IMU observation that has inconsistently set coordinates', array[fingerprint_id]
        FROM observation_imu_accelerometer
        WHERE (axis_x IS NULL)::int + (axis_y IS NULL)::int + (axis_z IS NULL)::int not in (0, 3);


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_coordinates_imu_gyroscope', 'ID of an IMU observation that has inconsistently set coordinates', array[fingerprint_id]
        FROM observation_imu_gyroscope
        WHERE (axis_x IS NULL)::int + (axis_y IS NULL)::int + (axis_z IS NULL)::int not in (0, 3);


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_coordinates_imu_magnetometer', 'ID of an IMU observation that has inconsistently set coordinates', array[fingerprint_id]
        FROM observation_imu_magnetometer
        WHERE (axis_x IS NULL)::int + (axis_y IS NULL)::int + (axis_z IS NULL)::int not in (0, 3);



        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_coordinates_tile', 'ID of a tile that has inconsistently set coordinates', array[place_id]
        FROM tile
        WHERE ((coordinate_a_x IS NULL)::int + (coordinate_a_y IS NULL)::int not in (0, 2)) OR
                ((coordinate_b_x IS NULL)::int + (coordinate_b_y IS NULL)::int not in (0, 2)) OR
                ((coordinate_c_x IS NULL)::int + (coordinate_c_y IS NULL)::int not in (0, 2)) OR
                ((coordinate_d_x IS NULL)::int + (coordinate_d_y IS NULL)::int not in (0, 2));



        /* CODE TO CHECK PLACE HIERACHY CONSISTENCY */

        raise notice 'Checking place hierachy consistency...';


        INSERT INTO tmp_violations_inner
        SELECT 'unspecialized_place', 'ID of a place without a specialization', array[id]
        FROM place
        WHERE NOT EXISTS (SELECT * FROM tile WHERE tile.place_id = place.id) AND 
                NOT EXISTS (SELECT * FROM site WHERE site.place_id = place.id) AND 
                NOT EXISTS (SELECT * FROM floor WHERE floor.place_id = place.id) AND 
                NOT EXISTS (SELECT * FROM building WHERE building.place_id = place.id);


        INSERT INTO tmp_violations_inner
        SELECT 'overspecialized_place', 'ID of a place with more than one specialization', array[id]
        FROM place
        WHERE EXISTS (SELECT * FROM tile WHERE tile.place_id = place.id)::integer +
              EXISTS (SELECT * FROM site WHERE site.place_id = place.id)::integer +
              EXISTS (SELECT * FROM floor WHERE floor.place_id = place.id)::integer +  
              EXISTS (SELECT * FROM building WHERE building.place_id = place.id)::integer > 1;


        INSERT INTO tmp_violations_inner
        with no_good as (
            select *
            from contains
        except
            select *
            from contains
            where exists (select * from building where building.place_id = container_place_id) and
                    exists (select * from floor where floor.place_id = contained_place_id)
        except
            select *
            from contains
            where exists (select * from floor where floor.place_id = container_place_id) and
                    exists (select * from site where site.place_id = contained_place_id)
        except
            select *
            from contains
            where exists (select * from floor where floor.place_id = container_place_id) and
                    exists (select * from tile where tile.place_id = contained_place_id)
        except
            select *
            from contains
            where exists (select * from site where site.place_id = container_place_id) and
                    exists (select * from tile where tile.place_id = contained_place_id)
        )
        SELECT
            'inconsistent_place_hierarchy_allowed_containment', 'IDs of two places that violate place hierarchy assumptions regarding the allowed container and contained instances relationships', array[container_place_id, contained_place_id]
        FROM no_good;


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_place_hierarchy_floor_multiply_contained', 'ID of a floor that appears more than one time in a containment relationship as a contained place', array[cont1.contained_place_id]
        FROM contains as cont1
                JOIN floor on cont1.contained_place_id = floor.place_id
        WHERE EXISTS (SELECT * FROM contains as cont2 WHERE cont1.contained_place_id = cont2.contained_place_id and cont1.container_place_id != cont2.container_place_id);


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_place_hierarchy_tile_multiply_contained', 'ID of a tile that appears more than one time in a containment relationship as a contained place', array[cont1.contained_place_id]
        FROM contains as cont1
                JOIN tile on cont1.contained_place_id = tile.place_id
        WHERE EXISTS (SELECT * FROM contains as cont2 WHERE cont1.contained_place_id = cont2.contained_place_id and cont1.container_place_id != cont2.container_place_id);


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_place_hierarchy_grid_tile_with_site', 'ID of a grid tile that belongs to a site', array[tile.place_id]
        FROM tile
        WHERE type = 'grid' AND
                EXISTS (SELECT * 
                        FROM contains 
                                join site on site.place_id = contains.container_place_id
                        WHERE contains.contained_place_id = tile.place_id);


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_place_hierarchy_crowd_tile_with_site', 'ID of a crowd tile that belongs to a site', array[tile.place_id]
        FROM tile
        WHERE type = 'crowd' AND
                EXISTS (SELECT * 
                        FROM contains 
                                join site on site.place_id = contains.container_place_id
                        WHERE contains.contained_place_id = tile.place_id);

        /*
        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_place_hierarchy_zone_tile_with_site', 'ID of a zone tile that belongs to a floor', array[tile.place_id]
        FROM tile
        WHERE type = 'zone' AND
                EXISTS (SELECT * 
                        FROM contains 
                                join floor on floor.place_id = contains.container_place_id
                        WHERE contains.contained_place_id = tile.place_id);
        */


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_tile_mapping_floor_containment', 'ID of a tile that has an inconsistency between its membership to the floor, and the floor of its tessellation', array[tile.place_id]
        FROM tile 
                JOIN contains on contains.contained_place_id = tile.place_id
                JOIN floor on contains.container_place_id = floor.place_id
                JOIN tessellation on tile.tessellation_id = tessellation.id
        WHERE 
            tessellation.floor_place_id != floor.place_id;


        INSERT INTO tmp_violations_inner
        SELECT 'inconsistent_tile_mapping_floor_containment', 'ID of a tile that has an inconsistency between its membership to the site-floor, and the floor of its tessellation', array[tile.place_id]
        FROM tile 
                JOIN contains as contains1 on contains1.contained_place_id = tile.place_id
                JOIN site on contains1.container_place_id = site.place_id 
                JOIN contains as contains2 on contains2.contained_place_id = site.place_id
                JOIN floor on contains2.container_place_id = floor.place_id
                JOIN tessellation on tile.tessellation_id = tessellation.id
        WHERE 
            tessellation.floor_place_id != floor.place_id;



        FOR return_value IN 
            SELECT * FROM tmp_violations_inner
        LOOP
	        return next return_value;
        END LOOP;


        SET search_path TO public;

END;
$$  LANGUAGE plpgsql;



COMMENT ON FUNCTION check_db_consistency IS 'The function takes in input the name of the schema on which to operate, between public and data_staging. Then, it runs on the specified shema searching for violations of domain constraints, for instance, regarding the consistency of the place hierarcy. Then, it returns all encountered violations by means of a table.';




/******************************************************************************* SCHEMA COMMUNICATION *******************************************************************************/




DROP SCHEMA IF EXISTS communication CASCADE;
CREATE SCHEMA communication;

CREATE TABLE IF NOT EXISTS communication.imported_ids(
    id integer,
    import_time timestamp with time zone,
    source_name varchar,
    entity_name varchar
);

COMMENT ON TABLE communication.imported_ids IS 'The table keeps track of all IDs of tuples that have successfully been imported in the database, together with the time of import.';



/******************************************************************************* INDEXES *******************************************************************************/



create index idx_fingerprint_radio_map on fingerprint(is_radio_map);
create index idx_fingerprint_ml_purpose on fingerprint(ml_purpose);
create index idx_fingerprint_data_source_id on fingerprint(data_source_id);
create index idx_fingerprint_acquired_at_tile_place_id on fingerprint(acquired_at_tile_place_id);

create index idx_place_name on place(name);

create index contains_idx_1 on contains(contained_place_id);
create index contains_idx_2 on contains(container_place_id);

create index adjacent_idx_1 on adjacent_to_tile(tile_1_place_id);
create index adjacent_idx_2 on adjacent_to_tile(tile_2_place_id);

create index place_source_idx_1 on place_data_source(data_source_id);
create index place_source_idx_2 on place_data_source(place_id);

create index ap_detection_idx_ap on ap_detection(ap_id);
create index ap_detection_idx_obs on ap_detection(observation_wifi_fingerprint_id);




/******************************************************************************* USER DEFINED FUNCTIONS *******************************************************************************/




CREATE OR REPLACE FUNCTION euclidean_distance(l numeric[], r numeric[]) RETURNS numeric AS $$
DECLARE
  s numeric;
BEGIN
  s := 0;
  FOR i IN 1..array_length(l, 1) LOOP
    s := s + ((l[i] - r[i]) * (l[i] - r[i]));
  END LOOP;
  RETURN |/ s;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION euclidean_distance is 'Given two numeric arrays representing coordinates, it returns the euclidean distance between the two.';
		



CREATE OR REPLACE FUNCTION array_reverse(anyarray) RETURNS anyarray AS $$
SELECT ARRAY(
    SELECT $1[i]
    FROM generate_subscripts($1,1) AS s(i)
    ORDER BY i DESC
);
$$ LANGUAGE 'sql' STRICT IMMUTABLE;

COMMENT ON FUNCTION array_reverse is 'Given an array, it returns its reverse.';




CREATE OR REPLACE FUNCTION public.old_reachability_dijkstra(starting_tile_id_in integer, ending_tile_id_in integer, cost_or_hops varchar default 'hops')
    RETURNS SETOF return_types.reachability_output 
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE 
	u integer;
	u_cost numeric;
	u_hops integer;
	v_cost numeric;
	alt numeric;
    return_value return_types.reachability_output%ROWTYPE;
	row adjacent_to_tile%ROWTYPE;
BEGIN

        DROP TABLE IF EXISTS output_table;
        CREATE TEMPORARY TABLE output_table(starting_tile_id integer, ending_tile_id integer, path_ids integer[], cost numeric, n_hops integer);

        DROP TABLE IF EXISTS aux_table;
        CREATE TEMPORARY TABLE aux_table(tile_id integer, cost numeric, n_hops integer, preceding_tile_id integer, processed boolean);
		
		INSERT INTO aux_table 
		WITH RECURSIVE reachable AS (
				SELECT adjacent_to_tile.tile_2_place_id
				FROM adjacent_to_tile
				WHERE adjacent_to_tile.walkable and adjacent_to_tile.tile_1_place_id = starting_tile_id_in
			UNION
				SELECT next.tile_2_place_id
				FROM reachable as prev
						JOIN adjacent_to_tile as next ON next.tile_1_place_id = prev.tile_2_place_id and next.walkable
		)
		SELECT reachable.tile_2_place_id, null, null, null, 'false'
		FROM reachable;
		
		CREATE UNIQUE INDEX idx_aux_table_id on aux_table(tile_id);
		CREATE INDEX idx_aux_table_cost on aux_table(cost);
		CREATE INDEX idx_aux_table_proc on aux_table(processed);
        
		UPDATE aux_table SET
			n_hops = 0,
			cost = 0
		WHERE aux_table.tile_id = starting_tile_id_in;
				
		WHILE (select count(*) from aux_table where aux_table.cost is null) > 0 LOOP
		
			select aux_table.tile_id, aux_table.cost, aux_table.n_hops
			into u, u_cost, u_hops
			from aux_table 
			where not aux_table.processed
			order by case when cost_or_hops = 'cost' then aux_table.cost else aux_table.n_hops end
			limit 1;
			
			update aux_table
				set processed = 'true'
			where tile_id = u;
						
			IF u_cost is null THEN
				EXIT;
			END IF;
			
			FOR row IN
				SELECT * FROM adjacent_to_tile WHERE adjacent_to_tile.tile_1_place_id = u AND adjacent_to_tile.walkable
			LOOP
				alt := u_cost + case when cost_or_hops = 'cost' then row.cost else 1 end;
								
				select case when cost_or_hops = 'cost' then aux_table.cost else aux_table.n_hops end 
				into v_cost
				from aux_table 
				where aux_table.tile_id = row.tile_2_place_id;
				
				IF alt < v_cost or v_cost is null THEN
					UPDATE aux_table SET
						n_hops = u_hops + 1,
						cost = alt,
						preceding_tile_id = u
					WHERE aux_table.tile_id = row.tile_2_place_id;
				END IF;

			END LOOP;
		
		END LOOP;
		
		
		
		INSERT INTO output_table
		WITH RECURSIVE shortest_path AS (
			SELECT aux_table.preceding_tile_id, aux_table.cost, aux_table.n_hops
			FROM aux_table
			WHERE aux_table.tile_id = ending_tile_id_in
		UNION
			SELECT aux_table.preceding_tile_id, aux_table.cost, aux_table.n_hops
			FROM shortest_path 
					JOIN aux_table on aux_table.tile_id = shortest_path.preceding_tile_id 
			WHERE aux_table.preceding_tile_id is not null
		)
		SELECT starting_tile_id_in, ending_tile_id_in, array_reverse(array[ending_tile_id_in] || array_agg(preceding_tile_id)), max(cost), max(n_hops)
		FROM shortest_path;
		
		
		
		RETURN QUERY SELECT * FROM output_table;


END;
$BODY$;


CREATE OR REPLACE FUNCTION public.reachability_dijkstra(starting_tile_id_in integer, target_tile_set integer[], cost_or_hops varchar default 'hops')
    RETURNS SETOF return_types.reachability_output 
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE 
	u integer;
	u_cost numeric;
	u_hops integer;
	v_cost numeric;
	alt numeric;
	closest_tile integer;
    return_value return_types.reachability_output%ROWTYPE;
	row adjacent_to_tile%ROWTYPE;
BEGIN

        DROP TABLE IF EXISTS output_table;
        CREATE TEMPORARY TABLE output_table(starting_tile_id integer, ending_tile_id integer, path_ids integer[], cost numeric, n_hops integer);

        DROP TABLE IF EXISTS aux_table;
        CREATE TEMPORARY TABLE aux_table(tile_id integer, cost numeric, n_hops integer, preceding_tile_id integer, processed boolean);
		
		INSERT INTO aux_table 
		WITH RECURSIVE reachable AS (
				SELECT adjacent_to_tile.tile_2_place_id
				FROM adjacent_to_tile
				WHERE adjacent_to_tile.walkable and adjacent_to_tile.tile_1_place_id = starting_tile_id_in
			UNION
				SELECT next.tile_2_place_id
				FROM reachable as prev
						JOIN adjacent_to_tile as next ON next.tile_1_place_id = prev.tile_2_place_id and next.walkable
		)
		SELECT reachable.tile_2_place_id, null, null, null, 'false'
		FROM reachable;
		
		CREATE UNIQUE INDEX idx_aux_table_id on aux_table(tile_id);
		CREATE INDEX idx_aux_table_cost on aux_table(cost);
		CREATE INDEX idx_aux_table_proc on aux_table(processed);
        
		UPDATE aux_table SET
			n_hops = 0,
			cost = 0
		WHERE aux_table.tile_id = starting_tile_id_in;
				
		WHILE (select count(*) from aux_table where aux_table.cost is null) > 0 LOOP
		
			select aux_table.tile_id, aux_table.cost, aux_table.n_hops
			into u, u_cost, u_hops
			from aux_table 
			where not aux_table.processed
			order by case when cost_or_hops = 'cost' then aux_table.cost else aux_table.n_hops end
			limit 1;
			
			update aux_table
				set processed = 'true'
			where tile_id = u;
						
			IF u_cost is null THEN
				EXIT;
			END IF;
			
			FOR row IN
				SELECT * FROM adjacent_to_tile WHERE adjacent_to_tile.tile_1_place_id = u AND adjacent_to_tile.walkable
			LOOP
				alt := u_cost + case when cost_or_hops = 'cost' then row.cost else 1 end;
								
				select case when cost_or_hops = 'cost' then aux_table.cost else aux_table.n_hops end 
				into v_cost
				from aux_table 
				where aux_table.tile_id = row.tile_2_place_id;
				
				IF alt < v_cost or v_cost is null THEN
					UPDATE aux_table SET
						n_hops = u_hops + 1,
						cost = alt,
						preceding_tile_id = u
					WHERE aux_table.tile_id = row.tile_2_place_id;
				END IF;

			END LOOP;
		
		END LOOP;
		
		SELECT aux_table.tile_id INTO closest_tile FROM aux_table WHERE aux_table.tile_id = ANY(target_tile_set) order by cost limit 1;
		
		INSERT INTO output_table
		WITH RECURSIVE shortest_path AS (
			SELECT aux_table.preceding_tile_id, aux_table.cost, aux_table.n_hops
			FROM aux_table
			WHERE aux_table.tile_id = closest_tile
		UNION
			SELECT aux_table.preceding_tile_id, aux_table.cost, aux_table.n_hops
			FROM shortest_path 
					JOIN aux_table on aux_table.tile_id = shortest_path.preceding_tile_id 
			WHERE aux_table.preceding_tile_id is not null
		)
		SELECT starting_tile_id_in, closest_tile, array_reverse(array[closest_tile] || array_agg(preceding_tile_id)), max(cost), max(n_hops)
		FROM shortest_path;
		
		
		
		RETURN QUERY SELECT * FROM output_table;


END;
$BODY$;

COMMENT ON FUNCTION public.reachability_dijkstra is 'Given two tile IDs and a strategy to calculate the path cost (either the number of hops or the cost stored into the table adjacent_to_tile), it returns the shortest path between the two input tiles in terms of IDs of the tiles thave have to be traversed, together with its cost and number of hops.';




CREATE OR REPLACE FUNCTION FindRelatedTiles(object_id integer, object_type varchar) RETURNS integer[] AS $$
DECLARE
  tile_array integer[];
  est_place_id integer;
BEGIN
	CASE 
		WHEN object_type = 'tile' THEN
    		tile_array = array_agg(object_id);
		WHEN object_type = 'fingerprint' THEN
    		SELECT array_agg(tile.place_id) INTO tile_array FROM tile,fingerprint where tile.place_id = fingerprint.acquired_at_tile_place_id and fingerprint.id = object_id;
		WHEN object_type = 'estimation' THEN
    		select predicted_at.place_id into est_place_id from predicted_at where predicted_at.estimation_id = object_id order by confidence DESC LIMIT 1;
			IF NOT FOUND THEN
				RAISE EXCEPTION 'Estimation % has not linked places!', object_type;
			ELSE
				select FindRelatedTiles(est_place_id, "tile") into tile_array;
				IF tile_array IS NULL THEN
					select FindRelatedTiles(est_place_id, "site") into tile_array;
					IF tile_array IS NULL THEN
						select FindRelatedTiles(est_place_id, "floor") into tile_array;
					END IF;
				END IF;
			END IF;
		WHEN object_type = 'site' THEN
    		SELECT array_agg(contains.contained_place_id) INTO tile_array FROM contains where contains.container_place_id = object_id;
		WHEN object_type = 'floor' THEN
    		SELECT array_agg(c2.contained_place_id) INTO tile_array FROM contains as c1, contains as c2 where c1.container_place_id = object_id and c2.container_place_id = c1.contained_place_id;
			IF tile_array IS NULL THEN
    			SELECT array_agg(contains.contained_place_id) INTO tile_array FROM contains where contains.container_place_id = object_id and contains.contained_place_id in (select tile.place_id from tile);
			END IF;
		ELSE
			RAISE EXCEPTION 'Object_type % not supported for the current operation', object_type USING HINT = 'Please check that the object_type is tile, fingerprint, estimation, site, or floor';
	END CASE;
	RETURN tile_array;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION FindRelatedTiles is 'Given an object identifier and its type, returns an array of tiles associated with it.';




CREATE OR REPLACE FUNCTION MinimumShortestPath(start_id integer, end_id integer, start_obj_type varchar default 'tile', end_obj_type varchar default 'tile', cost_or_hops varchar default 'hops')
	RETURNS SETOF return_types.reachability_output 
AS $$
DECLARE
	--return_value return_types.reachability_output%ROWTYPE;
	starting_tiles integer[];
	ending_tiles integer[];
	start_tile integer;
BEGIN
	starting_tiles = FindRelatedTiles(start_id, start_obj_type);
	ending_tiles = FindRelatedTiles(end_id, end_obj_type);
	
	IF (starting_tiles IS NULL) OR (ending_tiles IS NULL) THEN
		RAISE EXCEPTION 'Tiles not exisiting for at least one of the two ends';
	ELSE
	
        DROP TABLE IF EXISTS output_table_msp;
        CREATE TEMPORARY TABLE output_table_msp(starting_tile_id integer, ending_tile_id integer, path_ids integer[], cost numeric, n_hops integer);
		
		FOREACH start_tile IN ARRAY starting_tiles LOOP
			INSERT INTO output_table_msp SELECT * FROM public.reachability_dijkstra(start_tile, ending_tiles, cost_or_hops);
		END LOOP;
	END IF;
	
	RETURN QUERY SELECT * FROM output_table_msp ORDER BY cost LIMIT 1;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION MinimumShortestPath is 'Given two object identifiers and their types, among fingerprint, estimation, tile, site, and floor, find the minimum shortest path between them.';
		
		
		

CREATE OR REPLACE FUNCTION FPDistances(fp1_id integer, fp2_id integer, out euclidean2D numeric, out euclidean3D numeric, out msp numeric, f1_type varchar default 'fingerprint', f2_type varchar default 'fingerprint') AS $$
DECLARE
	fp1_coords integer[];
	fp2_coords integer[];
BEGIN
	if f1_type = 'fingerprint' then
		select ARRAY[coordinate_x, coordinate_y]::integer[] into fp1_coords from fingerprint where id = fp1_id;
	ELSIF f1_type = 'estimation' then
		select ARRAY[coordinate_x, coordinate_y]::integer[] into fp1_coords from estimation where id = fp1_id;
	ELSE
		RAISE EXCEPTION 'Object_type % not supported for the current operation', object_type USING HINT = 'Please check that the object_type is fingerprint or estimation';
	end if;
	
	if f2_type = 'fingerprint' then
		select ARRAY[coordinate_x, coordinate_y]::integer[] into fp2_coords from fingerprint where id = fp2_id;
	ELSIF f2_type = 'estimation' then
		select ARRAY[coordinate_x, coordinate_y]::integer[] into fp2_coords from estimation where id = fp2_id;
	ELSE
		RAISE EXCEPTION 'Object_type % not supported for the current operation', object_type USING HINT = 'Please check that the object_type is fingerprint or estimation';
	end if;
	select euclidean_distance(fp1_coords, fp2_coords) into euclidean2D;
	
	
	if f1_type = 'fingerprint' then
		select ARRAY[coordinate_x, coordinate_y, coordinate_z]::integer[] into fp1_coords from fingerprint where id = fp1_id;
	ELSIF f1_type = 'estimation' then
		select ARRAY[coordinate_x, coordinate_y, coordinate_z]::integer[] into fp1_coords from estimation where id = fp1_id;
	ELSE
		RAISE EXCEPTION 'Object_type % not supported for the current operation', object_type USING HINT = 'Please check that the object_type is fingerprint or estimation';
	end if;
	
	if f2_type = 'fingerprint' then
		select ARRAY[coordinate_x, coordinate_y, coordinate_z]::integer[] into fp2_coords from fingerprint where id = fp2_id;
	ELSIF f2_type = 'estimation' then
		select ARRAY[coordinate_x, coordinate_y, coordinate_z]::integer[] into fp2_coords from estimation where id = fp2_id;
	ELSE
		RAISE EXCEPTION 'Object_type % not supported for the current operation', object_type USING HINT = 'Please check that the object_type is fingerprint or estimation';
	end if;
	select euclidean_distance(fp1_coords, fp2_coords) into euclidean3D;
	
	select cost into msp from MinimumShortestPath(fp1_id, fp2_id, f1_type, f2_type);

END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION FPDistances is 'Given two fingerprint (or estimation) identifiers, it returns the 2D and 3D euclidean distances between them and the minimum shortest path to go from the location associated with one fingeprint to that of the other.';




CREATE OR REPLACE FUNCTION CharacterizingFP(obj_id integer) 
returns table (id integer, code varchar, rss numeric)
AS $$
DECLARE
	ref_data_source_id integer;
BEGIN
	SELECT data_source_id into ref_data_source_id from fingerprint where fingerprint.acquired_at_tile_place_id = obj_id LIMIT 1;
	RETURN QUERY
		select ap.id as ap_id, ap.code as ap_code, AVG(coalesce(ap_detection.rss, -110)) as rss
		from ap
			join ap_data_source on ap.id = ap_data_source.ap_id
			join data_source on data_source.id = ap_data_source.data_source_id
			left outer join ap_detection on ap.id = ap_detection.ap_id and observation_wifi_fingerprint_id in ( 
				select observation_wifi.fingerprint_id
				from observation_wifi join fingerprint on observation_wifi.fingerprint_id = fingerprint.id
				where fingerprint.acquired_at_tile_place_id = obj_id)
		where ap_data_source.data_source_id = ref_data_source_id
		group by ap.id, ap.code
		order by ap.id;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION CharacterizingFP is 'Given a tile identifier returns the avarage (WiFi) fingerprint that represent it';


CREATE OR REPLACE FUNCTION GetTrajectory(f_id integer, out trajectory integer[]) AS $$
DECLARE
	prec integer;
	succ integer;
BEGIN
	select followed_by_fingerprint_id, preceded_by_fingerprint_id into succ, prec from fingerprint where id = f_id;
	trajectory = trajectory || f_id;
	WHILE (succ is not NULL) or (prec is not NULL) LOOP
		IF succ is not NULL THEN
			trajectory = trajectory || succ;
			select followed_by_fingerprint_id into succ from fingerprint where id = succ;
		END IF;
		IF prec is not NULL THEN
			trajectory = prec || trajectory;
			select preceded_by_fingerprint_id into prec from fingerprint where id = prec;
		END IF;
	END LOOP;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION GetTrajectory is 'Given a fingerprint identifier returns the trajectory (array of fingerprint identifierds) to which it belongs';


CREATE OR REPLACE FUNCTION TrajectoriesInPlace(obj_id integer, obj_type varchar default 'tile')
returns table (trajectory integer[])
AS $$
DECLARE
	involved_tiles integer[];
	involved_fps integer[];
	f_id integer;
BEGIN
	involved_tiles = FindRelatedTiles(obj_id, obj_type);
	select array_agg(fingerprint.id) into involved_fps from fingerprint where fingerprint.acquired_at_tile_place_id = ANY(involved_tiles);
	
	IF involved_fps IS NULL THEN
		RAISE EXCEPTION 'No radio-map fingerprint associated with the given place';
	ELSE
	
        DROP TABLE IF EXISTS output_trajs;
        CREATE TEMPORARY TABLE output_trajs(trajectory integer[]);
		
		FOREACH f_id IN ARRAY involved_fps LOOP
			INSERT INTO output_trajs SELECT * FROM public.GetTrajectory(f_id);
		END LOOP;
	END IF;
	
	RETURN QUERY SELECT DISTINCT * FROM output_trajs;
END;
$$ LANGUAGE plpgsql;

COMMENT ON FUNCTION TrajectoriesInPlace is 'Given a place identifier (tile, site, or floor) returns all the trajectories passing trought it';
