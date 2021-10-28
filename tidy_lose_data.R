library(tidyverse)

episode_results <- read_csv("source_data/episode_results.csv")
challenge_results <- read_csv("source_data/challenge_results.csv")

## Get eliminated from each first episode and get technical rank
first_eliminations <- challenge_results %>%
    filter(episode == 1) %>%
    filter(result == "OUT") %>%
    rename("baker_first" = baker) %>%
    mutate(baker_first = str_to_lower(baker_first)) %>%
    left_join(episode_results, by = c("series", "episode")) %>%
    select(series, episode, baker_first, technical, bakers_appeared)
write_csv(first_eliminations, "derived_data/first_eliminations.csv")
