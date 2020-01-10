library(rvest)
library(tidyverse)
setwd('~/Dropbox/Book_Project/r_code/')
ndp_leadership<-url('https://en.wikipedia.org/wiki/New_Democratic_Party_leadership_elections')
results<-read_html(ndp_leadership, 'table')

results<-html_nodes(results, 'table')

out<-results %>% 
  html_nodes(xpath="//table") %>% 
  html_table(fill=T)
results %>% 
  html_nodes(xpath='//table')
#Candidates
candidates<-lapply(out[1:10], function(x) x[,2])
candidates<-unlist(candidates)

#Votes
votes<-lapply(out[1:10], function(x) x[,3:4])


votes1<-unlist(lapply(votes, function(x) x[,1]))
votes2<-unlist(lapply(votes, function(x) x[,2]))

leadership<-cbind(candidates, votes1, votes2)

leadership<-data.frame(candidates=as.character(candidates), votes1=votes1, votes2=votes2)
leadership
leadership<-leadership %>% 
  filter(candidates!='Total'&candidates!='Candidate') %>% 
  filter(!(votes1 %in% 'Endorsed Mulcair'))
leadership$votes1<-gsub(',|%', '', leadership$votes1)
leadership$votes1[22:25]<-as.character(leadership$votes2[22:24])
leadership$votes1[25]<-NA
leadership
leadership$year<-c(1961, 1961, rep(1971, 5), rep(1973, 2), rep(1975, 5), rep(1989, 7), rep(1995, 4), rep(2001, 2), rep(2003, 6), rep(2011, 7), rep(2015, 4))
leadership %>% 
  select(candidate=candidates,votes=votes1, year=year)->leadership
leadership
getwd()
#write.csv(leadership, file='../Data/leadership_table.csv')

out<-read.csv(file='../Data/leadership_table.csv')

out %>% 
  filter(leadership_contest==1 & year<1996) %>% 
  group_by(MP, winner) %>% 
  summarize(freq=n()) %>% 
  spread(MP, freq)
head(out)
out %>% 
  filter(leadership_contest==1 & year<1996) %>% 
  group_by(former_leader, winner) %>% 
  summarize(freq=n()) %>% 
  spread(former_leader, freq)
out %>% 
  filter(leadership_contest==1 & year<1996) %>% 
  group_by(former_provincial_MLA, winner) %>% 
  summarize(freq=n()) %>% 
  spread(former_provincial_MLA, freq)
