# compare heel versus toe strike
library(tidyverse)

# load data and compute stride period and duty cycle
# if i knew velocity would also get stride length
raw  <- read_csv('stride-data.csv')
data <- mutate(raw,
               stride.period = (next.down-down)/frame.rate,
               stride.frequency = 1/stride.period,
               stride.length = u/stride.period,
               duty.cycle = (up-down)/(next.down-down))
grouped  <- group_by(data, treatment)

# do some stats
foo  <- aov(stride.period~treatment,data)
bar  <- aov(stride.frequency~treatment,data)
baz  <- aov(stride.length~treatment,data)
boo  <- aov(duty.cycle~treatment,data)

# get some group stats
grouped.results  <- summarise(grouped,
                              mean.stride.period=mean(stride.period),
                              sd.stride.period=sd(stride.period),
                              mean.stride.frequency=mean(stride.frequency),
                              sd.stride.frequency=sd(stride.frequency),
                              mean.stride.length=mean(stride.length),
                              sd.stride.length=sd(stride.length),
                              mean.duty.cycle=mean(duty.cycle),
                              sd.duty.cycle=sd(duty.cycle),
                              n=n())

#now do plots
stride.period.plot <- ggplot(grouped.results,
                             aes(x=treatment,y=mean.stride.period))+
    geom_col(width=0.5)+
    geom_errorbar(aes(ymin=mean.stride.period-sd.stride.period,
                      ymax=mean.stride.period+sd.stride.period),width=0.2)+
    ylab('stride period, s')+
    annotate("text",x=2,y=0.67,label='*')+
    theme_bw(base_size=8)+
    theme(text=element_text(size=8),
          axis.title.x=element_blank(),
          axis.text.x=element_text(size=8),
          axis.text.y=element_text(size=8))
pdf('stride-period.pdf',width=1.5,height=1.5)
print(stride.period.plot)
dev.off()

stride.frequency.plot <- ggplot(grouped.results,
                                aes(x=treatment,y=mean.stride.frequency))+
    geom_col(width=0.5)+
    geom_errorbar(aes(ymin=mean.stride.frequency-sd.stride.frequency,
                      ymax=mean.stride.frequency+sd.stride.frequency),
                  width=0.2)+
    ylab('stride frequency, Hz')+
    annotate("text",x=2,y=1.625,label='*')+
    theme_bw(base_size=8)+
    theme(text=element_text(size=8),
          axis.title.x=element_blank(),
          axis.text.x=element_text(size=8),
          axis.text.y=element_text(size=8))
pdf('stride-frequency.pdf',width=1.5,height=1.5)
print(stride.frequency.plot)
dev.off()

stride.length.plot <- ggplot(grouped.results,
                             aes(x=treatment,y=mean.stride.length))+
    geom_col(width=0.5)+
    geom_errorbar(aes(ymin=mean.stride.length-sd.stride.length,
                      ymax=mean.stride.length+sd.stride.length),width=0.2)+
    ylab('stride length, m')+
    annotate("text",x=2,y=1.625,label='*')+
    theme_bw(base_size=8)+
    theme(text=element_text(size=8),
          axis.title.x=element_blank(),
          axis.text.x=element_text(size=8),
          axis.text.y=element_text(size=8))
pdf('stride-length.pdf',width=1.5,height=1.5)
print(stride.length.plot)
dev.off()

duty.cycle.plot <- ggplot(grouped.results,
                          aes(x=treatment,y=mean.duty.cycle))+
    geom_col(width=0.5)+
    geom_errorbar(aes(ymin=mean.duty.cycle-sd.duty.cycle,
                      ymax=mean.duty.cycle+sd.duty.cycle),width=0.2)+
    ylab('duty cycle')+
    annotate("text",x=2,y=0.42,label='*')+
    theme_bw(base_size=8)+
    theme(text=element_text(size=8),
          axis.title.x=element_blank(),
          axis.text.x=element_text(size=8),
          axis.text.y=element_text(size=8))
pdf('duty-cycle.pdf',width=1.5,height=1.5)
print(duty.cycle.plot)
dev.off()


#> summary(foo)
#            Df   Sum Sq  Mean Sq F value   Pr(>F)    
#treatment    1 0.009592 0.009592   37.51 4.74e-07 ***
#Residuals   36 0.009206 0.000256                     

#> summary(bar)
#            Df  Sum Sq Mean Sq F value   Pr(>F)    
#treatment    1 0.05237 0.05237   37.27 5.03e-07 ***
#Residuals   36 0.05058 0.00140                     

#> summary(baz)
#            Df  Sum Sq Mean Sq F value   Pr(>F)    
#treatment    1 0.05237 0.05237   37.27 5.03e-07 ***
#Residuals   36 0.05058 0.00140                     

#> summary(boo)
#            Df  Sum Sq Mean Sq F value   Pr(>F)    
#treatment    1 0.04278 0.04278   73.75 3.07e-10 ***
#Residuals   36 0.02088 0.00058                     



#> print(grouped.results,width=100)
## A tibble: 2 x 10
#  treatment mean.stride.peri… sd.stride.period mean.stride.fre… sd.stride.frequ…
#  <chr>                 <dbl>            <dbl>            <dbl>            <dbl>
#1 heel                  0.673           0.0131             1.49           0.0280
#2 toe                   0.641           0.0180             1.56           0.0436
#  mean.stride.length sd.stride.length mean.duty.cycle sd.duty.cycle     n
#               <dbl>            <dbl>           <dbl>         <dbl> <int>
#1               1.49           0.0280           0.463        0.0262    17
#2               1.56           0.0436           0.396        0.0222    21
