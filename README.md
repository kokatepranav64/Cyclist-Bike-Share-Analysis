### Cyclist-Bike-Share-Analysis

## Case Study: Converting Casual Cyclistic Riders to Annual Members
![image](images/bike-sharing-disadvantages-810x455.jpg)

## Scenario 

You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of
marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your
team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team
will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve
your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

## About Cyclistic 

In 2016, Cyclistic launched a successful bike-sharing offering. Since then, the program has grown to a fleet of **5,824** bicycles that are geotracked and locked into a network of **692** stations across Chicago. The bikes can be unloacked from one station and returned to any other station in the system anytime. 

Until now, Cyclistic’s marketing strategy relied on building general awareness and appealing to broad consumer segments. One approach that helped make these things possible was the flexibility of its pricing plans: single-ride passes, full-day passes, and annual memberships. Customers who purchase single-ride or full-day passes are referred to as casual riders. Customers who purchase annual memberships are Cyclistic members.

## The Stakeholders 

> 1. **Lily Moreno:** The director of marketing and my manager. Moreno is responsible for the development of campaigns and initiatives to promote the bike-share program. 
> 2. **Cyclistic marketing analytics team:** A team of data analysts who are responsible for collecting, analyzing, and reporting data that helps guide Cyclistic marketing strategy. 
> 3. **Cyclistic executive team:** A notoriously detail-oriented team which will decide whether to approve the recommended marketing program.

## The Business Task

The goal of this case study is to provide clear insights for designing marketing strategies aimed at converting casual riders into annual members. Towards this goal, I asked the following questions:

> 1. How do annual members and casual riders use Cyclistic bikes differently?
> 2. Why would casual riders buy Cyclistic annual memberships?
> 3. How can Cyclistic use digital media to influence casual riders to become members? 

## Preparing the Data 

This case study uses Cyclistic's historical trip data (previous 12 months) to analyze and identify trends. The data has been made available by Motivate International Inc. under and open license. The data can be dowloaded [here.](https://divvy-tripdata.s3.amazonaws.com/index.html) 

This data is reliable, original, comprehensive and current as it is internally collected and stored safely by Cyclistic from April 2021 to March 2022. Personally identifiable information  such as credit card numbers has been removed because of data-privacy issues.

The data selected for use covers the last 12 months from April 2021 to March 2022. Each month has a separate dataset. The datasets are organized in tabular format and have 13 identical columns. Combined, the datasets have 4073561 rows. The **member_casual** column will allow me to group, aggregate and compare trends between casual riders and member riders. 

## Processing the Data from Dirty to Clean

### Tools
To process the data from dirty to clean, I chose to use **R.** This is because R is relatively fast and thus useful in dealing with huge dasets. I also Use **Tableau**
for visualization because of wide variety of selection of visualization tools.

I aslo clean, Analyze and visualize data with **MS Excel** . This is for learning and exploring purpose and For also gaining new skills.
* Here's my [link](https://drive.google.com/drive/folders/14-fBJGaoDNkunzCGN5RV2BBOxaANuIuh?usp=sharing) to chek my **Ms Excel** Project.

### Cleaning the data
First I install & load all necessary libraries cleaning and Analyzing data
```
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
```

After reading in and combining the 12 datasets into a single dataframe, the first step in data cleaning was to identify which columns and rows have missing data. I disvored that 6 out of 13 columns had missing data. Additionally, 314299 rows had missing values. 
```
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

#combining all 12 dataframe in one big data frame
trips <- bind_rows(apr_2021,may_2021,june_2021,july_2021,aug_2021,sept_2021,oct_2021,nov_2021,dec_2021,jan_2022,feb_2022,mar_2022)

#renaming column for Comfortable use
trips <- trips %>% rename(trip_id= ride_id , ride_type= rideable_type ,start_time= started_at ,end_time= ended_at ,from_station_name= start_station_name ,from_station_id= start_station_id ,to_station_id= end_station_id ,usertype= member_casual)
```

Next, I indexed into into the first and last row with missing data and disovered that they had null values on multiple columns. I also computed the percentage of rows that had missing values. This stood at 7.71%. Upon examing the columns with missing data, I decided imputation would be a wrong approach because of the nature of the missing data. 

Since rows with missing values account for a tiny percentage of our data and appear to have missing values on multiple columns, I decided to remove them. 

After dropping rows with missing data, I checked if any of the remaining observations had duplicates. None of the rows were duplicated. After this step, I was confident the data was ready for further processing and analysis. 

### Transforming the data

Next, I checked the summary of the data and discovered that the **started_at** and **ended_at** columns were strings rather than datetime. As such, I converted the columns into datetime using the pandas **to_datetime()** function.

Next, I created the **ride_length** column by getting the difference between the ended_at and started_at columns. This yielded a timedelta object which I converted to seconds then minutes. 

Additionally, I created two more columns **day_of_week** and **month_name**. These contain the day of the week and month which a bike was hired respectively. 

Upon getting the summary to ensure data was ready for analysis, I discovered that there were negative integers on the ride length column. I therefore filtered the rows with negative ride length vlaues to examine them further. A closer examination revealed the negative values were a result of the ended_at day or time being smaller that the started_at. Only 10,237 rows exhibited this phenomena and thus were promptly filtered out.
```
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


#####adding extra columns that list the date,month,day and year of eah ride
##this will help to differentiate ride data  in day, month, year and date
#before compleating this operations we wereonly able to aggregate at the ride level
library(lubridate)
trips$date  <-  as.Date(trips$start_time) # default format :-  yy-mm-dd
trips$month <-  format(as.Date(trips$date), "%m")
trips$day   <-  format(as.Date(trips$date), "%d")
trips$year  <-  format(as.Date(trips$date), "%y")
trips$day_of_week  <-  format(as.Date(trips$date), "%A")

#creating new column of ride_length to calculate time difference in sconds
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

###now saving dataframe in .csv format fro further analysis and visualization purpose

write.csv(trips_1,"data.csv")
```
Finally, I got the summary of the data and concluded the data was ready for analysis. 

## Analyze Data to Answer Questions

In this step, I analyzed the cleaned data to find out how annual members and casual riders use Cyclistic bikes differently.

First, I got the total number of bike hired and established how they were shared between casual riders and  member riders. Next, I examined how total bike hires were distributed per month and then per day. This revealed some interesting trends that I shall discuss in the **share** stage. 

Next, I examined how bike hires between the two types of rider categories compared in a given month of the year and day of the week. The goal at this point was to find out whether casual riders had a preference for certain days or months compared with member riders. 

Next, I wanted to compare the difference in average ride length between casual riders and member riders. I discovered that casual riders tend to ride for longer periods of time compared to member riders. I was intrigued and decided to explore how the average ride length compares for both rider categories on daily and monthly basis. 

Finally I compared how the type of bike hired compared between the two rider categories. 

### Data Visualization
Here are the followig Visualization  Dashbord Results created with the help of tool called Tableau :-

* Overall Dashboard Of Daily trend Analysis which contains the following Charts:-
  
  **Trip Duration Summary,Total Ride length,Daily Trend By Month,Daily Trend Analysis**
  ![daily trend analysis](images/Overall%20Dashboard.png)

* The second Dashboard named "User Type Analysis" Cotains the following charts:-
  
  **Daily Trends - Member,Daily Trends - Casual,Trend By MONTH,TREND BY TIME**
  ![user type analysis](images/User%20Type%20Analysis.png)



