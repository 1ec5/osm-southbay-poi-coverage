#!/bin/bash

osmium extract -p santa-clara-county-boundary.geojson --overwrite -o $1.osm.pbf norcal-latest.osm.pbf
osmium tags-filter --overwrite -o after-keys.pbf $1.osm.pbf 'building,club,craft,healthcare,landuse,leisure,office,shop,tourism'
osmium tags-filter --overwrite -o after-amenity.pbf $1.osm.pbf 'amenity=animal_boarding,bank,bar,bus_station,cafe,car_wash,childcare,cinema,clinic,college,community_centre,crematorium,dentist,dojo,driving_school,fast_food,flight_school,fuel,ice_cream,kindergarten,language_school,library,music_school,nightclub,pharmacy,place_of_worship,post_office,prep_school,preschool,pub,recycling,restaurant,school,social_facility,studio,theatre,university,veterinary'
osmium tags-filter --overwrite -o after-man_made.pbf $1.osm.pbf 'man_made=works'
osmium tags-filter --overwrite -o after-railway.pbf $1.osm.pbf 'railway=station'
osmium tags-filter --overwrite -o after-aeroway.pbf $1.osm.pbf 'aeroway=aerodrome,heliport'
osmium merge --overwrite -o $1.osm.pbf after-*
osmium tags-filter --overwrite -o $1-named.osm.pbf $1.osm.pbf 'name,ref'
