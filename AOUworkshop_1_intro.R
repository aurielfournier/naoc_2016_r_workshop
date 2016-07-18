###Introduction and refreshers for R
# by - Matt Boone (2015) & Auriel Fournier (2015)
# Modified by Auriel Fournier for 2016 Biometry Course U of A


####################################
library(gapminder)
library(dplyr)
library(ggplot2)

data(gapminder)

#################
### What is R?
#################

# R is a language developed from the S programming language. It is a under GNU general public licensing
# It is written in mainly in C and fortran
# The creator of R has said he hopes to teach scientists to program
#

###############################################################################

# data classes. R as 4 major classes and then many others sprinkled throughout

str(1:10)    #numeric, containing numbers, this is data you can do math on
str(c('bob','joe','jim')) ##character these are just symbolic representations. Have no order
str(c(T,F,T,TRUE, FALSE))  ##logical statements, just T or F
  as.logical(c(1,0,1,0,0))  ##1's and 0's are also treated as logical or numeric depending on the context
str(factor(c('monday','tuesday','wednesday')))  ##factor character symbols that have an order to them

factor(c('monday','tuesday','wednesday'),levels=c('monday','wednesday','tuesday'))

############
###data types and how R trys to convert inputs
# because vectors must be of the same class, R will attempt to convert all inputs
# to the one class they have in commmon
#ex. 
1:10  ##vectors
str(c(1:10 ))   #numeric
str(c('bob','joe'))    #character
str(c('bob','joe',1))    #it converts them to characters because 1 can be converted to a character but 'bob' and 'joe' can not
################################################################################
#
#Data structures
################################################################################
# we've already talked about vectors
######
# matrix: a 2 dimensional array consistening of the same data class.
# R treats this as a continuous vector with 2 dimensions
data<-matrix(1:100,nrow=10,ncol=10)
data[50]   ###refers to the 50th entry, which is irrespective of the row. This will not work in a dataframe
data[,1]   ###you can still refer to it by rows or columns

################################################################################


#data.frames
data<-data.frame(matrix(1:100,nrow=10,ncol=10))

data<-data.frame(id=1:10,name=rep(c('a','b'),5))

head(data)
str(data)

data[,1]*10
data[,2]*10

data$id
data$name
##############
# multiplying vectors and matrices
#

data*1:10   #'pseudo' matrix multiplication. Runs 1:10 on each column.

data %*% 1:10   #matrix multiplication. This is how you do real matrix multiplication 

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
5-3
c(3,4,5)
-c(3,4,5)
5+(-3)   ###try to use parenthesis when actually using a negative
d<-3 ###This can mean either store d as the number 3, or a logical statement whether d is less than negative 3. Use parenthesis to seperate these differences
d<-(5)
d<(-3)   ##5 is not less than -3
#but it can also take out columns
list1$df[-c(3,4,5),]
#
######
# ! means not, it finds the reverse of a logical arguement
c(T,F,T)
-c(T,F,T)
!c(T,F,T)

###subsetting
# one of the big tasks in R is subsetting. Once you can subset properly you can slice your data either for analysis
# or processing and transforming data
# This becomes one of the more complicated tasks in R, as large subsetting can get confusing.
# There's three ways to subset, base subset, subset function, and dplyr.
# base subsetting is more or less the base of the other two functions.
# We'll first go into subset(). This function is simple and it does a very simple thing
datag<-gapminder
head(datag)   

# say we want to look at the life expectancy of just European countries in 1987, and we only 
# want to look at life Exp and gdpPercap
test<-subset(datag,continent=='Europe' & year==1987, select=c(country,lifeExp,gdpPercap))
head(test)

# that easy, it does exactly what we want, it's fairly logical
# say you want to take out rows
test<-subset(datag,continent=='Europe' & year==1987, select=-c(continent, pop))  ## remember - means subtract
test

##The syntax to base subset works very similar to this. It's basically set on the premises of feeding the dataframe
# a string of T, F where T is a variable it wants to keep, and F is one its going to ignore. But
# this process can be complicated to imagine

datag$continent=='Europe'    ###shows us what rows continent equals Europe
datag[datag$continent=='Europe',]    ##If we feed this string of T and F into our data frame, it only shows us the rows where continent equals Europe
datag$year==1987    ##shows us what rows year equals 1987
datag[datag$year==1987,]   

datag$continent=='Europe' & datag$year==1987   ##shows us what rows continenet equals Europe AND where year equals 1987
datag[datag$continent=='Europe' & datag$year==1987,]   ##therefore feeding this line of T and F to our data frame, gives us only rows where both of these statements are true in their respective columns
##############
# & (means to evalute the T F together)
datag[(datag$continent=='Europe' | datag$continent=='Asia') & datag$year==1987,]   ##parenthesis helps us exact our queery, in this statement we only want data where continent equals europe or asia, and from this we want all years where year equal 1987
datag[datag$continent=='Europe' | datag$continent=='Asia' & datag$year==1987,]

test<-datag[datag$continent=='Europe' & datag$year==1987,c('country','lifeExp','gdpPercap')]   ##is a different queery

