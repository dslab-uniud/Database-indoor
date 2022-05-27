-- These queries can be used to merge common information between two datasets that have been imported in the database
-- WARNING: the queries assume that there are no estimations already made in the database for the newer dataset

-- FIRST OF ALL, LET US BUILD A TEMPORARY TABLE WHICH WILL HELP US IN PERFORMING THE MAPPING TASKS


-- This table will contain all the IDs to remap between the datasets
drop table if exists tmp_remappings;
create temporary table tmp_remappings(
	kind varchar, -- kind of object that is going to be remapped (e.g., a floor)
	id_from integer primary key,  -- old ID, that will be remapped
	id_to integer -- value of the new ID
);


-- In the following queries, the two datasets that are considered in the remapping process have to be manually specified
-- In the provided examples, we are considering LIB1 and LIB2: "where data_source.name in ('LIB1', 'LIB2')"



/*
-- Device remappings
with remap_query as
(
	select code, max(device.id) as device_id_from,  min(device.id) as device_id_to
	from device
			join data_source on data_source_id = data_source.id
	where data_source.name in ('LIB1', 'LIB2')
	group by code
)
insert into tmp_remappings
select 'device', device_id_from, device_id_to
from remap_query;


-- User remappings
with remap_query as
(
	select username, max("user".id) as user_id_from,  min("user".id) as user_id_to
	from "user"
			join data_source on data_source_id = data_source.id
	where data_source.name in ('LIB1', 'LIB2')
	group by username
)
insert into tmp_remappings
select 'user', user_id_from, user_id_to
from remap_query;
*/



-- AP remappings
with remap_query as
(
	select ap.code, max(ap.id) as ap_id_from,  min(ap.id) as ap_id_to
	from ap
			join ap_data_source on ap.id = ap_data_source.ap_id
			join data_source on ap_data_source.data_source_id = data_source.id
	where data_source.name in ('LIB1', 'LIB2') and data_source.name not in ('TUT3', 'TUT2', 'TUT5', 'TUT6', 'TUT7')
	group by ap.code
)
insert into tmp_remappings
select 'ap', ap_id_from, ap_id_to
from remap_query
where ap_id_from != ap_id_to;


-- Building remappings
with remap_query as
(
	select place.name, max(place.id) as place_id_from,  min(place.id) as place_id_to
	from place
			join place_data_source on place.id = place_data_source.place_id
			join data_source on place_data_source.data_source_id = data_source.id
			join building on building.place_id = place.id
	where data_source.name in ('LIB1', 'LIB2')
	group by place.name
)
insert into tmp_remappings
select 'building', place_id_from, place_id_to
from remap_query
where place_id_from != place_id_to;



-- Floor remappings
with remap_query as
(
	select bldplace.name, flrplace.name, max(flrplace.id) as place_id_from,  min(flrplace.id) as place_id_to
	from place as bldplace
			join place_data_source on bldplace.id = place_data_source.place_id
			join data_source on place_data_source.data_source_id = data_source.id
			join building on building.place_id = bldplace.id
			join contains as contains_floor on contains_floor.container_place_id = bldplace.id
			join place as flrplace on contains_floor.contained_place_id = flrplace.id
			join floor on flrplace.id = floor.place_id
	where data_source.name in ('LIB1', 'LIB2')
	group by bldplace.name, flrplace.name
)
insert into tmp_remappings
select 'floor', place_id_from, place_id_to
from remap_query
where place_id_from != place_id_to;




-- Site remappings
with remap_query as
(
	select bldplace.name, flrplace.name, siteplace.name, max(siteplace.id) as place_id_from,  min(siteplace.id) as place_id_to
	from place as bldplace
			join place_data_source on bldplace.id = place_data_source.place_id
			join data_source on place_data_source.data_source_id = data_source.id
			join building on building.place_id = bldplace.id
			join contains as contains_floor on contains_floor.container_place_id = bldplace.id
			join place as flrplace on contains_floor.contained_place_id = flrplace.id
			join floor on flrplace.id = floor.place_id
			join contains as contains_site on contains_site.container_place_id = flrplace.id
			join place as siteplace on contains_site.contained_place_id = siteplace.id
			join site on siteplace.id = site.place_id
	where data_source.name in ('LIB1', 'LIB2')
	group by bldplace.name, flrplace.name, siteplace.name
)
insert into tmp_remappings
select 'site', place_id_from, place_id_to
from remap_query
where place_id_from != place_id_to;


-- This completes the collection of information on the objects that have to be remapped


select * from tmp_remappings





-- NOW WE HAVE THE UPDATE PART: WE MAP THE NEW REFERENCES INTO THE ONES THAT WERE ALREADY EXISTING, AND WE DELETE OLD TUPLES


-- Ground truth info
update evaluation_support.ground_truth_info
set site_place_id = tmp_remappings.id_to
from tmp_remappings
where ground_truth_info.site_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'site';
		
update evaluation_support.ground_truth_info
set floor_place_id = tmp_remappings.id_to
from tmp_remappings
where ground_truth_info.floor_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'floor';
		
update evaluation_support.ground_truth_info
set building_place_id = tmp_remappings.id_to
from tmp_remappings
where ground_truth_info.building_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'building';
		
		

