library(tidyverse)
library(MLmetrics)

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

series10_predictions <- ggplot(predictions, aes(x=episode, y=prob*100, group=baker, color=baker)) + 
    geom_line() +
    theme_minimal() +
    scale_x_continuous(breaks = seq(1:10),
                       labels = 1:10) +
    labs(title = "Predicted Probability of Series 10 Winners",
         x = "Episode", y = "Predicted Probability")
ggsave("figures/series10_predictions.png", plot = series10_predictions)

