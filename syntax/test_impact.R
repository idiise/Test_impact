
# import package ----------------------------------------------------------

library(tidyverse)
library(writexl)


# data processing ---------------------------------------------------------

dataset <- read.csv("C:/Users/USER MSI/Documents/R Project/Test_impact/Data/Annex  1 - REACH Assessment Test Database_DataAnalyst_v2.csv")

no_source <- dataset %>% filter(is.na(drinking_water_source))
test <- dataset %>% cross_cpct(Marital.status...Head.of.Household, single_headed_household)
dataset <- dataset %>% mutate(
  total_calculated = Number.household.member.boy.under5.years.old +
    Number.household.member._girl_under5.years.old + 
    Number.household.member.boy_5_17.years.old +
    number.adult.household.members.years.old +
    household_girl_5_17
)

dataset <- dataset %>% mutate(
  total_check = case_when(
    total_calculated == Total.household.number ~ "ok",
    TRUE ~ "not ok"
  )
)

total_different <- dataset %>% filter(
  total_check == "not ok"
)

write_xlsx(total_different, "Data/total_different.xlsx")
write_xlsx(no_source, "Data/no_source.xlsx")

check_improve <- dataset %>% cross_rpct(single_headed_household, list(data_collection_round %nest%  drinking_water_source_categorization))
write_xlsx(check_improve, "Data/check_improve.xlsx")

baseline_imp <- dataset %>% cross_rpct(data_collection_round, drinking_water_source_categorization)


check_improve_diarrhea <- dataset %>% cross_rpct(diarrhea_under_5, list(data_collection_round %nest%  drinking_water_source_categorization))

write_xlsx(check_improve_diarrhea, "Data/check_improve_diarrhea.xlsx")
