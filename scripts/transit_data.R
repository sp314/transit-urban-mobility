library(tidyverse)
library(sf)

json_query = "https://maps2.dcgis.dc.gov/dcgis/rest/services/DCGIS_DATA/Transportation_WebMercator/MapServer/106/query?where=1%3D1&outFields=*&outSR=102285&f=json"
metro_lines = read_sf(json_query) %>%
	st_transform(crs = 102285)

save(metro_line, file = "data/metro_lines.RData")