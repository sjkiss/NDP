
library(foreign)
library(tidyverse)
library(here)

### NDP Convention DelegateShare
#Set Theme
book_theme<-theme_bw(base_size = 16)

theme_set(book_theme)
delegates<-read.csv(file=here('Data', 'convention_delegate_count.csv'))
delegates

delegates %>% 
  group_by(Union, Year) %>% 
  mutate(pct=sum(percent)*100) %>% 
  distinct(., pct, keep_all=T) %>% 
  filter(Union==1) %>% 
  arrange(., Year) %>% 
  mutate(Year2=as.Date(paste(Year, 1,1, sep='-'))) %>% 
  ggplot(., aes(x=Year2, y=pct))+geom_point()+scale_x_date(date_labels='%Y', date_breaks='years')+labs(title='Share of Union Delegates to NDP Conventions', x='Year', y='Percent')+theme(axis.text.x=element_text(angle=90, hjust=1))
ggsave(here('Plots', 'share_union_delegates.png'))

### Members / Electors
members<-read.csv(file=here('Data', 'membership_data_NDP.csv'), colClasses=c('Date', 'numeric','numeric', 'numeric', 'numeric', 'numeric','numeric', 'Date', 'character'))
str(members)

members %>% 
  select(population, votes_previous_election, seats_previous_election, members, date, recent_election) %>% 
  mutate(., members_per_capita=members/population, members_votes=members/votes_previous_election, members_seats=members/seats_previous_election) %>% 
  rename(., `Members\nper_capita`=members_per_capita, `Members\nper_vote`=members_votes, `Members\nper_seat`=members_seats) %>%
  gather(Variable, Value, 7:9) %>% 
  ggplot(., aes(x=date, y=Value, group=recent_election))+geom_point(aes(col=factor(recent_election)))+scale_color_discrete(name = "Recent Election")+scale_x_date() +facet_wrap(~Variable, scales='free')
ggsave(filename=here('Plots', 'members_votes_seats_data.png'), width=6, height=2)
members %>% 
  select(date, members, electors, recent_election) %>% 
  rename(., Members=members, Electors=electors, Date=date, `Recent election`=recent_election) %>% 
  mutate(`M/E`=Members/Electors) %>% 
  ggplot(., aes(x=`Recent election`, y=`M/E`))+geom_point()
members

####
#Financing
library(openxlsx)
here('Data', 'ndp_formatted_datasets.xlsx')
library(purrr)

money<-map(c(1:4), function(x) read_xlsx(path=here('Data', 'ndp_formatted_datasets.xlsx'), sheet=x))
names(money)<-excel_sheets(here('Data', 'ndp_formatted_datasets.xlsx'))
names(money)

library(magrittr)
library(car)
money[[2]]
money %>% 
  extract2(2) %>% 
  filter(Item=='fed_receipted_contributions' | Item=='total_federal_expenses'|Item=='prov_receipted_revenues') %>% 
  mutate(Item=Recode(Item, "'fed_receipted_contributions'='Total Federal Contributions'; 'total_federal_expenses'='Total Federal Expenses'; 'prov_receipted_revenues'='Total Provincial Contributions'")) %>% 
  ggplot(., aes(x=Year, y=Amount, col=Item))+geom_line()+geom_point()+labs(title='NDP Federal Receipted Contributions\nAnd Federal Expenses, 1979-1990', caption='Source: Stanbury 1994, Table 6.4')+geom_smooth(method='lm', se=F)
ggsave(here('Plots', 'ndp_fed_prov_imbalance.png'), width=6, height=4)
