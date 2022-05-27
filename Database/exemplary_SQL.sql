-- This file contains some exemplary SQL queries that can be used to retrieve information from the database
-- Note that they are just intended for demonstration purposes, and are not necessarily meaningful, nor particularly optimized







-- The following query calculates the predicted position of a test set fingerprint of dataset UJI1 as the centroid of all 
-- the radio map fingerprints belonging to its same building and floor 

with estimated_fingerprints as (
	select ground_truth_info.*
	from fingerprint
			join data_source on data_source.id = fingerprint.data_source_id
			join evaluation_support.ground_truth_info on fingerprint.id = ground_truth_info.fingerprint_id
	where ml_purpose = 'test' and data_source.name = 'UJI1'
)
select 
	estimated_fingerprints.fingerprint_id as test_fingerprint_id,
	estimated_fingerprints.coordinate_x as gt_coordinate_x, 
	estimated_fingerprints.coordinate_y as gt_coordinate_y, 
	avg(tile.coordinate_a_x) as predicted_coordinate_x,
	avg(tile.coordinate_a_y) as predicted_coordinate_y,
	sqrt((estimated_fingerprints.coordinate_x - avg(tile.coordinate_a_x))^2 + (estimated_fingerprints.coordinate_y - avg(tile.coordinate_a_y))^2) as positioning_error_meters,
	count(*) number_of_considered_rp
from estimated_fingerprints
		join fingerprint on 1 = 1
		join data_source on data_source.id = fingerprint.data_source_id
		join tile on fingerprint.acquired_at_tile_place_id = tile.place_id
		join contains as contained_in_room on tile.place_id  = contained_in_room.contained_place_id
		join contains as contained_in_floor on contained_in_room.container_place_id = contained_in_floor.contained_place_id
		join contains as contained_in_building on contained_in_floor.container_place_id = contained_in_building.contained_place_id
where fingerprint.ml_purpose = 'training'
		and data_source.name = 'UJI1'
		and contained_in_floor.container_place_id = estimated_fingerprints.floor_place_id 
		and contained_in_building.container_place_id = estimated_fingerprints.building_place_id 
group by 
		estimated_fingerprints.fingerprint_id,
		estimated_fingerprints.coordinate_x, 
		estimated_fingerprints.coordinate_y;









-- The following query extracts the topological structure of dataset UJI1, i.e., its structuring into buildings, floors, and sites

select building_place.name as building_name, floor_place.name as floor_name, site_place.name as site_name
from place as building_place
		join place_data_source on place_data_source.place_id = building_place.id
		join building on building_place.id = building.place_id
		join data_source on data_source.id = place_data_source.data_source_id
		join contains as contains_floor on contains_floor.container_place_id = building_place.id 
		join contains as contains_site on contains_site.container_place_id = contains_floor.contained_place_id
		join place as floor_place on floor_place.id = contains_floor.contained_place_id
		join place as site_place on site_place.id = contains_site.contained_place_id
where data_source.name = 'UJI1'
order by building_place.name, floor_place.name, site_place.name;









-- The following query extracts some general statistics regarding the dataset UJI1, incuding the number of buildings,
-- the number of floors per building, the number of sites per floor, the number of tiles per floor, etc.

select 'Number of buildings' as description, count(distinct building_place.name)
	from place as building_place
			join place_data_source on place_data_source.place_id = building_place.id
			join building on building_place.id = building.place_id
			join data_source on data_source.id = place_data_source.data_source_id
	where data_source.name = 'UJI1'

union

	select 'Number of floors for the building ' || building_place.name, count(distinct floor_place.name)
	from place as building_place
			join place_data_source on place_data_source.place_id = building_place.id
			join building on building_place.id = building.place_id
			join data_source on data_source.id = place_data_source.data_source_id
			join contains as contains_floor on contains_floor.container_place_id = building_place.id 
			join place as floor_place on floor_place.id = contains_floor.contained_place_id
	where data_source.name = 'UJI1'
	group by building_place.name

union 

	select 'Number of sites for the building ' || building_place.name || ' and the floor ' || floor_place.name, count(distinct site_place.name)
	from place as building_place
			join place_data_source on place_data_source.place_id = building_place.id
			join building on building_place.id = building.place_id
			join data_source on data_source.id = place_data_source.data_source_id
			join contains as contains_floor on contains_floor.container_place_id = building_place.id 
			join contains as contains_site on contains_site.container_place_id = contains_floor.contained_place_id
			join place as floor_place on floor_place.id = contains_floor.contained_place_id
			join place as site_place on site_place.id = contains_site.contained_place_id
	where data_source.name = 'UJI1'
	group by building_place.name, floor_place.name
	
	
