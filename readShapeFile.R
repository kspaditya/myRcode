## Simple Feature
library(sf)
library(data.table)
library(ggplot2)

## Read Shapefile
## From https://www.census.gov/geographies/mapping-files/time-series/geo/cartographic-boundary.html

US_states = st_read(dsn="D:\\myRcode\\Data\\ShapeFiles\\US_States\\cb_2021_us_state_500k.shp")
US_states_dt = as.data.table(US_states)
US_states_dt[,geometry := NULL]

## Filter based on attributes
US_Contiguous_States = US_states[!US_states$STATEFP %in% c("02","15","60", "66", "69", "72", "78"),]

## Identify the Coordinate Reference System
st_crs(US_states)

## Plot
plot(st_geometry(US_Contiguous_States))

## Plot using ggplot
ggplot(US_Contiguous_States) +
  geom_sf(fill=NA)+
  geom_sf_label(aes(label=STUSPS), size=4)+
  labs(x="", y="")+
  theme_bw()
