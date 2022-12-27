## Find which states does the Zipcode Lat/Lon belong to

library(sf)
library(data.table)
library(ggplot2)

## Read Shapefile
## From https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html

US_states = st_read(dsn="D:\\myRcode\\Data\\ShapeFiles\\US_States\\cb_2021_us_state_500k.shp")
US_states_dt = as.data.table(US_states)
US_states_dt[,geometry := NULL]

### US Zipcodes
### From https://www.census.gov/geographies/reference-files/time-series/geo/gazetteer-files.html

US_zips = fread("D:\\myRcode\\Data\\CSV\\US_ZipCodes\\2022_Gaz_zcta_national.txt")
US_zips[,GEOID:=sprintf("%05d", GEOID)]

points = US_zips[,.(ZIPCODE = GEOID, LON=INTPTLONG, LAT=INTPTLAT)]
pnts_sf <- st_as_sf(points, coords = c('LON', 'LAT'), crs = st_crs(US_states))

idx = st_intersects(pnts_sf, US_states)
idx = unlist(sapply(idx, function(x){if(length(x)==0){NA}else{x}}))
idx = data.table(idx)
US_Zip_State = US_states_dt[idx$idx]
US_Zip_State = cbind(points, US_Zip_State)

US_Zip_State[is.na(NAME)]

points_na = US_Zip_State[is.na(NAME)][,.(ZIPCODE, LON, LAT)]
pnts_sf_na <- st_as_sf(points_na, coords = c('LON', 'LAT'), crs = st_crs(US_states))

plot(st_geometry(US_Contiguous_States))
plot(pnts_sf_na, pch=3, col="red", add=T)

idx = st_nearest_feature(pnts_sf_na, US_states)
idx = unlist(sapply(idx, function(x){if(length(x)==0){NA}else{x}}))
idx = data.table(idx)
US_Zip_State_na = US_states_dt[idx$idx]
US_Zip_State_na = cbind(points_na, US_Zip_State_na)

US_Zip_State = rbind(US_Zip_State[!is.na(NAME)], US_Zip_State_na)
