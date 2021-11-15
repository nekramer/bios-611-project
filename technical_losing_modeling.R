library(tidyverse)

source("utils.R")

technical_results <- read_csv("source_data/challenge_results.csv") %>%
    mutate(result = replace(result, result %in% c("Runner-up", "WINNER", "STAR BAKER"),
                            "IN")) %>%
    mutate(result = (result == "IN")*1) %>%
    select(series, episode, baker, result, technical) %>%
    drop_na() %>%
    mutate(train = runif(length(result)) < 0.75)
    
# Split into training and test
train <- technical_results %>% filter(train)
test <- technical_results %>% filter(!train)

model_formula <- result ~ technical
technical_model <- glm(formula = model_formula, data = train, family = "binomial")
save(technical_model, file = "derived_data/technical_model.rda")

pred <- predict(technical_model, newdata = test, type = "response")

roc <- maprbind(function(thresh){
    ltest <- test %>% mutate(pred=1*(pred>=thresh)) %>%
        mutate(correct = pred == result)
    tp <- ltest %>% filter(ltest$result==0) %>% pull(correct) %>% rate()
    fp <- ltest %>% filter(ltest$result==1) %>% pull(correct) %>% `!`() %>% rate()
    tibble(threshold=thresh, true_positive=tp, false_positive=fp)
}, seq(from=0, to=1, length.out=1000)) %>% arrange(false_positive, true_positive)

roc_technical <- ggplot(roc, aes(false_positive, true_positive)) + geom_line() +
    xlim(0, 1) + ylim(0, 1) + labs(title = "ROC Curve of Winner Predicting Model",
                                   x = "False Positiive Rate", y = "True Positive Rate") +
    theme_minimal()
ggsave("figures/roc_technical.png", plot = roc_technical)
