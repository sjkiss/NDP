
library(ggplot2)
library(tidyverse)
library(here)
out<-read.csv(file='Data/convention_delegate_count.csv')
out
theme_set(theme_bw())
out
out %>% 
  group_by(Union, Year) %>% 
  mutate(pct=sum(percent)*100) %>% 
  distinct(., pct, keep_all=T) %>% 
  filter(Union==1) %>% 
  arrange(., Year) %>% 
  group_by() %>% 
  summarize(avg=mean(pct))

out %>% 
  group_by(Union, Year) %>% 
  mutate(pct=sum(percent)*100) %>% 
  distinct(., pct, keep_all=T) %>% 
  filter(Union==1) %>% 
  arrange(., Year) %>% 
  mutate(Year2=as.Date(paste(Year, 1,1, sep='-'))) %>% 
  ggplot(., aes(x=Year2, y=pct))+geom_point()+ylim(c(0,1))+scale_x_date(date_labels='%Y', date_breaks='years')+labs(title='Share of Union Delegates to NDP Conventions', x='Year')+scale_y_continuous(breaks=seq(0,100,10))+ylim(0,100)+theme(axis.text.x=element_text(angle=45, hjust=1))
ggsave('../Data/share_union_delegates.png')
