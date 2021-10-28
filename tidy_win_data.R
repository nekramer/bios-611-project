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
    