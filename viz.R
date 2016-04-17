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

market <- market %>% gather(what, count, lumber:ore) %>%
  left_join(emojis, by = c("what" = "name"))


for (i in 1:nrow(market)){
  market$id <- 
  if(market$count[i] > 1){
    market <- bind_rows(market,
                        market[rep(i, market$count[i] - 1),])
  }
}

market <- select(market, round, what, emoji)
