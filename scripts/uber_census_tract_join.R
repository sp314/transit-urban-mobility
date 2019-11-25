library(tigris)
options(tigris_class="sf")

# Read in census tracts for each state that's in dataset, make sure to use crs http://epsg.io/102285
VA_tracts <- tracts(state = "VA") %>%
	st_transform(crs = 102285)
MD_tracts <- tracts(state = "MD") %>%
	st_transform(crs = 102285)
DC_tracts <- tracts(state = "DC") %>%
	st_transform(crs = 102285)

# Join total state tracts from each state together
DMV_tracts <- rbind(VA_tracts, MD_tracts, DC_tracts) %>%
	st_transform(crs = 102285)

# Read in uber census tract travel times
load("data/travel_times.RData")
theme_map <- theme_void()

travel_times <- travel_times %>%
	mutate(origin_id = factor(origin_id),
				 dest_id = factor(dest_id))

dc_census <- st_read("data/washington_DC_censustracts.json") %>%
	select("id" = MOVEMENT_ID, geometry) %>%
	mutate(id = factor(id, levels = levels(travel_times$dest_id)))

travel_time_sf <- left_join(x = travel_times, y = dc_census, by = c("dest_id" = "id")) %>%
	st_as_sf() %>%
	st_transform(crs = 102285)

# Join both spatial datasets together with the closest polygon match
# WARNING: This takes a little while
travel_time_census_join_sf <- st_join(travel_time_sf, DMV_tracts, largest = TRUE)

travel_time_census_join <- travel_time_census_join_sf %>%
	dplyr::select(dest_id, dest_name, year, month, week, mean_travel_time, lower_travel_time, upper_travel_time, GEOID, NAMELSAD)

# CHECK TO SEE IF VALID
# # Filter the total state tracts to include only those from the uber set
# joined_tract_geoid <- travel_time_census$GEOID%>% unique()
# joined_tracts <- DMV_tracts %>%
# 	filter(GEOID %in% joined_tract_geoid)
# 
# # Plot to make sure the joined tracts look like what we see in the uber data set. We got a match c:
# uber_tracts %>%
# 	ggplot() +
# 	geom_sf()

# # save joined dataset and the census tracts
save(travel_time_census_join, file = "travel_time_census_join.RData")