##dplyr attempts to clarify complicated statements by using more logical function names
# and soemthing called pipes. Dplyr is written by a guy named
# Hadley Whickham, the author of Rstudio. Hadley Whickham has written a suite of useful packages
# all with the goal of making R easier and more accesible, these include ggplot, dplyr, tidyr.
# dplyr is a program for transforming data, and the particular function for subsetting is this 
# process called pipes. Basically you feed it a logical set of instructions to do. %>% should be read as 'then'. Dplyr comes with a bunch of new functions, and you can dig into the tutorials on our resource
# page to learn more on how each function works
# We'll go much more into dplyr in the future, but for now I want to introduce you to the concept
test<-datag %>% filter(continent=='Europe' & year==1987) %>% select(one_of('country','lifeExp','gdpPercap'))
### Should be read as: take our data set 'datag', then filter this data set where continent=Europe and Year =1987. Then take that product and select the columns coutry, lifeExp, and gdpPercap
head(test)

# I like this idea, and it has many strong functions, it's gaining popularity and we'll try to touch on various
# dplyr ways of doing thing.
# now dplyr represents a sort of left turn in R, and can be a bit like speaking two languages if you're trying to ride the line of
# using base R and live in Hadley Wickhams world. We're going to continue on trying to teach both methods
# dplyr and base R. In some ways dplyr is faster, and in other base R is easier to do complex things.
# We'll try our best to show you the base way and dplyr way to do things.
# Before we move forward we need to address this match function
###########
# Match
# %in%   #the original match() function was rewritten to %in%

#find all the variables in 'this' that are also in 'that'
this<-c(1:10)
that<-c(1,2)

this %in% that  ### should be read as, find all the moments where THIS is equal to THAT. It returns T/F of where this 1:10 equals 1 or 2. If we feed this back into our vector THIS it shows us the numbers themselves

this[this %in% that]   

that %in% this

that[that %in% this]  ###we can do it the other way around, and it shows us the same two numbers ofcourse. It is where the two vectors have in common
# %in% is essentially the same as stringing a bunch of 'or' statements together. In this case we are saying:

(this== that[1] | this == that[2])  ##look for all moments in THIS that equal 1 or 2. This gets inefficent quickly

#dplyr does this with the function intersect, however this doesnt give us T/F it only shows us the values they have in common
intersect(this,that)

#which can be used to show us at what location the two are common
which(this %in% that)    

#############################
#grouping
#############################
# Lets look at how to do analysis on grouped data in base R
# Base R grouping
data<-read.csv('rail_data.csv')
data
#lets subset our data into two dataframes for ease in this example. 
data1<-data[,1:3]    #a data frame called data1
grouping<-data[,4:5]  #and our grouping variables called grouping

# tapply runs a function on a vector based on a set of groupings we feed it
# tapply(vector, grouping vector, function)
tapply(data1$wingchord, grouping$genera, mean)  
data  #the groupings we give it have to be a vector of the same length as our vector because otherwise it will have moments where it doesnt know how to groupthem
##########
#by runs a function on a DATAFRAME based on a vector of groupings

by(data1, grouping$genera, data.frame)

#the key here is that it splits the entire dataframe into seperate dataframes based on our groupings. AND THEN runs a function on the dataframe itself. 
# This means the function we give it has to be able to be run on a dataframe
# mean for instance, can't do this
by(data1, grouping$genera, mean)
# summary however can be run on a dataframe
by(data1, grouping$genera, summary)

#############################
#aggregate takes a data frame and splits it into as many groups as we want, and then runs a function DOWN the columns

aggregate(data1, by = list(grouping$genera, grouping$migratory), mean)    # so the by= has to be a list, so just get used to typing by = list( all my groups)
data1
grouping

#################
#dplyr excels in grouping and summarizing
data1 %>% group_by(grouping$genera, grouping$migratory) %>% summarise_each(funs(mean), c(wingchord, culmen, tarsus))
# in this example we can take our data frame data1, then group by what ever groups we want, and then 
# use either summarise() which will do a by summary on the data frame, or summarise_each which will 
# run a function down the columns. And we can fee it what columns we want the function run on

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
data
t(data)
test<-t(t(data)/apply(data,2,sum))   # is sadly how we would actually do this, flipping it, doing the math, then flipping it back
apply(test,2,sum)

apply(data,1,prop.table)   #is ofcourse how you actually do this

#lapply  applys a function across a vector or list, its output is a list. So it treats each entry as an #already seperated vector, unlike apply that you tell how to split a vector

list1<-list(a=1:10,b=20:30,c=30:40)
list1  #remember each one of these objects is seperate from the other
# so we can run a function across the list, and it will calculate it seperately
lapply(list1,mean)
#notice it outputs the answer as another list
#sapply is the same as lapply except it returns a vector

sapply(list1,mean)

###whats great about both of these is they are recursive, you don't actually have to
# tell it how long the list is it just does it

#mapply applys a function across multiple vectors. This one can get mighty complicated
?mapply  ###look at the help file for more information and an explanation
mapply(function(x,y,z){c(x,y,z)},data[,1],data[,3],data[,5])
data[,1]
data[,3]
data[,5]
#so what it did was ran the function of c(x,y,z) and ran it with the 1st entry of each argument.
# Then ran it with the second entries of each argument

# we can run means across all 3 arguments like this
mapply(function(x,y,z){mean(c(x,y,z))},data[,1],data[,3],data[,5])   

#we can do some pretty funky things when we start putting these together.

lapply(mapply(function(x,y){subset(data[,1],data[,1]>=x & data[,1]<y)},1:10,5:14),var)  # i'll let you reason out what this is really doing

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

