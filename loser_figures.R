library(tidyverse)

first_eliminations <- read_csv("derived_data/first_eliminations.csv")

technical_losses <- first_eliminations %>%
    na.omit() %>%
    mutate(technical_rank = technical/bakers_appeared)

# Bigger number = worse ranking

technical_losses_plot <- ggplot(technical_losses, aes(x = series, y = technical_rank)) +
    geom_line(color = "#a5774c") +
    geom_point(color = "#543f29") +
    scale_x_continuous(breaks = 1:10) +
    theme_minimal() +
    ylab(label = "Technical Rank (Place in Technical/Total # Bakers)") +
    labs(title = "Technical Challenge Rankings of First Eliminations in Series")

ggsave("figures/first_losers_technicals.png", plot = technical_losses_plot)
