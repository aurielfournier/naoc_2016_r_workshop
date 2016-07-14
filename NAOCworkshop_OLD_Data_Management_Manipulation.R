# Data Cleaning, Management and Manipulation

# If you talk to people who hate R chances are (if they have used R) the reason they hate it has nothing to do with R, and EVERYTHING to do with data management. R is not excel, it will never be excel, and for that we can all be grateful. But if the only way you have ever interacted with data is through excel obviously R is a totally different ballgame. 

# One of the big complaints I hear is 'R doesn't read excel files'

# First - this is not true

library(readxl)

dat <- read_excel("my_ebird_data.xlsx", sheet=1, col_names=TRUE)

# Second - if you have your data in a CLEAN AND MANAGED FORM you can save your excel file as a txt or csv or tsv and EASILY import it into R. This is often the better option. 

dat <- read.csv("my_ebird_data_na.csv",  stringsAsFactors = FALSE)

# Third - people like to hate on R (just like I love to love on R). The key is to find a system that works with you, not against you, and will idiot proof your life as much as possible. 

# There are many things you can do AS YOU ENTER _and_ PROOF your data to make your life easier (EVEN IF YOU DONT USE R). Ideally you will do all your data analysis of one dataset _without_ splitting the dataset up into little pieces

### tips for getting data into R without wanting to destroy things
# NO SPACES _especially in column headers_
# do not start column headers with numbers
# keep EVERYTHING LOWER CASE unless you have a really good reason
# you CAN use underscores "_" or periods "." or RunThingsTogether, just no spaces please or tabs

# - COMMENT YOUR CODE - your most important collaborator is yourself six months ago, so leave yourself good notes, seriously. do it. You can't send yourself six months ago an email. You and anyone who uses your data/code later on with thank you. 

### Data Cleaning in R

# Read your data into R
# Sometimes this is an entire excercise in and of itself if you have ever been given a dataset that is spread across X number of spreadsheets
# If you can get all the spreadsheets into R, you can script your process of hooking them together. 
# First you want to clean each one individually and then use some of the techniques below to stitch them together into one big file

# Look at the structure, make sure R read things in the way you think (numbers are numbers especially)
# Chances are if R read something in 'wrong' then there is somethign funky in your data (like some letters in a numeric column)
# Now look for impossible and improbable data. Often the easiest way to do this is the summary() function and check the max/min and see if either is impossible or improbable. Deal with those accordingly. 
# This is more difficult for factors, the unique() function can be helpful for you to visually assess if you have any _slightly different_ factors (mingoNWR vs MingoNWR) and you can edit accordingly
# All of these changes should be made in R, and should be scripted, and written out to a new clean file

# DO NOT CHANGE THE RAW DATA
# Save your scripts for data cleaning/data manipulation and if you remove any part of the data make comments within the script explaining why so that future you can remember, future you is an idiot, comment accordingly 

library(tidyr)
library(dplyr)
library(ggplot2)
library(gapminder)

# DPLYR

### pipes

# Often when doing data management you want to do a series of things to a data frame, without having each thing you do assigned to a new, or constantly over writing object. One way you can do this is with pipes %>% which are part of the tidyr and dplyr packages. So you can load either package to get pipes. 

# %>% pipes let you string together multiple functions by taking the output from the last function and making it the first argument of the next one.

# This prevents you from having to rewrite over your previous object and/or keeps you from creating tons of intermediate objects that you then have to keep track of. You will have to load the dplyr package to use pipes

data(gapminder) # this is an example dataset we will be using

gapminder

# this is also super helpful for looking at the top of a file

head(gapminder)

gdat %>% head

gdat %>% nrow


################################################
myebird<-read.csv('my_ebird_data.csv', stringsAsFactors = FALSE)

# now this data set has a lot going on, it has a lot of superfulous data, mix of data (x and numbers)
str(myebird)

####a For our purposes today we are going to consider "Xs" 1s, which may or may not be appropriate depending on what you are doing. But for today, we'll do it. 

