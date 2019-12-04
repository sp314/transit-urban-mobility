library(tidyverse)
library(sf)
library(tigris)

va_roads <- primary_secondary_roads(state = "VA") %>%
	st_transform(crs = 102285)
md_roads <- primary_secondary_roads(state = "MD") %>%
	st_transform(crs = 102285)
dc_roads <- primary_secondary_roads(state="DC") %>%
	st_transform(crs = 102285)

# Join total state tracts from each state together
DMV_roads <- rbind(va_roads, md_roads, dc_roads) %>%
	st_transform(crs = 102285)

# Import census tracts of interest (those in the Uber movement dataset)
load("data/dc_tracts.RData")
theme_map <- theme_void()

dc_roads <- DMV_roads %>% 
	filter(lengths(st_touches(., dc_tracts)) > 0)

#CHECK IF VALID
# ggplot() +
# 	geom_sf(data = dc_tracts, alpha = 0.5) +
# 	geom_sf(data = dc_roads)

save(dc_roads, file = "data/dc_roads.RData")
