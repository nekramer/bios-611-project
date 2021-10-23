library(rvest)
library(readr)
library(stringr)
library(tidyr)
library(dplyr)

url_base <- "https://en.wikipedia.org/wiki/The_Great_British_Bake_Off_(series_%d)"

episode_names <- function(series){
    page <- read_html(sprintf(url_base, series))
    contents <- html_text(html_nodes(page, '.toctext'))
    episodeNames <- grep(pattern = "Episode [0-9]+:", x = contents, value = TRUE)
    
    # For each episode name, split into episode number and name
    episode_splits <- str_split(episodeNames, pattern = ": ")
    numbers <- gsub(pattern = "Episode ", replacement = "", lapply(episode_splits, `[[`, 1))
    names <- unlist(lapply(episode_splits, `[[`, 2))
    
    # Make table of episode names
    series_table <- tibble("series" = series,
                           "episode" = numbers,
                           "name" = names)
    return(series_table)
}

episodes_df <- bind_rows(lapply(1:10, episode_names))
    
write_csv(episodes_df, "source_data/episode_names.csv")