myebird <- myebird %>% 
            mutate(count = replace(count, count=='X',1), # changes X's to 1s
                   count = as.numeric(count)) # makes the column numeric now that the X's are gone

str(myebird)

##lets do some quick cleaning, I do not want all these columns
colnames(myebird)

myebird<- myebird %>% 
            select(-scientificname,-taxonomicorder,-allobsreported,-numberofobservers,-breedingcode,-speciescomments,-checklistcomments)

#### now lets further fix some of this, for some future analysis
# For example I am interested in my life list, this data set doesn't explicitly state anything about my life birds. So let's make a life list.

#########dates and times#############################

# We're first going to need to tackle dates. R can handle dates, and it can be quite powerful, but a bit annoying.
# The base functions for this are as.Date, as.POSIXct, as.POSIXlt
# The syntax for these is essentially the same, feed it a date, and tell it the format

Sys.time()

## Good Resource on what letters = what in format
# https://stat.ethz.ch/R-manual/R-devel/library/base/html/strptime.html

dt<-as.Date(Sys.time(),format='%Y-%m-%d')
ct<-as.POSIXct(Sys.time(),format='%Y-%m-%d %H%M%D')
lt<-as.POSIXlt(Sys.time(),format='%Y-%m-%d %H%M%D')

# whats great is we can now do math on time

dt-10   ##since day is the lowest measurement it counts in days
ct-10   ##however counts in seconds
lt-10   ##does the same thing

# as.POSIXlt is really useful because it allows you to call particular pieces of the time out
lt$yday   ##julian date
lt$hour   ##hour
lt$year   ##what.....time since 1900???
lt$year+1900  ##converts you to standard time

##these are particularly useful because you can do math on time
earlytime<-as.POSIXct('2015-03-23',format='%Y-%m-%d')

ct - earlytime 

##as well as logical statements
ct > earlytime
ct == earlytime

# which can be really useful when you have time stamps in your file name and you need to choose the right time
 
# We want to make a data set that creates a life list and tells me when, where, and what bird each life bird was lets start by creating a true date time column. That way we basically know to the hour when we first saw a bird
 
# first we have to fudge a bit and say if there isn't an hour we'll assume it was noon

new <- myebird %>%
              mutate(time = replace(time, nchar(time)==0, '12:00 PM'),
                     timez = as.POSIXct(paste(date, time),format="%m/%d/%Y %I:%M %p")) %>%
              group_by(commonname) %>%
              arrange(timez) %>%
              slice(1) %>%
              ungroup() %>%
              arrange(timez) %>%
              mutate(lifebird = 1:n())

ggplot(new,aes(timez,lifebird)) + geom_line()
 
################################
# Effort correction
################################

# before we go comparing counts for a given species we need to think about the effort that went into creaeting those numbers
# 
# the simplest way to account for this is to correct for the number of kilometers covered (there are other ways, but for today, we'll tackle this way).


myebird <- myebird %>% 
              mutate(effortcount = count + distancetraveledkm)

summary(myebird$effortcount)

# ok, so this is all good and fine, but we have a lot of NAs which aren't very informative. 
# how do we subset our data to get rid of these NA's and their corresponding data? 

myebird <- myebird %>% 
              filter(!is.na(effortcount))

summary(myebird$effortcount)

# tadah! NAs are gone. 
 


data(gapminder)

colnames(gapminder) <- tolower(colnames(gapminder))

# Do not edit your raw data file. When doing initial management and cleaning you will likely create a new cleaned and ready to go file. Then when you go to do analysis you will work from this new clean file. There is no reason to break up this new data into lots of smaller data files. When you go to do some analysis read in the clean file, and subset it within R to do what you need to do. We've already talked about subsetting, use those skills to subset your data within R to accomplish your tasks, do not create a bajillion csv files. 

# ### Wide vs Long Data
 
# People often like to look at data in long format, but R likes data in long format. Luckily its fairly easy in R to move between the two. 
 
# Wide format is where each unit (lets say a vegetation point) is a row, and each column is a variable (site, date, water depth, etc, etc)
 
