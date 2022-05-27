-- These are just some exemplary queries that can be used to verify the information that has been inserted in the database


select *
from data_source


select * 
from device_model 
		join device_model_type on device_model_type.id = device_model.type_id



select *
from device
		join data_source on data_source.id = device.data_source_id
		join device_model on device_model.id = device.device_model_id
		join device_model_type on device_model_type.id = device_model.type_id
		
		
		
select *
from device
		join device_model on device_model.id = device.device_model_id
		join device_model_type on device_model_type.id = device_model.type_id
		join fingerprint on fingerprint.device_id = device.id
		join data_source on data_source.id = fingerprint.data_source_id
order by fingerprint.code
		
	
	
	
	
select *
from "user" 
		join user_type on "user".type_id = user_type.id
	
	
	
	
			
select *
from "user" 
		join user_type on "user".type_id = user_type.id
		join fingerprint on fingerprint.user_id = "user".id
		join data_source on data_source.id = fingerprint.data_source_id 
order by fingerprint.code
				




select *
from ap
		join ap_data_source on ap_data_source.ap_id = ap.id
		join data_source on data_source.id = ap_data_source.data_source_id
where  data_source.name ='TUT4'			

		
	

select ap.code, ap.id, count(*)
from ap
		join ap_data_source on ap_data_source.ap_id = ap.id
		join data_source on data_source.id = ap_data_source.data_source_id
where  data_source.name in ('TUT3', 'TUT4')			
group by ap.code, ap.id
order by ap.code, ap.id
	

		
		
select *
from ap
		join ap_data_source on ap_data_source.ap_id = ap.id
		join ap_detection on ap_detection.ap_id = ap.id
		join observation_wifi on observation_wifi.fingerprint_id = ap_detection.observation_wifi_fingerprint_id
		join fingerprint on fingerprint.id = fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_wifi_fingerprint_id, ap.id
	
	
	
	

select *
from bluetooth_device
		join bluetooth_device_data_source on bluetooth_device_data_source.bluetooth_device_id = bluetooth_device.id
		join data_source on data_source.id = bluetooth_device_data_source.data_source_id
where  data_source.name ='TUT4'			

		
	

select bluetooth_device.name, bluetooth_device.id, count(*)
from bluetooth_device
		join bluetooth_device_data_source on bluetooth_device_data_source.bluetooth_device_id = bluetooth_device.id
		join data_source on data_source.id = bluetooth_device_data_source.data_source_id
where  data_source.name in ('TUT3', 'TUT4')			
group by bluetooth_device.name, bluetooth_device.id
order by bluetooth_device.name, bluetooth_device.id
	

		
		
select *
from bluetooth_device
		join bluetooth_device_data_source on bluetooth_device_data_source.bluetooth_device_id = bluetooth_device.id
		join bluetooth_detection on bluetooth_detection.bluetooth_device_id = bluetooth_device.id
		join observation_bluetooth on observation_bluetooth.fingerprint_id = bluetooth_detection.observation_bluetooth_fingerprint_id
		join fingerprint on fingerprint.id = fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_bluetooth_fingerprint_id, bluetooth_device.id
		
	
	

	
		
select *
from observation_gnss
		join fingerprint on fingerprint.id = observation_gnss.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_gnss.fingerprint_id
	
	
		
	
		
select *
from observation_imu
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id
	
		
select count(*)
from observation_imu
		join observation_imu_accelerometer on observation_imu_accelerometer.fingerprint_id = observation_imu.fingerprint_id
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id	
	
	
select *
from observation_imu
		join observation_imu_accelerometer on observation_imu_accelerometer.fingerprint_id = observation_imu.fingerprint_id
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id	
limit 10
	
	
	

select count(*)
from observation_imu
		join observation_imu_gyroscope on observation_imu_gyroscope.fingerprint_id = observation_imu.fingerprint_id
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id	
	
	
select *
from observation_imu
		join observation_imu_gyroscope on observation_imu_gyroscope.fingerprint_id = observation_imu.fingerprint_id
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id	
limit 10	


select count(*)
from observation_imu
		join observation_imu_magnetometer on observation_imu_magnetometer.fingerprint_id = observation_imu.fingerprint_id
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id	
	
	
select *
from observation_imu
		join observation_imu_magnetometer on observation_imu_magnetometer.fingerprint_id = observation_imu.fingerprint_id
		join fingerprint on fingerprint.id = observation_imu.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where  data_source.name='TUT4'	
order by observation_imu.fingerprint_id	
limit 10	
		
		


select data_source.name, ml_purpose, count(*)
from fingerprint
		join data_source on data_source.id = fingerprint.data_source_id
group by data_source.name, ml_purpose
order by data_source.name, ml_purpose




select data_source.name, is_radio_map, count(*)
from fingerprint
		join data_source on data_source.id = fingerprint.data_source_id
group by data_source.name, is_radio_map




select fingerprint.id, preceded_by_fingerprint_id, followed_by_fingerprint_id
from fingerprint
		join data_source on data_source_id = data_source.id
where data_source.name = 'DSI_trajectories'
order by fingerprint.id



