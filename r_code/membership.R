library(foreign)
library(ggplot2)
library(tidyr)
library(dplyr)

members<-read.csv(file='./Data/membership_data_NDP.csv', colClasses=c('Date', 'numeric','numeric', 'numeric', 'numeric', 'numeric','numeric', 'Date', 'character'))
str(members)

theme_set(theme_bw())
members %>% 
  select(population, votes_previous_election, seats_previous_election, members, date, recent_election) %>% 
  mutate(., members_per_capita=members/population, members_votes=members/votes_previous_election, members_seats=members/seats_previous_election) %>% 
  rename(., `Members\nper_capita`=members_per_capita, `Members\nper_vote`=members_votes, `Members\nper_seat`=members_seats) %>%
  gather(Variable, Value, 7:9) %>% 
  ggplot(., aes(x=date, y=Value, group=recent_election))+geom_point(aes(col=factor(recent_election)))+scale_color_discrete(name = "Recent Election")+scale_x_date() +facet_wrap(~Variable, scales='free')
ggsave(filename='Plots/members_votes_seats_data.png', width=6, height=2)


members %>% 
  select(population, votes_previous_election, seats_previous_election, members, date, recent_election) %>% 
  mutate(., members_per_capita=members/population, members_votes=members/votes_previous_election, members_seats=members/seats_previous_election) %>% 
  rename(., `Members\nper_capita`=members_per_capita, `Members\nper_vote`=members_votes, `Members\nper_seat`=members_seats) %>%
  gather(Variable, Value, 7:9) %>% 
  ggplot(., aes(x=as.character(date), y=Value, group=recent_election))+geom_point(aes(col=factor(recent_election)))+scale_color_discrete(name = "Recent Election")+facet_wrap(~Variable, scales='free')+geom_smooth(method='loess', span =0.5)

