library(tidyverse)

winning_data <- read_csv("derived_data/winning_data.csv")

winner_starBakers <- winning_data %>%
    filter(series_winner == 1) %>% 
    select(series, baker_first, baker_last, nstar_baker, bread_star_baker, technical_winner) %>%
    arrange(series)

sb_plot <- ggplot(winner_starBakers, aes(x = series, y = nstar_baker, fill = as.factor(bread_star_baker))) +
    geom_bar(stat = "identity") +
    labs(fill = "Bread Week Star Baker",
         title = "Series Winners and Number of Star Bakers") +
    scale_fill_manual("Bread Week Star Baker",
                      values = c("0" = "#fdaba3", "1" =  "#1ab2cc"),
                      labels = c("No", "Yes")) +
    theme_minimal() +
    scale_x_continuous(breaks = seq(1:10),
        labels = 1:10) +
    ylab(label = "# Star Bakers")
    
ggsave("figures/winner_number_starbakers.png", plot = sb_plot)

technical_plot <- ggplot(winner_starBakers, aes(x = series, y = technical_winner)) +
    geom_bar(stat = "identity", fill = "#629d62") +
    labs(title = "Series Winners and Number of Technical Challenges Won") +
    theme_minimal() +
    scale_x_continuous(breaks = seq(1:10),
                       labels = 1:10) +
    ylab(label = "# Technical Challenge Wins")

ggsave("figures/winner_number_technicals.png", plot = technical_plot)
