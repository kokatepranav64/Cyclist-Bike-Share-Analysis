#install and load packages to wrangle data and date attributes
install.packages("tidyverse") # Helps to wrangle data
library(tidyverse)
library(lubridate) #Helps wrangle date attribues
install.packages("here")
library(here)
# insall and load packages to simplify data cleaning tasks and functions for cleaning data
install.packages("skimr")
install.packages("janitor")
library(skimr) #Helps to simplifying data cleaning tasks
library(janitor) #Gives funcions for cleaning data
library(dplyr)
library(readr)
#now all important packages are installed and loaded.Now lets move towards further steps for analysis.
###################################################################################

#Step 1 
# import data 

apr_2021 <- read_csv('202104-divvy-tripdata.csv')
may_2021 <- read_csv('202105-divvy-tripdata.csv')
june_2021<- read_csv('202106-divvy-tripdata.csv')
july_2021<- read_csv('202107-divvy-tripdata.csv')
aug_2021 <- read_csv('202108-divvy-tripdata.csv')
sept_2021<- read_csv('202109-divvy-tripdata.csv')
oct_2021 <- read_csv('202110-divvy-tripdata.csv')
nov_2021 <- read_csv('202111-divvy-tripdata.csv')
dec_2021 <- read_csv('202112-divvy-tripdata.csv')
jan_2022 <- read_csv('202201-divvy-tripdata.csv')
feb_2022 <- read_csv('202202-divvy-tripdata.csv')
mar_2022 <- read_csv('202203-divvy-tripdata.csv')


#now comparing column datatypes  of all data frames with each other and checking where any of the data type is different.
compare_df_cols(apr_2021,may_2021,june_2021,july_2021,aug_2021,sept_2021,oct_2021,nov_2021,dec_2021,jan_2022,feb_2022,mar_2022, return = "mismatch")

# Step 2
# combining all 12 dataframe in one big data frame
trips <- bind_rows(apr_2021,may_2021,june_2021,july_2021,aug_2021,sept_2021,oct_2021,nov_2021,dec_2021,jan_2022,feb_2022,mar_2022)

#renaming column for Comfortable use
trips <- trips %>% rename(trip_id= ride_id , ride_type= rideable_type ,start_time= started_at ,end_time= ended_at ,from_station_name= start_station_name ,from_station_id= start_station_id ,to_station_id= end_station_id ,usertype= member_casual)

#cleaning data to preppare for analysis
colnames(trips) #checking renamed columns inorder to verify
dim(trips) # checking number of rows and columns

#firsr 6 rows of dataframe
head(trips)

checking list of column and dataypes
str(trips)

#checking data summary  and checing missing data
library(skimr)
skim(trips)
skim_without_charts(trips)


##### adding extra columns that list the date,month,day and year of eah ride
## this will help to differentiate ride data  in day, month, year and date
# before compleating this operations we wereonly able to aggregate at the ride level
library(lubridate)
trips$date  <-  as.Date(trips$start_time) # default format :-  yy-mm-dd
trips$month <-  format(as.Date(trips$date), "%m")
trips$day   <-  format(as.Date(trips$date), "%d")
trips$year  <-  format(as.Date(trips$date), "%y")
trips$day_of_week  <-  format(as.Date(trips$date), "%A")

# creating new column of ride_length to calculate time difference in sconds
trips$ride_length <- difftime(trips$end_time,trips$start_time)

skim_without_charts(trips)

#converting ride_length from factor to numeric in order to run calculation on data
is.factor(trips$ride_length)

trips$ride_length <- as.numeric(as.character(trips$ride_length))
is.numeric(trips$ride_length)

#####removing Bad Data
# after viewing the dataset the column called ride_length contains negative values
skim(trips$ride_length)
# we can see p0 = -3482
trips_1 <- trips[!(trips$ride_length<0),]
skim(trips_1$ride_length)
#  p0 = 0 now there is no negative values in ride_length column

###now saving dataframe in .csv format fro further analysis anf visualization purpose

write.csv(trips_1,"data.csv")
