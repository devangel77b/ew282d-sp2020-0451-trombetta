library(tidyverse)
library(latex2exp)

data  <- read_csv('accel-data-100hz-tall.csv')

foo = aov(Y~treatment,data)
summary(foo)
#summary(foo)
#              Df Sum Sq Mean Sq F value Pr(>F)
#treatment      1     31   31.29   0.355  0.551
#Residuals   1998 176078   88.13

grouped  <- group_by(data,treatment)
grouped.results  <- summarize(grouped,
                              meanY = mean(Y),
                              sdY = sd(Y))
#> grouped.resultssfdfse
## A tibble: 2 x 3
#  treatment meanY   sdY
#  <chr>     <dbl> <dbl>
#1 heel       9.56  8.75
#2 toe        9.31  9.99

f  <- ggplot(data,aes(x=treatment,y=Y))+geom_boxplot()+
    ylab(TeX('a$_Y$, m/s$^2$'))+
    theme_bw()+
    theme(text=element_text(size=8),
          axis.title.x=element_blank())
pdf('accel-comparison.pdf',width=3,height=2)
print(f)
dev.off()


