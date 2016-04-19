cities <- readr::read_csv("data/russia.csv")[,1]
market <- readr::read_csv("data/market.csv")
emojis <- readr::read_csv("data/emojis.csv")

library("tidyr")
library("dplyr")
library("ggplot2")
library("emojifont")
## list available emoji fonts
list.emojifonts()
## load selected emoji font
load.emojifont('OpenSansEmoji.ttf')
library("ggmap")
library("opencage")

# transform market table

market <- market %>% gather(what, count, lumber:ore) %>%
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

russia <- readr::read_csv("data/russia.csv", col_names = FALSE)[,1]
set.seed(3)
where <- NULL
lat <- 1
for(i in 1:nrow(tobelocated)){
  count <- 0
  while(count == 0 | lat == 1){
    newplace <- sample(russia$X1, 1)
    temp <- opencage_forward(placename = newplace,
                             key = Sys.getenv("OPENCAGE_KEY"),
                             country = "RU")
    count <- temp$total_results
    if(count > 0){
      lat <- temp$results$geometry.lat
    }

  }
  where <- rbind(where,
                 c(newplace, temp$results[1,c("geometry.lat", "geometry.lng")]))
}

where <- as.data.frame(where)
names(where) <- c("name", "latitude", "longitude")
tobelocated <- cbind(where, tobelocated) %>%
  mutate(lat = unlist(latitude),
         long = unlist(longitude))

market <- market %>% left_join(tobelocated,
                               by = c("emoji", "which", "what"))
market <- select(market, round, what, emoji, which, lat, long) %>%
  mutate(col = "black")

# map

library("gganimate")
bbox <- c(left = -170, bottom = 0, right = 170, top = 80)
map <- get_map(bbox, maptype = "watercolor")
p = ggmap(map, extent = "device") +
  geom_text(data = market,
             aes(x = long,
                 y = lat,
                 label = emoji(emoji), family='OpenSansEmoji',
                 col = what,
                 frame = round),
            size = 10)+
  theme(text = element_text(size=30))
ani.options(interval = 0.5, ani.width = 800, ani.height = 800)
gg_animate(p, "test.mp4")