-- AP related tables
update ap_data_source
set ap_id = tmp_remappings.id_to
from tmp_remappings
where ap_data_source.ap_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'ap';
				
update ap_detection
set ap_id = tmp_remappings.id_to
from tmp_remappings
where ap_detection.ap_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'ap';
		
delete from ap
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = ap.id
			 		and tmp_remappings.kind = 'ap');
		


/*		
-- User related tables
update fingerprint
set user_id = tmp_remappings.id_to
from tmp_remappings
where fingerprint.user_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'user';
		
delete from "user"
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = "user".id
			 		and tmp_remappings.kind = 'user');
		
		
		
-- Device related tables
update fingerprint
set device_id = tmp_remappings.id_to
from tmp_remappings
where fingerprint.device_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'device';
		
delete from device
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = device.id
			 		and tmp_remappings.kind = 'device');
*/

		

-- Place related tables
-- WARNING: we assume that there are no "prior" relationships between places belonging to the two datasets, e.g., adjacency between buildings or containment among places
update place_data_source
set place_id = tmp_remappings.id_to
from tmp_remappings
where place_data_source.place_id = tmp_remappings.id_from
		and tmp_remappings.kind in ('building', 'floor', 'site');
		
update tessellation
set floor_place_id = tmp_remappings.id_to
from tmp_remappings
where tessellation.floor_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'floor';		
		
update floor
set above_of_floor_place_id = tmp_remappings.id_to
from tmp_remappings
where floor.above_of_floor_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'floor';		
		
update floor
set below_of_floor_place_id = tmp_remappings.id_to
from tmp_remappings
where floor.below_of_floor_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'floor';	

-- Contains
update contains
set container_place_id = tmp_remappings.id_to
from tmp_remappings
where contains.container_place_id = tmp_remappings.id_from
		and tmp_remappings.kind in ('building', 'floor', 'site');
		
drop table if exists tmp_contains_violations;
create temporary table tmp_contains_violations as
select
	cont1.container_place_id, tmp_remappings.id_to as contained_place_id, tmp_remappings.id_from as contained_place_id_old
from contains as cont1
		join tmp_remappings on tmp_remappings.id_from = cont1.contained_place_id and tmp_remappings.kind in ('building', 'floor', 'site')
where exists (select *
			  from contains as cont2
			  where cont1.container_place_id = cont2.container_place_id
			 		and tmp_remappings.id_to = cont2.contained_place_id); 
				
update contains
set contained_place_id = tmp_remappings.id_to
from tmp_remappings
where contains.contained_place_id = tmp_remappings.id_from
		and tmp_remappings.kind in ('building', 'floor', 'site')
		and not exists (select *
					   	from tmp_contains_violations
					    where tmp_contains_violations.container_place_id = contains.container_place_id 
					   			and tmp_contains_violations.contained_place_id = tmp_remappings.id_to);
		
delete from contains
where exists (select *
			  from tmp_contains_violations
			  where tmp_contains_violations.container_place_id = contains.container_place_id 
					and tmp_contains_violations.contained_place_id_old = contains.contained_place_id);		

-- Adjacent_to_building
update adjacent_to_building
set building_1_place_id = tmp_remappings.id_to
from tmp_remappings
where adjacent_to_building.building_1_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'building';
		
drop table if exists tmp_adjacent_violations;
create temporary table tmp_adjacent_violations as
select
	adj1.building_1_place_id, tmp_remappings.id_to as building_2_place_id, tmp_remappings.id_from as building_2_place_id_old
from adjacent_to_building as adj1
		join tmp_remappings on tmp_remappings.id_from = adj1.building_2_place_id and tmp_remappings.kind = 'building'
where exists (select *
			  from adjacent_to_building as adj2
			  where adj1.building_1_place_id = adj2.building_1_place_id
			 		and tmp_remappings.id_to = adj2.building_2_place_id); 
				
update adjacent_to_building
set building_2_place_id = tmp_remappings.id_to
from tmp_remappings
where adjacent_to_building.building_2_place_id = tmp_remappings.id_from
		and tmp_remappings.kind = 'building'
		and not exists (select *
					   	from tmp_adjacent_violations
					    where tmp_adjacent_violations.building_1_place_id = adjacent_to_building.building_1_place_id 
					   			and tmp_adjacent_violations.building_2_place_id = tmp_remappings.id_to);
		
delete from adjacent_to_building
where exists (select *
			  from tmp_adjacent_violations
			  where tmp_adjacent_violations.building_1_place_id = adjacent_to_building.building_1_place_id 
					and tmp_adjacent_violations.building_2_place_id_old = adjacent_to_building.building_2_place_id);		

-- Deletes
delete from site
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = site.place_id
			 		and tmp_remappings.kind = 'site');
					
delete from floor
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = floor.place_id
			 		and tmp_remappings.kind = 'floor');
					
delete from building
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = building.place_id
			 		and tmp_remappings.kind = 'building');
					
delete from place
where exists (select *
			  from tmp_remappings
			  where tmp_remappings.id_from = place.id
			 		and tmp_remappings.kind in ('building', 'floor', 'site'));	
					
					
					