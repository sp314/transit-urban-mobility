library(tidyverse)
library(tidycensus)
library(sf)

# Set up census api
census_api_key("c1158c3b735c3708ba05dd80bf17f753fb52a247", install = TRUE)

# Import census tracts of interest (those in the Uber movement dataset)
load("data/dc_tracts.RData")

# Look at and choose what acs variables we want to include
v17 <- load_variables(2017, "acs5", cache = TRUE)
View(v17)
acs_vars <- c(med_income = "B19013_001", 
							med_age = "B01002_001", 
							white = "B02001_002", 
							asian = "B02001_005", 
							black = "B02001_003",
							car_transit = "B08301_002",
							public_transit = "B08301_010", 
							not_citizen = "B05001_006",
							spanish_speaking = "B06007PR_003",
							less_than_high_school = "B06009_002", 
							high_school_grad = "B06009_003", 
							some_college = "B06009_004",
							bachelor_deg = "B06009_005",
							advanced_deg = "B06009_006")

# Create dataframe of acs variables of interest from each tract in the 3 states
dc_acs <- rbind(get_acs(geography = "tract", variables = acs_vars, state = "DC", output = "wide"),
													get_acs(geography = "tract", variables = acs_vars, state = "VA", output = "wide"),
													get_acs(geography = "tract", variables = acs_vars, state = "MD", output = "wide"))

# Join acs data on the census tracts of interest (those in the Uber movement dataset)
dc_acs_tracts <- left_join(x = dc_tracts, y = dc_acs, by = "GEOID")

# # Save joined acs data by tract
# save(dc_acs_tracts, file = "data/dc_acs_tracts.RData")
