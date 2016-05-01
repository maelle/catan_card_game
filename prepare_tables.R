
cities <- read_csv("data/worldcities.csv")
market <- readr::read_csv("data/market.csv")
damien <- readr::read_csv("data/damien.csv")
maelle <- readr::read_csv("data/maelle.csv")
emojis <- readr::read_csv("data/emojis.csv")

library("tidyr")
library("dplyr")

# transform market table

market <- market %>% gather(what, count, lumber:ncol(market)) %>%
  left_join(emojis, by = c("what" = "name")) %>%
  filter(count > 0)


market <- market[rep(seq_len(nrow(market)), market$count),]

market <- market %>%
  select(- count) %>%
  group_by(round, what, emoji) %>%
  mutate(which = 1:n()) %>%
  ungroup()

# get cities to put the things
tobelocated <- market %>%
  select(what, emoji, which) %>%
  unique()

canada <- filter(cities, ISO_31661_country_code == "FR")
set.seed(3)
where <- sample_n(canada, nrow(tobelocated),
                          replace = FALSE)

tobelocated <- cbind(where, tobelocated) 

market <- market %>% left_join(tobelocated,
                               by = c("emoji", "which", "what"))
market <- select(market, round, what, emoji, which, latitude, longitude) %>%
  mutate(who = "market")

##################################################################
# transform maelle table

maelle <- maelle %>% gather(what, count, lumber:ncol(maelle)) %>%
  left_join(emojis, by = c("what" = "name")) %>%
  filter(count > 0)


maelle <- maelle[rep(seq_len(nrow(maelle)), maelle$count),]

maelle <- maelle %>%
  select(- count) %>%
  group_by(round, what, emoji) %>%
  mutate(which = 1:n()) %>%
  ungroup()

# get cities to put the things
tobelocated <- maelle %>%
  select(what, emoji, which) %>%
  unique()

usa <- filter(cities, ISO_31661_country_code == "ES",
              longitude < 110)
set.seed(1)
where <- sample_n(usa, nrow(tobelocated),
                  replace = FALSE)

tobelocated <- cbind(where, tobelocated) 

maelle <- maelle %>% left_join(tobelocated,
                               by = c("emoji", "which", "what"))
maelle <- select(maelle, round, what, emoji, which, latitude, longitude) %>%
  mutate(who = "maelle")

#########################################################################

##################################################################
# transform damien table

damien <- damien %>% gather(what, count, lumber:ncol(damien)) %>%
  left_join(emojis, by = c("what" = "name")) %>%
  filter(count > 0)


damien <- damien[rep(seq_len(nrow(damien)), damien$count),]

damien <- damien %>%
  select(- count) %>%
  group_by(round, what, emoji) %>%
  mutate(which = 1:n()) %>%
  ungroup()

# get cities to put the things
tobelocated <- damien %>%
  select(what, emoji, which) %>%
  unique()

russia <- filter(cities, ISO_31661_country_code == "DE")
set.seed(3)
where <- sample_n(russia, nrow(tobelocated),
                  replace = FALSE)

tobelocated <- cbind(where, tobelocated) 

damien <- damien %>% left_join(tobelocated,
                               by = c("emoji", "which", "what"))
damien <- select(damien, round, what, emoji, which, latitude, longitude) %>%
  mutate(who = "damien")


