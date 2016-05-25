###Introduction and refreshers for R
# by - Matt Boone (2015) & Auriel Fournier (2015)
# Modified by Auriel Fournier for 2016 Biometry Course U of A


####################################
library(gapminder)
library(dplyr)
library(ggplot2)

#################
### What is R?
#################

# R is a language developed from the S programming language. It is a under GNU general public licensing
# It is written in mainly in C and fortran
# The creator of R has said he hopes to teach scientists to program
#

##############
#
# list a collection of various data structures. It's like a tacklebox. You can carry the tacklebox 
# together, but its compartmentalized. 
#
list1<-list(id=1:10,matr=matrix(1:100,nrow=10,ncol=10),df=data.frame(id=1:10,name=rep(c('a','b'),10)))

str(list1[[2]])  ##when you refer to it like this its output is a dataframe
str(list1[2])  ## when you call it with this it returns a list

list1$id   ##but you can still call them with the $
 
###the majority of work is done with data frames and lists. Lists are useful because they're not stored in RAM the same way data.frames are. Dataframes are stored as one big memory piece and everytime you need to append it
# it must allocate RAM for the large block, which can eventually lead to whats called a memory leak.
# This is one of the reasons we use lists. Think of lists as giant storage boxes. You can pull from lists as needed
# and do whats necessary. They're endlessly deep though, so you can easily get lost if you start building lists inside of lists. They're great for storing multiple files, and keeping things organized
list1[[3]][1,1]  #refers to the 1st row, 1st column, of the 3rd object in list1.

###############################################################
# common phrases in r
# symbols
# - symbol can subtract in my different ways


###subsetting
# one of the big tasks in R is subsetting. Once you can subset properly you can slice your data either for analysis
# or processing and transforming data
# This becomes one of the more complicated tasks in R, as large subsetting can get confusing.
# There's three ways to subset, base subset, subset function, and dplyr.
# base subsetting is more or less the base of the other two functions.
# We'll first go into subset(). This function is simple and it does a very simple thing
library(gapminder)
data(gapminder)
head(gapminder)   

# say we want to look at the life expectancy of just European countries in 1987, and we only 
# want to look at life Exp and gdpPercap
test<- gapminder %>%
        filter(continent=='Europe',
               year==1987) %>% 
        select(country,lifeExp,gdpPercap)
head(test)

# that easy, it does exactly what we want, it's fairly logical
# say you want to take out rows
test<- gapminder %>%
          filter(continent=='Europe', 
                 year==1987) %>% 
          select(-continent, -pop)  ## remember - means subtract
test

##The syntax to base subset works very similar to this. It's basically set on the premises of feeding the dataframe
# a string of T, F where T is a variable it wants to keep, and F is one its going to ignore. But
# this process can be complicated to imagine


##############
# & (means to evalute the T F together)

gapminder %>%
      filter(continent=="Europe"|continent=="Asia") # | means 'or' its the key above enter

gapminder %>%
      filter(continent=="Europe"|continent=="Asia",
             year==1987)

test <- gapminder %>%
          filter(continent=="Europe"|continent=="Asia",
                 year==1987) %>%
          select(country, lifeExp, gdpPercap)




###########
# Match
# %in%   #the original match() function was rewritten to %in%

#find all the variables in 'this' that are also in 'that'
this<-c("a","b","c","d")
that<-c("d","e")

this %in% that  ### should be read as, find all the moments where THIS is equal to THAT. It returns T/F of where this 1:10 equals 1 or 2. If we feed this back into our vector THIS it shows us the numbers themselves

this[this %in% that]   

that %in% this

that[that %in% this]  ###we can do it the other way around, and it shows us the same two numbers ofcourse. It is where the two vectors have in common
# %in% is essentially the same as stringing a bunch of 'or' statements together. In this case we are saying:

#dplyr does this with the function intersect, however this doesnt give us T/F it only shows us the values they have in common
intersect(this,that)

#which can be used to show us at what location the two are common
which(this %in% that)    

#############################
#grouping
#############################
# Lets look at how to do analysis on grouped data in base R
# Base R grouping

data<-read.csv('rail_data.csv', stringsAsFactors = FALSE)
data

#lets subset our data into two dataframes for ease in this example. 
data1<-data %>% select(wingchord, culmen, tarsus)    #a data frame called data1
grouping<- data %>% select(genera, migratory)  #and our grouping variables called grouping

# tapply runs a function on a vector based on a set of groupings we feed it
# tapply(vector, grouping vector, function)

data %>%
  group_by(genera) %>%
  summarize(mean(wingchord))


data %>% 
  group_by(genera, migratory) %>%
  summarize_each(funs(mean))


#Simple functions
#paste
# paste strings any data classes together into one long character string, each seperated by a space

name<-'Matt'
paste('Hello, world. My name is',name )    # pastes the phrase, 'hellow world my name is', with our object name, which we stored as Matt

version<-2.1

# this is useful for error messages
paste0(name,'_',version,' was not found')
paste0(name,'_',version,' was not found, please try ', version-1 )  # notice we can still do math on things. R evaluates from the inside of a function outward.
#its also useful to add numbers to the end, it will also recycle as necessary
paste0(name,1:10) 

###################
# apply functions
# an apply function is a prewrapped function that loops across data sets. Which makes no sense ofcourse
# You can think of apply functions as R's replacement for excels core functionality and pivot tables

data<-data.frame(matrix(1:100, nrow=10,ncol=10))
data
#apply does some function across the rows or columns of a data set


apply(data,1,mean)  #1 tells it to run a function across the rows
apply(data,2,mean)  #2 tells it to run a function down the columns
data



data/apply(data,1,sum)   # we can then feed these values back to our dataframe to calculate proportions for example
apply(data/apply(data,1,sum),1,sum)  ##proof that it calculated the proportion (these values would not equal 1 otherwise)

#now lets check out doing this doing the columns
test<-data/apply(data,2,sum)
apply(test,2,sum)   ## this didnt work, why?

#it didnt work because R runs the multiply or divide function across each column, but we wanted down the rows

#transposing, flips dataframes on their diagonal, so rows beecome columns and column become rows
t(data)
test<-t(t(data)/apply(data,2,sum))   # is sadly how we would actually do this, flipping it, doing the math, then flipping it back
apply(test,2,sum)

apply(data,1,prop.table)   #is ofcourse how you actually do this


####################
#grepl searches for an entry in a vector
grep('United',gapminder$country)   #this searches for the term 'United' in each word in our country vector
gapminder[grep('United',gapminder$country),]    # we can feed this back to our data frame to see all countries that contain the word United (case sensitive)

# adding the ^ tells R to search were the character string STARTS with something
grep('^Af',gapminder$country)   #searches for countries that START with Af

grepl('^Af',gapminder$country)    # tells us the T/F version of this

gapminder[grepl('^Af',gapminder$country),]
##compared to
gapminder[grepl('Af',gapminder$country),]
# It's the base R way of searching and doing character matching, it will be extremely useful
# in the future when we start trying to make things flexible and reproducible. Google regExpr to 
# get other complex character searches we can do

