# map

library("ggplot2")
library("emojifont")
## list available emoji fonts
list.emojifonts()
## load selected emoji font
load.emojifont('OpenSansEmoji.ttf')
library("ggmap")
library("gganimate")
library(animation)
todo <- bind_rows(market, damien, maelle)
map <- get_map(location = "France", maptype = "watercolor",
              zoom = 5)
p = ggmap(map, extent = "device") +
  geom_text(x = - 9, y = 44,
             label = "Maëlland") +
  geom_text(x =  7, y = 54,
            label = "Damienland") +
  geom_text(x = 0, y = 50.5,
            label = "Market") +
  geom_text(data = todo,
            aes(x = longitude,
                y = latitude,
                label = emoji(emoji), family='OpenSansEmoji',
                col = who,
                frame = round),
            size = 5)+
  theme(text = element_text(size=20),
        legend.position = "none") +
  ggtitle("Round")
ani.options(interval = 1, ani.width = 400, ani.height = 400)
gg_animate(p, "test.mp4")

