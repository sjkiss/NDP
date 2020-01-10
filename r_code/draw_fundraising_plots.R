source('r_code/load_ndp_money_sheets.R')
theme_set(theme_bw())
federal<-fed_prov %>% 
  filter(Item=='fed_receipted_contributions'| Item=='prov_quotas')
revenue_sharing<-office %>% 
  filter(Item=='Revenue_sharing')
direct_mail<-direct_mail %>% 
  filter(Party=='NDP')
provincial_revenue<-contributions %>% 
  filter(Item=='Provincial_revenues')
table(out$Item)
library(scales)
out %>% 
  filter(Item=='fed_receipted_contributions'| Item=='prov_quotas' | Item=='Revenue_sharing'|Item=='Provincial_revenues'|(Item=='Direct Mail'&Party=='NDP')) %>% 
  ggplot(., aes(x=Year, y=Amount, group=Item))+geom_point(aes(col=Item))+geom_line(aes(col=Item))+scale_y_continuous(labels=comma)


ggsave('Plots/prov_federal_money.png')

#Get labour share
out %>% 
  filter(Item=='Unions'|Item=='Individuals' |Item=='Revenue_sharing'|Item=='prov_quotas'|(Item=='Direct Mail'&Party=='NDP')) %>% 
  ggplot(., aes(x=Year, y=Amount, group==Item))+geom_point(aes(col=Item))+geom_line(aes(col=Item))+scale_y_continuous(labels=comma)
ggsave('Plots/union_federal_money.png')
