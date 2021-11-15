rate <- function(a){
    sum(a)/length(a);
}
maprbind <- function(f,l){
    do.call(rbind, Map(f, l));
}
roc <- maprbind(function(thresh){
    ltest <- test %>% mutate(pred=1*(pred>=thresh)) %>%
        mutate(correct = pred == series_winner)
    tp <- ltest %>% filter(ltest$series_winner==1) %>% pull(correct) %>% rate()
    fp <- ltest %>% filter(ltest$series_winner==0) %>% pull(correct) %>% `!`() %>% rate();
    tibble(threshold=thresh, true_positive=tp, false_positive=fp)
}, seq(from=0, to=1, length.out=1000)) %>% arrange(false_positive, true_positive)