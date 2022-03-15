WITH geovisits_h3_indexed AS (
    SELECT *, `carto-os-eu`.h3.LONGLAT_ASH3(longitude, latitude, 10) h3_idx
    FROM `ggo-ppos-bqgis.singlespot.geovisits_paris_matview`
), h3_events AS (
  SELECT h3_idx, count(*), `carto-os-eu`.h3.ST_BOUNDARY(h3_idx) geometry
  FROM geovisits_h3_indexed
  GROUP BY h3_idx
), 
pois_inside AS (
    SELECT 
      h3_events.h3_idx,
      nodes.id, 
      nodes.latitude, nodes.longitude,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'name' LIMIT 1) name,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'brand' LIMIT 1) brand,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'shop' LIMIT 1) shop,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'amenity' LIMIT 1) amenity,
      CASE 
        WHEN 'shop' in (SELECT key from UNNEST(all_tags)) THEN 'shop'
        WHEN 'amenity' in (SELECT key from UNNEST(all_tags)) THEN 'amenity'
      ELSE 'other'
      END poi_type,
      nodes.all_tags
      FROM `bigquery-public-data.geo_openstreetmap.planet_nodes` AS nodes, nodes.all_tags unnest_all_tags, h3_events
    WHERE 
      ST_DWithin(h3_events.geometry, nodes.geometry,0)
      AND unnest_all_tags.key in ('shop', 'amenity')
  )
SELECT * FROM pois_inside LIMIT 100


SELECT h3_idx, sptId, uuid, latitude, longitude, accuracy, eventId,  
arrival, departure, score, rank, category, feature, placeName 
FROM geovisits_h3_indexes LIMIT 1000



pois_inside AS (
    SELECT 
      nodes.id, 
      nodes.latitude, nodes.longitude,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'name' LIMIT 1) name,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'brand' LIMIT 1) brand,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'shop' LIMIT 1) shop,
      (SELECT value FROM UNNEST(all_tags) WHERE key =  'amenity' LIMIT 1) amenity,
      CASE 
        WHEN 'shop' in (SELECT key from UNNEST(all_tags)) THEN 'shop'
        WHEN 'amenity' in (SELECT key from UNNEST(all_tags)) THEN 'amenity'
      ELSE 'other'
      END poi_type,
      nodes.all_tags
      FROM `bigquery-public-data.geo_openstreetmap.planet_nodes` AS nodes, nodes.all_tags unnest_all_tags, lookup_boundary
    WHERE 
      ST_DWithin(lookup_boundary.geometry, nodes.geometry,0)
      AND unnest_all_tags.key in ('shop', 'amenity')
  )