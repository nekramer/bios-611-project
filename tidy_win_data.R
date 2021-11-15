library(tidyverse)

episode_names <- read_csv("source_data/episode_names.csv")

## Read in episode_results, join episode name, and determine if "Bread Week"
episode_results <- read_csv("source_data/episode_results.csv") %>% 
    mutate("sb_name" = str_to_lower(sb_name)) %>%
    left_join(episode_names, by = c("series", "episode")) %>%
    mutate(bread_week = 1*(grepl("Bread", name)))

bread_star_bakers <- episode_results %>%
    filter(bread_week == 1) %>%
    pull(sb_name)
    
## Read in baker_results
baker_results <- read_csv("source_data/baker_results.csv")
baker_results <- baker_results %>% 
    mutate("baker_first" = str_to_lower(baker_first),
           "baker_last" = str_to_lower(baker_last),
           "bread_star_baker" = 1*(baker_first %in% bread_star_bakers)) %>%
    select(-star_baker)
    
## star_baker column is all 0s -> get correct number of star bakers per baker
## and join to baker results
baker_results <- episode_results %>% 
    separate_rows(sb_name, sep = ",") %>%
    group_by(sb_name) %>%
    count() %>%
    drop_na() %>%
    rename("nstar_baker" = n,
           "baker_first" = sb_name) %>%
    ungroup() %>%
    right_join(baker_results) %>%
    mutate(nstar_baker = replace_na(nstar_baker, 0))

## Compile winning data
winning_data <- baker_results %>%
    select(series, baker_first, baker_last, age,
           technical_winner, technical_top3,
           nstar_baker, bread_star_baker,
           series_winner)
write_csv(winning_data, "derived_data/winning_data.csv")

## Series 10 episode-by-episode data for predicting probability of winning
series10_bread <- read_csv("source_data/episode_names.csv") %>%
    filter(series == 10, name == "Bread") %>% pull(episode)

series10_bakers <- read_csv("source_data/baker_results.csv") %>%
    filter(series == 10) %>% select(baker, age)


series10_episode_predictors <- read_csv("source_data/challenge_results.csv") %>%
    filter(series == 10) %>%
    mutate(bread_star_baker = ifelse(episode == series10_bread & result == "STAR BAKER", 1, 0),
           technical_winner = (technical == 1)*1,
           technical_top3 = (technical >= 3)*1,
           nstar_baker = (result == "STAR BAKER")*1) %>%
    group_by(baker) %>%
    mutate(bread_star_baker = cumsum(bread_star_baker),
           technical_winner = cumsum(technical_winner),
           technical_top3 = cumsum(technical_top3),
           nstar_baker = cumsum(nstar_baker)) %>%
    ungroup() %>%
    select(-result, -signature, -technical, -showstopper) %>%
    left_join(series10_bakers)
write_csv(series10_episode_predictors, "derived_data/series10_episode_predictors.csv")
    