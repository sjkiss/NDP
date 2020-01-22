library(cansim)
library(tidyverse)
library(car)
library(here)
#comment out if you are not simon iss
#options(cansim.cache_path="~/skiss/cansim")

get_cansim_table_overview('14-10-0020-01') 
#Get Table
education_employment<-get_cansim('14-10-0020-01') 
#Glimpse
glimpse(education_employment)

#Create a master data framne with some basic variable renames for ease and filter out all other than employment rate and 2019
education_employment %>% 
  rename(., "Year"="REF_DATE", "Degree"="Educational attainment",  "LFS"="Labour force characteristics", "Age"="Age group") %>% 
  filter(.,Year==2019, LFS=="Employment")-> education_employment
education_employment %>% 
  View()
table(education_employment$LFS)
glimpse(education_employment)
#Find employment rate for level of degree attainment. 
education_employment %>% 
filter(Degree!="Total, all education levels", Degree!="Bachelor's degree", Degree!="Above bachelor\'s degree", LFS=="Employment", Sex=="Both sexes", GEO=='Canada', Age=="15 years and over") %>% 
  select(Degree, LFS,VALUE) %>% 
  write.csv(file=here("Precarity", "Data", "education_employment.csv"))

#EMPLOYMENT BY PROVINCE
education_employment %>% 
  filter(GEO!="Canada", Sex=="Both sexes", Age=="15 years and over", Degree=="Total, all education levels") %>% 
  select(GEO, Sex, Age, Degree, VALUE, Year, LFS) %>% 
write.csv(file=here("Precarity", "Data", "province_employment.csv"))

#employment by sex
education_employment %>% 
  filter(GEO=="Canada", Sex!="Both sexes", Age=="15 years and over", Degree=="Total, all education levels") %>% 
  select(GEO, Sex, Age, Degree, VALUE, Year, LFS) %>% 
  write.csv(file=here("Precarity", "Data", "sex_employment.csv"))

#EMPLOYMENT BY AGE
education_employment %>% 
  filter(GEO=="Canada", Sex=="Both sexes", Degree=="Total, all education levels",Age!="15 years and over", Age!="25 years and over", Age!="45 years and over", Age!="55 years and over") %>% 
  write.csv(file=here("Precarity", "Data", "age_employment.csv"))