union 

	select 'Number of tiles for the building ' || building_place.name || ' and the floor ' || floor_place.name, count(distinct site_tile.name)
	from place as building_place
			join place_data_source on place_data_source.place_id = building_place.id
			join building on building_place.id = building.place_id
			join data_source on data_source.id = place_data_source.data_source_id
			join contains as contains_floor on contains_floor.container_place_id = building_place.id 
			join contains as contains_site on contains_site.container_place_id = contains_floor.contained_place_id
			join contains as contains_tile on contains_tile.container_place_id = contains_site.contained_place_id
			join place as floor_place on floor_place.id = contains_floor.contained_place_id
			join place as site_place on site_place.id = contains_site.contained_place_id
			join place as site_tile on site_tile.id = contains_tile.contained_place_id
	where data_source.name = 'UJI1'
	group by building_place.name, floor_place.name
	
order by description;









-- The following query can be used to extract the sites that are immediately reachable from site '206_2'
-- of floor '4' of buildind '2' of dataset UJI1.

with site_floor_building_info as (
select
	place_building.name as building_name,
	place_floor.name as floor_name, 
	place_site.name as site_name, 
	place_site.id as site_id
from 
	place as place_site
		join site on place_site.id = site.place_id
		join contains as contained_in_floor on contained_in_floor.contained_place_id = place_site.id
		join place as place_floor on place_floor.id = contained_in_floor.container_place_id
		join contains as contained_in_building on contained_in_building.contained_place_id = place_floor.id
		join place as place_building on place_building.id = contained_in_building.container_place_id	
)
select distinct
	info_from.building_name as starting_building,
	info_from.floor_name as starting_floor, 
	info_from.site_name as starting_site, 
	info_to.building_name as ending_building,
	info_to.floor_name as ending_floor,
	info_to.site_name as ending_site
from site_floor_building_info as info_from
		join place_data_source on place_data_source.place_id = info_from.site_id
		join data_source on data_source.id = place_data_source.data_source_id
		join contains as contains_tile_from on contains_tile_from.container_place_id = info_from.site_id
		join adjacent_to_tile on adjacent_to_tile.tile_1_place_id = contains_tile_from.contained_place_id and walkable
		join contains as contains_tile_to on adjacent_to_tile.tile_2_place_id = contains_tile_to.contained_place_id and contains_tile_to.container_place_id != info_from.site_id
		join site_floor_building_info as info_to on info_to.site_id = contains_tile_to.container_place_id
where data_source.name = 'UJI1' and info_from.site_name = '206_2' and info_from.floor_name = '4' and info_from.building_name = '2';








-- The following query can be used to extract the sites that are reachable in at most three hops from site '206_2'
-- of floor '4' of buildind '2' of dataset UJI1.

with site_floor_building_info as (
select
	place_building.name as building_name,
	place_floor.name as floor_name, 
	place_site.name as site_name, 
	place_site.id as site_id
from 
	place as place_site
		join site on place_site.id = site.place_id
		join contains as contained_in_floor on contained_in_floor.contained_place_id = place_site.id
		join place as place_floor on place_floor.id = contained_in_floor.container_place_id
		join contains as contained_in_building on contained_in_building.contained_place_id = place_floor.id
		join place as place_building on place_building.id = contained_in_building.container_place_id	
)

	select distinct
		info_from.building_name as starting_building,
		info_from.floor_name as starting_floor, 
		info_from.site_name as starting_site, 
		info_to.building_name as ending_building,
		info_to.floor_name as ending_floor,
		info_to.site_name as ending_site,
		1 as number_of_hops
	from site_floor_building_info as info_from
			join place_data_source on place_data_source.place_id = info_from.site_id
			join data_source on data_source.id = place_data_source.data_source_id
			join contains as contains_tile_from on contains_tile_from.container_place_id = info_from.site_id
			join adjacent_to_tile on adjacent_to_tile.tile_1_place_id = contains_tile_from.contained_place_id and walkable
			join contains as contains_tile_to on adjacent_to_tile.tile_2_place_id = contains_tile_to.contained_place_id and contains_tile_to.container_place_id != info_from.site_id
			join site_floor_building_info as info_to on info_to.site_id = contains_tile_to.container_place_id
	where data_source.name = 'UJI1' and info_from.site_name = '206_2' and info_from.floor_name = '4' and info_from.building_name = '2'

