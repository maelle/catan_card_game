# I got a file with cities from http://www.opengeocode.org/download.php#cities
# then I transformed it:
library("dplyr")
library("readr")
cities <- read_csv("data/worldcities.csv")
names(cities) <- gsub(" ", "_", names(cities))
names(cities) <- gsub("-", "", names(cities))
cities %>%
  filter(language_script %in% c("latin", "english")) %>%
  select(ISO_31661_country_code,
         name,
         latitude, longitude) %>%
  write_csv(path = "data/worldcities.csv")
