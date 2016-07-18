###Introduction and refreshers for R
# by - Matt Boone (2015) & Auriel Fournier (2015)
# Modified by Auriel Fournier for 2016 Biometry Course U of A


####################################
library(gapminder)
library(dplyr)
library(ggplot2)

###################
## Loading In The Data
####################

data(gapminder)
head(gapminder)   


#########################
## Filtering
#########################

test<- gapminder %>%
        filter(continent=='Europe',
               year==1987) 
summary(test)


test<- gapminder %>%
  filter(continent=='Europe',
         year==1987) %>% 
        select(country,lifeExp,gdpPercap)
summary(test)

# the "|" means 'or' in R
test <- gapminder %>%
      filter(continent=="Europe"|continent=="Asia") 

# the "&" means "and" in R
test <- gapminder %>%
          filter(year>=1987&year<=2002) 
summary(test)

#########################
# Match
# %in%   
#########################

sub_countries <- c("Afghanistan","Australia", "Zambia")


test <- gapminder %>%
          filter(country %in% sub_countries)

#########################
## GROUPING
#########################

gapminder %>%
  group_by(continent) %>%
  summarize(mean=mean(lifeExp))


gapminder %>% 
  group_by(continent, year) %>%
  summarize(mean=mean(lifeExp))


#########################################
## CHALLENGE
#########################################

# What is the median life expenctancy and population for each country in Asia in 1988



#########################
## MUTATE
#########################





########################
## Separate
########################

########################
## Joins
########################



#####################################
## CHALLENGE
#####################################

# Calculate the average life expectancy in 2002 of 2 randomly selected countries for each continent. Then arrange the continent names in reverse order. Hint: Use the dplyr functions arrange() and sample_n(), they have similar syntax to other dplyr functions.



########################
## Dates and Times
########################

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


#########################
## Paste Functions
#########################

# paste strings any data classes together into one long character string, each seperated by a space

name<-'Auriel'
paste('Hello, world. My name is',name )   

# this is useful for error messages
paste0(name,'_',Sys.Date())

paste0(name,'_',Sys.Date(),'_',1:10) 

####################
#grepl searches for an entry in a vector
grepl('Af',gapminder$country)   

#this searches for the term 'United' in each word in our country vector

test <- gapminder %>%
    filter(grepl('Af',gapminder$country))
summary(test)

test <- gapminder %>%
  filter(grepl('^Af',gapminder$country))
summary(test)

#####################################
## CHALLENGE
#####################################

## Median and Mean Life Exp for all Countiries that being with "Ma" for the years 1990-1997 


