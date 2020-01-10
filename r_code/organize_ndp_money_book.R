#Get data
library(tidyverse)
library(readxl)
library(here)
#Get Revenues
contributions<-read_excel(here('Data', 'NDP_money_workbook.xlsx'), sheet='contributions')
revenue %>% 
  gather(Item, Amount, -Year) ->contributions
revenue
#Get direct mail
direct_mail<-read_excel(here('Data', 'NDP_money_workbook.xlsx'), sheet='direct_mail')
direct_mail %>% 
  mutate(Item=rep('Direct Mail', nrow(.))) %>% 
  select(-total_revenue) %>% 
  rename(., Amount=direct_mail)-> direct_mail
direct_mail
direct_mail$Amount<-direct_mail$Amount*1000
# direct_mail$Year
# direct_mail$Year<-paste(direct_mail$Year, '-01-01', sep='')
# direct_mail$Year<-as.Date(direct_mail$Year)
# direct_mail$direct_mail<-direct_mail$direct_mail*1000
# direct_mail$total_revenue<-direct_mail$total_revenue*1000
# data.frame(direct_mail)
#

#federal receiptable contributions
fed_receipted_contributions<-read_excel(here('Data', 'NDP_money_workbook.xlsx'), sheet='fed_receipt_revenues_fed_expens')
head(fed_receipted_contributions)

fed_receipted_contributions %>% 
  gather(Item, Amount, -Year) %>% 
  mutate(Amount=Amount*1000)->fed_receipted_contributions
fed_receipted_contributions

#get Federal Office Revenue_expenditures
federal_office_revenue_expenditure<-read_excel(here('Data', 'NDP_money_workbook.xlsx'), sheet='federal_office_revenue_exp')
head(federal_office_revenue_expenditure)
federal_office_revenue_expenditure %>% 
  gather(Variable, Amount, -Year) %>% 
  separate(Variable,into=c('Category', 'Item'), sep=':' ) ->federal_office_revenue_expenditure
federal_office_revenue_expenditure

federal_office_revenue_expenditure$Year<-paste(federal_office_revenue_expenditure$Year,'-01-01', sep='')
federal_office_revenue_expenditure$Year<-as.Date(federal_office_revenue_expenditure$Year)
l<-list("Direct Mail"=direct_mail, "Fed_Receipted_Cont"=fed_receipted_contributions, "Fed_Off_Rev_Exp"=federal_office_revenue_expenditure,"Contributions"=contributions)
federal_office_revenue_expenditure
l
library(openxlsx)
write.xlsx(l, file = here('Data', 'ndp_formatted_datasets.xlsx'))