union

	select  distinct
		info_from.building_name as starting_building,
		info_from.floor_name as starting_floor, 
		info_from.site_name as starting_site, 
		info_to.building_name as ending_building,
		info_to.floor_name as ending_floor,
		info_to.site_name as ending_site,
		2 as number_of_hops
	from site_floor_building_info as info_from
			join place_data_source on place_data_source.place_id = info_from.site_id
			join data_source on data_source.id = place_data_source.data_source_id
			join contains as contains_tile_from on contains_tile_from.container_place_id = info_from.site_id
			join adjacent_to_tile as hop_1 on hop_1.tile_1_place_id = contains_tile_from.contained_place_id and hop_1.walkable
			join adjacent_to_tile as hop_2 on hop_2.tile_1_place_id = hop_1.tile_2_place_id and hop_2.walkable
			join contains as contains_tile_to on hop_2.tile_2_place_id = contains_tile_to.contained_place_id and contains_tile_to.container_place_id != info_from.site_id
			join site_floor_building_info as info_to on info_to.site_id = contains_tile_to.container_place_id
	where data_source.name = 'UJI1' and info_from.site_name = '206_2' and info_from.floor_name = '4' and info_from.building_name = '2'
	
union

	select  distinct
		info_from.building_name as starting_building,
		info_from.floor_name as starting_floor, 
		info_from.site_name as starting_site, 
		info_to.building_name as ending_building,
		info_to.floor_name as ending_floor,
		info_to.site_name as ending_site,
		3 as number_of_hops
	from site_floor_building_info as info_from
			join place_data_source on place_data_source.place_id = info_from.site_id
			join data_source on data_source.id = place_data_source.data_source_id
			join contains as contains_tile_from on contains_tile_from.container_place_id = info_from.site_id
			join adjacent_to_tile as hop_1 on hop_1.tile_1_place_id = contains_tile_from.contained_place_id and hop_1.walkable
			join adjacent_to_tile as hop_2 on hop_2.tile_1_place_id = hop_1.tile_2_place_id and hop_2.walkable
			join adjacent_to_tile as hop_3 on hop_3.tile_1_place_id = hop_2.tile_2_place_id and hop_3.walkable
			join contains as contains_tile_to on hop_3.tile_2_place_id = contains_tile_to.contained_place_id and contains_tile_to.container_place_id != info_from.site_id
			join site_floor_building_info as info_to on info_to.site_id = contains_tile_to.container_place_id
	where data_source.name = 'UJI1' and info_from.site_name = '206_2' and info_from.floor_name = '4' and info_from.building_name = '2'	
	
order by number_of_hops;









-- The following query can be used to extract the sites that are reachable in any number of hops starting from site '206_2'
-- of floor '4' of buildind '2' of dataset UJI1.

with RECURSIVE reachable AS (
	SELECT
		adjacent_to_tile.tile_1_place_id,
		adjacent_to_tile.tile_2_place_id
	FROM
		adjacent_to_tile
	WHERE
		walkable and tile_1_place_id = (select contains_tile.contained_place_id
										 from contains as contains_tile
										 		join place as place_site on place_site.id = contains_tile.container_place_id
										 		join site on place_site.id = site.place_id
										 		join contains as contained_in_floor on contained_in_floor.contained_place_id = place_site.id
												join place as place_floor on place_floor.id = contained_in_floor.container_place_id
												join contains as contained_in_building on contained_in_building.contained_place_id = place_floor.id
												join place as place_building on place_building.id = contained_in_building.container_place_id	
										 		join place_data_source on place_data_source.place_id = place_site.id
												join data_source on data_source.id = place_data_source.data_source_id
										 where data_source.name = 'UJI1' and place_site.name = '206_2' and place_floor.name = '4' and place_building.name = '2')
	UNION
		SELECT
			next.tile_1_place_id,
			next.tile_2_place_id
		FROM
			reachable as prev
				JOIN adjacent_to_tile as next ON next.tile_1_place_id = prev.tile_2_place_id and next.walkable
),
site_floor_building_info as (
select
	place_building.name as building_name,
	place_floor.name as floor_name, 
	place_site.name as site_name, 
	place_site.id as site_id
from 
	place as place_site
		join site on place_site.id = site.place_id
		join contains as contained_in_floor on contained_in_floor.contained_place_id = place_site.id
		join place as place_floor on place_floor.id = contained_in_floor.container_place_id
		join contains as contained_in_building on contained_in_building.contained_place_id = place_floor.id
		join place as place_building on place_building.id = contained_in_building.container_place_id	
		join place_data_source on place_site.id = place_data_source.place_id
		join data_source on data_source.id = place_data_source.data_source_id
where
	data_source.name = 'UJI1'
)
select distinct
	info_from.building_name as starting_building,
	info_from.floor_name as starting_floor, 
	info_from.site_name as starting_site, 
	info_to.building_name as ending_building,
	info_to.floor_name as ending_floor,
	info_to.site_name as ending_site
