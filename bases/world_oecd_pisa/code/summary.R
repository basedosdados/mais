library(learningtower)
library(tidyverse)


pisa_years <- c(2000,2003,2006,2009,2012,2015,2018)

column_names <- c("year","country_id_iso_3","school_id","student_id",
                  "mother_education", "father_education", "gender",
                  "computer", "internet", 
                  "score_mathematics", "score_reading","score_science", "student_weight", 
                  "desk","room" , "dishwasher", "television",  "computer_number", "car", "book",       
                  "wealth", "economic_social_cultural_status" )

selected_columns <- c("country_id_iso_3","school_id","student_id",
                  "mother_education", "father_education", "gender",
                  "computer", "internet", 
                  "score_mathematics", "score_reading","score_science", "student_weight", 
                  "desk","room" , "dishwasher", "television",  "computer_number", "car", "book",       
                  "wealth", "economic_social_cultural_status" )

my_path <- "C:/Users/laura/bases/world_oecd_pisa/student_summary/"

for (year in pisa_years){
  dir.create(paste0(my_path,'year=',year,sep=""))
}

for (year in pisa_years){
  student_data <- load_student(year)
  colnames(student_data) <- column_names
  write.csv(student_data[, selected_columns],
            paste0(my_path,'year=',year,'/student_summary.csv',sep=""), 
            na = " ", 
            row.names = F, 
            fileEncoding = "UTF-8")
}


# SCHOOL

data(school)

column_names <- c("year","country_id_iso_3","school_id",
                  "funding_government",  "funding_fees","funding_donation",
                  "enrol_boys", "enrol_girls", "student_teacher_ratio", "public_private", 
                  "staff_shortage", "school_weight", "school_size" )

my_path <- "C:/Users/laura/OneDrive/Documents/BasedeDados/world_oecd_pisa/school_summary/"

colnames(school) <- column_names
write.csv(school,
          paste0(my_path,'school_summary.csv',sep=""), 
          na = " ", 
          row.names = F, 
          fileEncoding = "UTF-8")
