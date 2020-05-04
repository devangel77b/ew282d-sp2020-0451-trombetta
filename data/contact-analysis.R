library(tidyverse)

data  <- read_csv('contact.csv')
selected = select(data,treatment,contact.deg,ankle.deg)
gathered  <- gather(selected,key,value,contact.deg,ankle.deg)

fig <- ggplot(gathered,aes(x=treatment,fill=key,y=value))+geom_boxplot()+
    ylab('degrees')+
    scale_fill_manual(values=c("gray30","gray90"),name='angle',labels=c('ankle','contact'))+
    theme_bw(base_size=8)+
    theme(text=element_text(size=8),
          axis.title.x=element_blank(),
          axis.text.x=element_text(size=8),
          axis.text.y=element_text(size=8),
          legend.position='right')

pdf("contact-angle.pdf",width=4,height=2)
print(fig)
dev.off()

t.test(contact.deg-ankle.deg~treatment,data)
#	Welch Two Sample t-test
#data:  contact.deg - ankle.deg by treatment
#t = -34.358, df = 24.476, p-value < 2.2e-16
#alternative hypothesis: true difference in means is not equal to 0
#95 percent confidence interval:
# -25.98203 -23.04029
#sample estimates:
#mean in group heel  mean in group toe 
#          3.296979          27.808136 

grouped  <- group_by(data,treatment)
grouped.results <- summarise(grouped,
    mean.diff = mean(contact.deg-ankle.deg),
    sd.diff = sd(contact.deg-ankle.deg))

#> grouped.results
## A tibble: 2 x 3
#  treatment mean.diff sd.diff
#  <chr>         <dbl>   <dbl>
#1 heel           3.30   0.822
#2 toe           27.8    3.21 