# (examples of wide data, since gapminder is already in long format)

gapminder %>% select(-pop,-gdppercap) %>% spread(year, lifeexp) %>% head()
gapminder %>% select(-lifeexp, -gdppercap) %>% spread(year, pop) %>% head()
gapminder %>% select(-pop, -lifeexp) %>% spread(year, gdppercap) %>% head()

# Long format has an identification column (vegetation point id #) and two other columns, 
# variable (the name of the variable "water depth, site, etc") and one for value 
# (the value for that vegetation point and that variable)
# 
# The advantage of long format data is it is easier to summarize and reform into 
# graphs, tables, and to perform analysis. 

gapminder %>% gather("variable","value", -country) %>% head

## first argument = the name of the variable column, can be anything
## second argument = the name of the value column, can be anything
## third argument = the columns you want to be gathered. The columns you do not list will be used as your ID columns

###########################
### Data management and manipulation 
############################

# Creating an arbitary id variable to split back out. 
# This could be anything, a date, a site name and point number, really anything

gdat <- gapminder %>% mutate(id=paste("A", 1:n(),sep="_"))

gdat %>%  gather(id) %>% head

### seperate

# I realize this is an arbitary id value that we are trying to seperate 
# but this is super useful for lots of things

# how to split based on some kind of seperation character
gdat %>% gather(id) %>% separate(id, into=c("letter","number"),sep="_") %>% head
# how to split based on the number of digits, can be one number or multiple 
gdat %>% gather(id) %>% separate(id, into=c("letter","line","num"), sep=c(1,2))  %>% head

# if you have a seperation character that you are willing to loose then using sep = "character" is the way to go, but that is not always the case

#########################
### merging/joining data frames
#########################

# THIS IS SUPER POWERFUL (dplyr)

## merging with different columns

# ok lets create some silly data that we want to merge with our gdat dataset

newdat <- data.frame(country = unique(gdat$country)[1:135], number=seq(1,135), by=1 , other="thinghere", new="otherthinghere")

newdat %>% head

newdat %>% nrow

## keeps everything from both gdat and newdat

gdat %>% full_join(newdat, by="country") %>% head

gdat %>% full_join(newdat, by="country") %>% nrow

## keeps the rows of the left dataframe and adds those that match from the right

gdat %>% left_join(newdat, by="country") %>% head

gdat %>% left_join(newdat, by="country") %>% nrow

# keeps the rows of the right data frame and adds those that match from the left

gdat %>% right_join(newdat, by="country") %>% head

gdat %>% right_join(newdat, by="country") %>% nrow



## merging with the same columns

gdat1 <- gdat[1:1000,]
gdat2 <- gdat[999:1704,]

# rows that appear in both y and z

gdat1 %>% intersect(gdat2) %>% nrow()

# rows that appear in either y and/or z

gdat1 %>% union(gdat2) %>% nrow()

# rows that appear in y but not z

gdat1 %>% setdiff(gdat2) %>% nrow()

## summarising data

# one of the big ways that we want to manipulate our data is to create tables  so that we can look at our data in different ways. 
# There are ways of creating publication ready tables in R, we're not going to cover them today, as they also involve Latex, and that is another day (atleast) to itself


mean <- gdat %>% 
          group_by(country) %>% 
              select(lifeexp, pop, gdppercap) %>% 
                  summarise_each(funs(mean)) 

mean

median <- gdat %>% 
              group_by(country) %>% 
                select(lifeexp, pop, gdppercap) %>% 
                    summarise_each(funs(median)) 

median

sd <- gdat %>% 
            group_by(country) %>% 
              select(lifeexp,pop, gdppercap) %>% 
                  summarise_each(funs(sd)) 

sd

n <- gdat %>% 
        group_by(country) %>% 
            select(4:6) %>% # you can also call columns by number
              summarise_each(funs(length))

n

se <- sd[,2:4] / sqrt(n[,2:4])

se <- cbind("country"=sd[,1], se)

se %>% head
