####Final project, HAP-780 SUMMER, Xiaoqing Liu
getwd() 
setwd('/Users/amber/Documents/HAP-780/finalproject')
library(tidyverse)
library(tidymodels)
library(gridExtra)

#1. read csv
AMI_df <- read.csv("AMIdf.csv", header=TRUE, sep=",")
sum(is.na(AMI_df))
str(AMI_df)
summary(AMI_df)

#2. data type transformation
####drop subject_id and hadm_id
AMI_df <- AMI_df[, -c(1,2)]
####number to nominal
AMI_df$status <-  factor(AMI_df$status)

#2. explore dataset
#2.1 dependent variable
##statistics for dependent variable
p_dependent <- AMI_df %>%
  group_by(status) %>%
  summarise(n_patient = n(),
            prop = n_patient / 9703)
p_dependent
##plot for depedent variable
theme_set(theme_bw())
p_status <- ggplot(AMI_df, aes(x=status, fill=status)) +
  geom_bar(width=0.8) +
  labs(x="Status of Patients",
       y="Count",
       title="Distribution of Patients Status in 90 Days") +
  scale_fill_discrete(labels=c('alive', 'dead'))
p_status
###Conclusion: this is an unbalanced dataset. 
###20% patients were dead and 80% were alive in 90 days after diagnosed with AMI

#2.2 age and gender
##statistics for age
tab_age <- AMI_df %>%
        group_by(status) %>%
        summarise(n_patient = n(),
                  avg_age = mean(age),
                  min_age = min(age),
                  max_age = max(age),
                  sd_age = sd(age))
tab_age
##statistics for gender
tab_gender <- AMI_df %>%
  group_by(status, gender) %>%
  summarise(n_patient = n()) %>%
      ungroup() %>%
      group_by(status) %>%
      mutate(gender_prop = n_patient / sum(n_patient))
tab_gender
##density plot for gender and age
p_age_gender <- ggplot(AMI_df, aes(x=age, fill=status)) +
  geom_density(color='white', alpha=0.5) +
  labs(x="Age of Patients",
       title="Density Plot for Ages of Patients by gender and Status") +
  facet_wrap(~gender, nrow=2) +
  scale_fill_discrete(labels=c('alive', 'dead'))
p_age_gender

#2.3 marital
##statistics for marital status
tab_marital <- AMI_df %>%
  group_by(marital_status) %>%
  summarise(n_patient = n(),
            distribution_patient = n() / nrow(AMI_df),
            mortality = sum(status == 1) / n_patient)
tab_marital
##plot for marital status
p_marital <- ggplot(AMI_df, aes(x=marital_status, fill=status)) +
      geom_bar(position = 'fill') +
      labs(x="Marital Status",
           title="Distribution for Marital Status of Patients") +
      scale_fill_discrete(labels=c('alive', 'dead'))
p_marital              
###conclusion: patients who were widowed and did not provide marital status 
###need to be cared

#2.4 race
##statistics for race
tab_race <- AMI_df %>%
  group_by(race) %>%
  summarise(n_patient = n(),
            distribution_patient = n() / nrow(AMI_df),
            mortality = sum(status == 1) / n_patient)
tab_race
##plot for race
p_race <- ggplot(AMI_df, aes(x=race, fill=status)) +
  geom_bar(position = 'fill') +
  labs(x="Race",
       title="Distribution in Races of Patients by Status") +
  scale_fill_discrete(labels=c('alive', 'dead'))
p_race 
###conclusion: no specific evident that race affect the mortality for that some 
###races have too few patients to make a conclusion

#AMIhistory_count
p_AMIhistory_count <- ggplot(AMI_df, aes(x=AMIhistory_count, fill=status)) +
  geom_density(color='white', alpha=0.5) +
  labs(x="Race",
       title="Distribution in Races of Patients by Status") +
  scale_fill_discrete(labels=c('alive', 'dead'))
p_AMIhistory_count 
###Conclusion: there is no obvious evidence that patient with AMI history will
###have higher 90 day mortality when getting AMI again

#2.5 comorbidity
##covert int to character
cols <- c("congestive_heart_failure", "peripheral_vascular_disease", 
          "cerebrovascular_disease", "dementia", "chronic_pulmonary_disease","rheumatic_disease",
          "peptic_ulcer_disease", "mild_liver_disease", "diabetes_without_cc", "diabetes_with_cc",
          "paraplegia", "renal_disease", "malignant_cancer", "severe_liver_disease", "metastatic_solid_tumor",
          "aids")