from site_floor_building_info as info_from
		join place_data_source on place_data_source.place_id = info_from.site_id
		join data_source on data_source.id = place_data_source.data_source_id
		join contains as contains_tile_from on contains_tile_from.container_place_id = info_from.site_id
		join contains as contains_tile_to on contains_tile_to.container_place_id != info_from.site_id
		join reachable on reachable.tile_2_place_id = contains_tile_to.contained_place_id
		join site_floor_building_info as info_to on info_to.site_id = contains_tile_to.container_place_id
where data_source.name = 'UJI1' and info_from.site_name = '206_2' and info_from.floor_name = '4' and info_from.building_name = '2';










-- Given the fingerprint of UJI1 with code 2456, the following query extracts all sites that contain at least one fingerprint having
-- at least one access point in common with the provided fingerprint.

select place_building_other.name as building_name, place_floor_other.name as floor_name, place_site_other.name as site_name, count(distinct finger_other.id)
from fingerprint as finger_this
		join data_source as data_source_this on finger_this.data_source_id = data_source_this.id
		join observation_wifi as obs_wifi_this on obs_wifi_this.fingerprint_id = finger_this.id
		join ap_detection as ap_detection_this on ap_detection_this.observation_wifi_fingerprint_id = obs_wifi_this.fingerprint_id
		join ap_detection as ap_detection_other on ap_detection_this.ap_id = ap_detection_other.ap_id and ap_detection_this.observation_wifi_fingerprint_id != ap_detection_other.observation_wifi_fingerprint_id
		join fingerprint as finger_other on finger_other.id = ap_detection_other.observation_wifi_fingerprint_id
		join data_source as data_source_other on finger_other.data_source_id = data_source_other.id
		join contains as contains_tile_other on contains_tile_other.contained_place_id = finger_other.acquired_at_tile_place_id
		join contains as contains_site_other on contains_site_other.contained_place_id = contains_tile_other.container_place_id
		join contains as contains_floor_other on contains_floor_other.contained_place_id = contains_site_other.container_place_id
		join place as place_site_other on contains_tile_other.container_place_id = place_site_other.id
		join place as place_floor_other on contains_site_other.container_place_id = place_floor_other.id
		join place as place_building_other on contains_floor_other.container_place_id = place_building_other.id
where data_source_this.name = 'UJI1' and data_source_other.name = 'UJI1' and finger_this.code = 2456 and finger_other.ml_purpose = 'training' and finger_other.is_radio_map
group by place_building_other.name, place_floor_other.name, place_site_other.name
order by count(distinct finger_other.id) desc;











-- The following query calculates the number of tiles and their cumulated area for the floor '0' 
-- of building 'laboratory' of the dataset 'SIM001'

select 
	count(*) as number_of_tiles, 
	sum(area(path(polygon('((' || coordinate_a_x || ',' || coordinate_a_y   || '), (' || coordinate_b_x || ',' || coordinate_b_y  ||  ')' || ', (' || coordinate_c_x || ',' || coordinate_c_y  ||  ')' || ', (' || coordinate_d_x || ',' || coordinate_d_y  ||  '))')))) as total_area
from place as place_floor
		join place_data_source on place_data_source.place_id = place_floor.id
		join data_source on data_source.id = place_data_source.data_source_id
		join contains as contains_floor on contains_floor.contained_place_id = place_floor.id
		join place as place_building on place_building.id = contains_floor.container_place_id
		join contains as contains_tile on contains_tile.container_place_id = place_floor.id
		join tile on contains_tile.contained_place_id = tile.place_id
where data_source.name ='SIM001' and place_floor.name = '0' and place_building.name = 'laboratory';
