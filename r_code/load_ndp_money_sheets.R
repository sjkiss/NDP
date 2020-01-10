#Load libraryies
library(tidyverse)
library(readxl)
#load formatted NDP datasheet
direct_mail<-read_excel('Data/ndp_formatted_datasets.xlsx', sheet=1)
fed_prov<-read_excel('Data/ndp_formatted_datasets.xlsx', sheet=2)
office<-read_excel('Data/ndp_formatted_datasets.xlsx', sheet=3)
contributions<-read_excel('Data/ndp_formatted_datasets.xlsx', sheet=4)
head(direct_mail)
head(fed_prov)
head(office)
head(contributions)
out<-full_join(direct_mail, fed_prov)
out<-full_join(out, office)
out<-full_join(out, contributions)