AMI_df <- AMI_df %>%
  mutate_at(vars(all_of(cols)), as.character)
##construct table for comorbidities
comorbidity <- AMI_df %>%
  group_by(status) %>%
  summarise(congestive_heart_failure = sum(congestive_heart_failure == '1'),
            peripheral_vascular = sum(peripheral_vascular_disease == '1'),
            cerebrovascular = sum(cerebrovascular_disease == '1'),
            dementia = sum(dementia == '1'),
            chronic_pulmonary = sum(chronic_pulmonary_disease == '1'),
            rheumatic = sum(rheumatic_disease == '1'),
            peptic_ulcer = sum(peptic_ulcer_disease == '1'),
            mild_liver_disease = sum(mild_liver_disease == '1'),
            diabetes_without_cc = sum(diabetes_without_cc == '1'),
            diabetes_with_cc = sum(diabetes_with_cc == '1'),
            paraplegia = sum(paraplegia == '1'),
            renal_disease = sum(renal_disease == '1'),
            malignant_cancer = sum(malignant_cancer == '1'),
            severe_liver_disease = sum(severe_liver_disease == '1'),
            metastatic_solid_tumor = sum(metastatic_solid_tumor == '1'),
            aids = sum(aids == '1'))
comorbidity
##transpose table
comorbidity_t <- data.frame(t(comorbidity))
colnames(comorbidity_t) <- comorbidity_t[1, ] 
comorbidity_t <- comorbidity_t[-1, ]
comorbidity_t$comorbidity <- rownames(comorbidity_t)
rownames(comorbidity_t) <- NULL
comorbidity_new <- comorbidity_t[c('comorbidity', '0', '1')]
comorbidity_new <- comorbidity_new %>%
  mutate_at(c('0', '1'), as.integer)
##statistics for comorbidity
tab_com <- comorbidity_new %>%
  mutate(total_patient = `0` + `1`,
         incidence = round(total_patient*100 / 9703, 2),
         mortality = round(`1`*100 / total_patient, 2))
tab_com
##plot for comorbidity-patient numbers
p_comorbidity <- ggplot(tab_com, aes(x = reorder(comorbidity, total_patient), y = total_patient)) +
  geom_bar(stat = "identity",fill = 'darkblue', color='white') +
  labs(title = "Comorbidity in AMI Patients",
       y = "Count",
       x = 'comorbidity') +
  facet_wrap(~ "Patient Numbers", ncol = 1) +
  coord_flip()
##plot for comorbidity-mortality
p_mortality_c <- ggplot(tab_com, aes(x = reorder(comorbidity, mortality), y = mortality)) +
  geom_bar(stat = "identity", fill = 'darkred', color='white') +
  labs(y = "Percentage",
       x = 'comorbidity') +
  facet_wrap(~ "Mortality", ncol = 1) +
  coord_flip()
##Arrange the plots side by side
grid.arrange(p_comorbidity, p_mortality_c, ncol = 1)

#2.6 clinical indicators from labevents and chartevents
##create a function to return the statistics tables for clinical indicators
calculate_statistics <- function(data, variable) {
  result <- data %>%
    group_by(status) %>%
    summarise(avg = mean(.data[[variable]]),
              min = min(.data[[variable]]),
              max = max(.data[[variable]]),
              sd = sd(.data[[variable]]),
              median = median(.data[[variable]])) 
  return(result)
}
##collect the variables column names
variable_collection <- list("heart_rate", "sbp", "dbp", "mbp", "resp_rate", 
                          "temperature" ,"spo2", "troponin_t", "ck_mb", "aniongap", 
                          "bicarbonate", "bun", "calcium", "chloride", "creatinine", 
                          "glucose", "sodium", "potassium")
##statistics tables
result_list <- list()
for (i in variable_collection) {
  result_list[[i]] <- calculate_statistics(AMI_df, i)
}
result_list

#2.7 admission_type
##statistics for admission type
tab_type <- AMI_df %>% 
  group_by(admission_type) %>%
  summarise(n_patient = n(),
            mortality = sum(status == 1) / n_patient)
tab_type
##plot for admission type
p_type <- ggplot(AMI_df, aes(x=admission_type, fill=status)) +
  geom_bar()
p_type
###Conclusion: Patients with emergency have higher mortality