select data_source, count(*) 
from place  -- in uji: 905*2 + 3 +13 = 1826
		join place_data_source on place_data_source.place_id = place.id
		join data_source on data_source_id = data_source.id
group by data_source




select * 
from place 
		join building on building.place_id = place.id
		join place_data_source on place_data_source.place_id = place.id
		join data_source on data_source_id = data_source.id



select * 
from place 
		join floor on floor.place_id = place.id
		join place_data_source on place_data_source.place_id = place.id
		join data_source on data_source_id = data_source.id





select * 
from place 
		join site on site.place_id = place.id
		join place_data_source on place_data_source.place_id = place.id
		join data_source on data_source_id = data_source.id		
		
		
		

select * 
from place as bldplace
		join building on building.place_id = bldplace.id
		join contains on bldplace.id = contains.container_place_id
		join place_data_source on place_data_source.place_id = bldplace.id
		join data_source on data_source_id = data_source.id		
where bldplace.name = '0'




select flrplace.name as flrname, flrabove.name as above_of, flrbelow.name as below_of
from place as flrplace
		join floor on floor.place_id = flrplace.id
		left outer join place as flrabove on above_of_floor_place_id = flrabove.id
		left outer join place as flrbelow on below_of_floor_place_id = flrbelow.id
where flrplace.id in (	select contained_place_id
				 		from place as bldplace
						 	join building on building.place_id = bldplace.id
							join contains on bldplace.id = contains.container_place_id
						where bldplace.name = '0')
			



select placeb.id as bld_id, placeb.name as bld_name, placef.id as flr_id, placef.name as flr_name, count(*)
from place as placeb
		join building on placeb.id = building.place_id
		join place_data_source on place_data_source.place_id = placeb.id
		join data_source on data_source_id = data_source.id
		left outer join contains as containsf on placeb.id = containsf.container_place_id
		left outer join place as placef on placef.id = containsf.contained_place_id
where data_source.name like 'TUT%'
group by placeb.id, placeb.name, placef.id, placef.name




select placeb.id as bld_id, placeb.name as bld_name, placef.id as flr_id, placef.name as flr_name, places.id as site_id, places.name as site_name, count(*)
from place as placeb
		join building on placeb.id = building.place_id
		join place_data_source on place_data_source.place_id = placeb.id
		join data_source on data_source_id = data_source.id
		left outer join contains as containsf on placeb.id = containsf.container_place_id
		left outer join place as placef on placef.id = containsf.contained_place_id
		left outer join contains as containss on containsf.contained_place_id = containss.container_place_id
		left outer join place as places on places.id = containss.contained_place_id
where data_source.name like 'TUT%'
group by placeb.id, placeb.name, placef.id, placef.name, places.id, places.name




select *
from tessellation
		join place on place.id = tessellation.floor_place_id
		join floor on place.id = floor.place_id
		join data_source on data_source.id = tessellation.data_source_id
		



select tessellation.id, tessellation.floor_place_id, data_source.name, tessellation.type, count(*)
from tessellation
		join place on place.id = tessellation.floor_place_id
		join floor on place.id = floor.place_id
		join data_source on data_source.id = tessellation.data_source_id
group by tessellation.id, tessellation.floor_place_id, data_source.name, tessellation.type	
order by tessellation.id, tessellation.floor_place_id, data_source.name, tessellation.type
	


				
select *
from tessellation
		join tile on tile.tessellation_id = tessellation.id
		join place as plctile on plctile.id = tile.place_id
		join place on place.id = tessellation.floor_place_id
		join floor on place.id = floor.place_id
		join data_source on data_source.id = tessellation.data_source_id	
where data_source.name = 'TUT4'
		
	
	
	
	
	
select *
from tessellation
		join tile on tile.tessellation_id = tessellation.id
		join place as plctile on plctile.id = tile.place_id
		join place on place.id = tessellation.floor_place_id
		join floor on place.id = floor.place_id
		join data_source on data_source.id = tessellation.data_source_id	
		join fingerprint on fingerprint.acquired_at_tile_place_id = tile.place_id
where data_source.name = 'TUT4'


	
	
	
		
select tile_start_place.name, tile_end_place.name
from tile as tile_start
		join place as tile_start_place on tile_start.place_id = tile_start_place.id
		join adjacent_to_tile on adjacent_to_tile.tile_1_place_id = tile_start.place_id
		join tile as tile_end on adjacent_to_tile.tile_2_place_id = tile_end.place_id
		join place as tile_end_place on tile_end.place_id = tile_end_place.id
		join place_data_source on place_data_source.place_id = tile_start_place.id
		join data_source on data_source_id = data_source.id
where data_source.name = 'SIM001'




select *
from evaluation_support.ground_truth_info
		join fingerprint on fingerprint.id = ground_truth_info.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where data_source.name = 'TUT4' and fingerprint.ml_purpose = 'training'



select *
from evaluation_support.ground_truth_info
		join fingerprint on fingerprint.id = ground_truth_info.fingerprint_id
		join data_source on data_source.id = fingerprint.data_source_id
where (fingerprint.ml_purpose = 'test' and tile_place_id is not null)
		or (fingerprint.ml_purpose = 'training' and tile_place_id is null)
