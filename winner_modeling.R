library(tidyverse)
library(MLmetrics)
library(bakeoff)

source("utils.R")


winning_data <- read_csv("derived_data/winning_data.csv") %>%
    mutate(train = runif(length(series_winner)) < 0.75)

# Split into training and test
train <- winning_data %>% filter(train)
test <- winning_data %>% filter(!train)

# Model predicting series winner
model_formula <- series_winner ~ age + technical_winner + technical_top3 + nstar_baker + bread_star_baker
winner_model <- glm(formula = model_formula, data = train, family = "binomial")
save(winner_model, file = "derived_data/winner_model.rda")

pred <- predict(winner_model, newdata = test, type = "response")

f1_score <- F1_Score(y_true = test$series_winner,
                     y_pred = (pred > 0.5)*1)

roc <- maprbind(function(thresh){
    ltest <- test %>% mutate(pred=1*(pred>=thresh)) %>%
        mutate(correct = pred == series_winner)
    tp <- ltest %>% filter(ltest$series_winner==1) %>% pull(correct) %>% rate()
    fp <- ltest %>% filter(ltest$series_winner==0) %>% pull(correct) %>% `!`() %>% rate()
    tibble(threshold=thresh, true_positive=tp, false_positive=fp)
}, seq(from=0, to=1, length.out=1000)) %>% arrange(false_positive, true_positive)

roc_winner <- ggplot(roc, aes(false_positive, true_positive)) + geom_line() +
    xlim(0, 1) + ylim(0, 1) + labs(title = "ROC Curve of Winner Predicting Model",
                                   x = "False Positiive Rate", y = "True Positive Rate") +
    theme_minimal()
ggsave("figures/roc_winner.png", plot = roc_winner)


series10_episode_predictors <- read_csv("derived_data/series10_episode_predictors.csv")

predictions <- tibble()
for (ep in 1:10){
    episode_predictors <- series10_episode_predictors %>% filter(episode == ep)
    probs <- tibble(episode = ep, baker = episode_predictors$baker,
                    prob = predict(winner_model, 
                                   newdata = episode_predictors, 
                                   type = "response"))
    predictions <- predictions %>% bind_rows(probs)
}

colors <- bakeoff_colors()
series10_predictions <- ggplot(predictions, aes(x=episode, y=prob*100, group=baker, color=baker)) + 
    scale_color_manual(values = c(colors[["cobalt"]], colors[["magenta"]],
                                 colors[["cocoa"]], colors[["riptide"]],
                                 colors[["baltic"]], colors[["marigold"]],
                                 colors[["burgundy"]], colors[["yellow"]],
                                 colors[["garden"]], colors[["violet"]], 
                                 colors[["desertflower"]],
                                 colors[["pear"]], colors[["almond"]])) +
    geom_line() +
    theme_minimal() +
    scale_x_continuous(breaks = seq(1:10),
                       labels = 1:10) +
    labs(title = "Predicted Probability of Series 10 Winners",
         x = "Episode", y = "Predicted Probability")
ggsave("figures/series10_predictions.png", plot = series10_predictions)

