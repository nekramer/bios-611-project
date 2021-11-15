rate <- function(a){
    sum(a)/length(a);
}
maprbind <- function(f,l){
    do.call(rbind, Map(f, l));
}
