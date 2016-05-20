#################################################################################
##          The Power of Automation  and Programming                           ##
#################################################################################
##                            by - Matt Boone (2015)                           ##
library (dplyr)
library (ggplot2)

#################################################################################
# We're now moving into the real fun stuff
# but first I need to teach you about some important functions you'll likely only use
# when you start getting serious in R
#################################################################################
#################################################################################
##                     IF statements and FOR LOOPS                             ##
#################################################################################
##Control Function: an operation that controls the recording 
##processing, or transmission of interpretation of data


##If statements, take logical statments and then decide what to do based on the logic
# it will do something based on whether something is or isnt true
# so it evaluates the expression within the parenthesis if(  ), and then does whats between the brackets if this is true. 
# If it isnt true then it does nothing. Atleast as of now
if(2>1){print("You can do math")}    ## 2 is greater than 1, so it did what was between the brackets


if(1>2){print("You can't do math")}   ##1 is not greater than 2 so it did nothing

##Say we want to figure out if a random number is greater than or less than 5

tt<-sample.int(10,1)
tt   #is our random number

#syntax is important when writing if statements, they're very picky in how you tell them what to do
# R is a bit like a senile man, you have to keep telling him you're still working, or else he just stops
# reading and moves on to the next thing with no memory of what happened before.
# we can also tell it to do something if the statement IS NOT true, by then telling it 'else' and giving it
# a set of things to do if the statement was not true
if(tt>5){
  print('number is greater than 5') } else {
    print('number is less than 5')}

# so this will tell us IF our random number is greater than 5, tell us, if not (or if else) tell us the number is less than 5

##This can get complicated quickly

ifelse(tt>5,print('number is greater than 5'),
       ifelse(tt<5,print('number is less than 5'),
          ifelse(tt==5,print('number is 5'))))   

# this now adds the next possibility, if the number is not greater than 5, or less than 5, but instead equal than 5 then tell us that the number is infact 5
##the writing of this statement is a bit hard to get your head around

data <- data.frame(a=1:10)


##pros of if statements: Can define exactly when to do something and when not to (control a situation), logical (by definition)
##cons of if statements: usually incorrectly used in R, make complicated statements
##IF STATEMENTS ARE BEST USED IN FOR LOOPS OR TO CHECK INPUTS. Controlling a situation
## note *** ifelse is an autmatic wrapper for ifelse statements, but generally leaves us with little else to do afterwards
ifelse(data[,1]>5,
              paste('number is larger than 5'),
                ifelse(data[,1]<5,
                  paste('number is not larger than 5'),
                    paste('number is 5')))   #runs the same set of instrictions but automatically loops the if else statement through the 1st column of data


#############################################################
##                      for loops                          ##
#############################################################
##an iterative process that loops through a sequence

for(i in 1:10){ print(i) }   ###what did this do?

# it wrapped through all values between 1 and 10...
for(i in 1:10){
  #stores the value as the variable i (or any variable name we told it to)
  i<-1
  
  #and then runs EVERYTYHING between the brackets with the variable as that value
  print(i) 
  
  }
# it then does this for the 1st value, then the 2nd, and so on until all values have been looped through

# because all its doing is storing the value as the variable i (again it can be named anything) we can do anything
#to this variable like we normally would. 
for(i in 1:10){print(i+1)}  ## in this case we want to add 1 to that value. So it took 1 and added 1 (equals 2), then took the next value (2) and added 1 (equals 3) so on and so on.

#####
## for loops are useful for refering to rows or columns in a data set if we just feed it sequential numbers
data<-matrix(1:100,nrow=10,ncol=10)
data

for(i in 1:10){print(data[i,1])}    ### is going to loop through all the rows in column 1 (and print that value)
for(i in 1:10){print(data[i,2])}    ###loops through all the rows in column 2 (and prints that value)
for(i in 1:10){print(data[i,1]+5)}   ###loops through all the rows in column 1 and adds 5 to that value
for(i in 1:10){data[i,2]<-data[i,1]+5}   ###does the same thing but stores the value in the correct row in column 2
data

##this example works but is not technically right!!!!
data[i,2]<- data[i,1]+5  ###is the best way to do this particular task

#many functions can be vectorized, meaning r automatically loops things together
paste0('hd',1:10)   ### automatically adds the numbers 1 through 10 onto the word 'hd'

#############
## so while for loops are great and often logical, they often do things in a way that is inefficient
####################
###If and For loops are usually used in conjunction

data[,1]

for(i in 1:10){
  if(data[i,1]>5){print(paste0(i,' is larger than 5'))}else{print(paste0(i,' is not larger than 5'))}
}

# this process runs through rows 1 through 10 of the 1st column of our data frame called data and tells us whether that value was greater than or less than 5. 

##exponentially slows down as iterations increase
# be careful running this example if your computer is knowing for being slow
data<-matrix(1:20000000,nrow=10000000,ncol=2) #(10 million entries and 20 million rows!!!)

ptm <- proc.time()
for(i in 1:10000000){data2<-data[i,1]+data[i,2]}
proc.time() - ptm

#takes 10 seconds on my computer

ptm<-proc.time()
data2<-data[i,1] + data[i,2]
proc.time() - ptm

# takes less than 1 second on my computer

##pros of for loops: can reference previous entries (useful for certain analysis), more logical way of writing code, near the same speed for smaller vectors, allows for automation to increase effecienc
##
##cons: processing time scales exponentially with vector length, harder to write when takes more than one for loop, difficult to debug, not appropriate for most mathematical functions (This is not how R thinks!!

## IF statments and for loops get abused in R a lot once they get taught, the reason is the base of many languages is with these. And that's true in R, but most functions are written as for loops in C which is faster, and R for loops are slow. R (S langauge) is written with the idea of linear algebra where things are done across vectors or matrixes

# Doing it this way is the fastest way to do any analysis in R.

# This means if you can do things across an entire matrix, or vector, you should do it. I call this vectorizing, some one likely has a better name for it

# The most common use of for loops is when you're loading in different files, or for instance trying different starter values

##############################
# Summary of if and for loops
#####################################################################

##-'for' loops are best to do tasks that can not be vectorized or when memory are an issue
##- 'for' loops are ideal for looping through files or starter values
##-'If' statements should only be used if vectorizing was not an option
##-If you have to make more than one 'if' statement you can probably vectorize it
##-Neither is ideal for math
##-Exceptions are when a function can not be vectorized or when referencing previous values
##-Also for lowering memory usage 
#(If your files exceed 1.5gb looping or other packages may be requried)

###############################
# Task
#Here is a set of values. I want you to write a for loop that converts these to Farenheit and then prints out whether this value is
# cold depending on if the resulting value is less than 50 degrees farenheit. 
# The function for this conversion is C*(9/5) +32
# use : for, if, print, and paste0

values<-c(30,25,6)

for(i in values){
  d<-i*9/5 +32
  ifelse(d<50,print(paste0(d,' degrees is cold')),print(d))
}



######################################################################
# Programming
#R is a language. This is what makes it different than a program like spss. It is
# similar to sas in that it is it's own language you can write it to run statistics
# and perform other tasks
# It has a base in C++ that you can write complex programs in
# but it is optimized for analyzing data not performing functions
# R can do many surprising things, but it should be noted that R doesn't do them 
# all optimally. There is a point when it is best to start learning other languages
# like C in order to do the more complex things. But you likely won't get ot this point!
#
#A quick aside on functions
# We're going to move into the territory where we start using loops and writing programs
# R's strength is in it's function interface, where we write functions, and then can
# easily run a long piece of code that's wrapped in a function
# Writing a piece of code and a function are nearly identical in thought, but are set
# up a little different. Just know every thing we write in long form can be 
# written as a function easily by just placing our variables in between the function() parenthesis
#
temp_fun<-function(temp_values){
for(i in temp_values){
  d<-i*9/5 +32
  ifelse(d<50,print(paste0(d,' degrees is cold')), print(d))
  rm(temp_values)
}}
   

#this runs our for loop for whatever vector of values you want
temp_fun(1)
temp_fun(c(1:100))


#################################################################################
#Programming
# Haven't we been programming this whole time?
# Technically, yes. We've been speaking in a language and making R do things 
# To me though, programming itself is a term that refers to writing reproducible, flexible, and scalable code
# that requires minimal input, and a consistent output.
# What this means is everytime you run the program it has the same output, no matter
# the input, and in some respects no matter the format of the input.
#
#Rules for Writing reproducible, flexible, and scalable code
# 1. Do not hard code. Refering to columns by number, entering dynamic names as static.
#    Hard coding refers to something that is only relevant to the specific run.
#    To do this we have to start thinking about how we can refer to a column, name or 
#    Object in a way that never changes.
# For example always ref to column names exactly, not as numbers. This is simple and obvious
# but may require that we clean our data so that our column names are what we think they are
# an easy example is always running tolower(), as often capitalization can get mixed up
# This also goes for row names. 

mtcars %>% head

row.names(mtcars)=='Pontiac Firebird'

colnames(mtcars)=='mpg'

mtcars %>%
  add_rownames(var="model") %>%
  filter(model=='Pontiac Firebird') %>%
  select(mpg)

# instead of 

mtcars[25,1]

# one reason for this is that columns are out of order, or when you merge data sets
# and column numbers change, or you simply add more data. It's safer just to refer to it in this manner.
# If you need to do math on column numbers you can still do that with which()

which(row.names(mtcars)=='Pontiac Firebird') - 1   ##gives us the row just before Pontiac Firebird

#Task.
#lets try a complex example. here is an eBird data file I've compiled for the state of delaware
# (it's called Ebird_DE.csv) it is in wide form, it has species names, taxa name, a variety of
# binary categories, and then presence numbers for each week, the weeks are labeled x1.1-x12.4
# How do we refer to the specific prevalance in a reproducible way? And not all these other columns.
# We have to do it in a scalable way just incase I want to add more columns. Which I clearly have done before
# 
# Lets make it complicated, say I want to calculate the mean presence each week only for breeding passerines 
# (breeder==1 and passerine==1)
# You can do it how ever you want, but as a hint, you might find some or all of these functions useful:
# which(), colnames(), grepl(). 
# Bonus points if you can figure out how to do it dplyr instead of base R

data<-read.csv('ebird/Ebird_DE.csv')

data %>% head

data[data$breeder==1 & data$passerine==1,grepl('^X',colnames(data))]

result <- data %>% 
            filter(breeder==1,
                    passerine==1) %>%
            select(contains('X')) %>%
            gather("quarter_month","value")


ggplot(data=result, aes(x=quarter_month, y=value)) + geom_point()


# 2. Make a dynamic and static variable list at the header of a code. This is essentially what
# we input in a function()

# 3. keep all your files in an organized order, and come up with a standard file system.
#    Write up a protocol for yourself, your lab, your company, and try to get people
#    to stick to it. We're going to start refering to changing file paths, and this
#    is imperative to making programs work everytime.

# Paste() is one of the most powerful tools for moving your experience from beginner to expert,
# and in particular refering to file paths on your computer based on the naming strucutre
#remember paste automatically adds a space between your two objects
paste('hello','world')   
#paste0 does not
paste0('hello','world')
#so we have to tell it what we want between each object
paste0('hello',' ','world')  # if you notice we told it to put a space (' ') between Hello and World

# say we want  to have a program that you give its name, and it tells you hello
name<-'Matt'
paste0('hello, ',name,' how are you?')

##we can write this as a function easily
foo<-function(name){paste0('hello,',name,' how are you')}
foo(name='matt')
foo('matt')
# that was a tangent, lets move forward

## lets read in file names

folder<-'Monstersinc'
file<-'scaretotal_MikeW_March.csv'

paste0(folder,'/',file)   # so its going to look in what ever folder we told it (Monstersinc in this case)
# and then its going to look for the file we tell it (in this case scaretotal_MikeW_March.csv)
read.csv(paste0(folder,'/',file))

# and we can get it to read in any file in that folder by changing the value of file

#This seems a bit silly now, but when we start adding looped variables it's going
# be a lot easier

###task  Here is a list of files with similar structure but different folders and
# file beginning names. Write a program that loads a files depending on the month and name
#file1: scaretotal_MikeW_March.csv
#file2: scaretotal_JamesS_March.csv
#file3: scaretotal_MikeW_April.csv
#file4  scaretotal_JamesS_April.csv
setwd('Monstersinc')

name<-'MikeW'
month<-'March'

####read in this file
data<-read.csv(paste0('scaretotal_',name,'_',month,'.csv'))

# 4. Keep your brackets in order, and label them if necessary
##Lets do the same, but now lets write a loop function that loads all
# possible values. We'll use two for loops
###I think im just going to do this together

#task4. I want you to write a function or a for loop that reads in all of the files
# for MikeW and stores them in a list()

##variables#####
our.list<-list()
# now lets write one that reads in all the of files for march

##now lets put it all together, lets make it so reads in all the files for both Mike and James for
# both the months of March and April
name<-c('MikeW','JamesS')
month<-c('March','April')
####code#########
for(i in name){
  
  for(p in month){
    
    our.list[[paste0(i,'_',p)]]<-read.csv(paste0('scaretotal_',i,'_',p,'.csv'))
    
  }  ##end p loop
  
}   ###end i loop

summary(our.list)

# notice how not only are the end brackets labeled but we're keeping the loops indented appropriately to show that one is nested inside of the other

# 5. Start simple, and build to more complex. Don't think about the big picture
# think about the individual steps. If you can do each individual step, then you
# can put them together. Write it out without a for loop before you start writing one.
# for loops are just repeating the same thing over and over. Therefore, if you can do it once
# you can do it infinity times


############################
  #I wanna make a function that calculates the 95% confidence interval no matter the input
  #use these functions sd(), length(), qt()
################variables###############
data<-c(1:10)   ###data as a vector
ci<-.01         ###confidence
########################################
#sd/sqrt(n) * tvalue (df) +/- mean    #heres what we need to do
# so instead of thinking of this as one giant problem and perhaps freezing up
# we should break it down into it's pieces and figure out how to do them one by one

sd.data<-sd(data)   #this function calculates the standard deviation, whew that was easy

n<-length(data)    #length takes the length of a vector, well thats the same as N, right?

sem<-sd.data/n    # put them together. And there we go, we have sd/sqrt(n) also known as the standard error of the mean (sem)

#perhaps with some googling you can figure out that the function qt gives us the t value as long
# as we also give it the degrees of freedom (which is n-1) and the confidence interval (ci)
tvalue<-qt(ci,(length(data)-1))   ###with that we can write this  

mean.data<-mean(data)   ##the mean can be calculated with the mean function
sem*tvalue   ##gives us our interval
upper<-mean.data + sem*tvalue   ##putting it all together, this gives us our upper range

lower<-mean.data - sem*tvalue   ## our lower


###now that we have all 3 of our numbers for our confidence interval we can have it print out the values
print(paste0('your upper bound is: (',upper, ') and your lower bound is: (', lower,"), and your mean is: (", mean.data,')'))
##################################
#lets add in an if statement that gives us an error message if we put in a confidence interval that is not between 0 and 1. 
# we can now either run it as is:
################variables###############
data<-c(1:10)   ###data as a vector
ci<-.01         ###confidence
########################################
##start of code
  if(ci>abs(1)){print("You can't have a probability greater than 1 stupid!")}else{
    sd.data<-sd(data)
    
    n<-length(data)
    
    sem<-sd.data/n
    
    tvalue<-qt(ci,(length(data)-1))
    
    mean.data<-mean(data)
    
    upper<-mean.data + sem*tvalue
    
    lower<-mean.data - sem*tvalue
    
    print(paste0('your upper bound is: (',upper, ') and your lower bound is: (', lower,"), and your mean is: (", mean.data,')'))
    list1<-list(upperbound=upper,lowerbound=lower,mean=mean.data)
  }

###end of code
##################
#or we can make it into a function
###
CI.fun<-function(data,ci){
  if(ci>abs(1)){print("You can't have a probability greater than 1 stupid!")}else{
  sd.data<-sd(data)
  
  n<-length(data)
  
  sem<-sd.data/n
  
  tvalue<-qt(ci,(length(data)-1))
  
  mean.data<-mean(data)
  
  upper<-mean.data + sem*tvalue
  
  lower<-mean.data - sem*tvalue
  
  print(paste0('your upper bound is: (',upper, ') and your lower bound is: (', lower,"), and your mean is: (", mean.data,')'))
  list1<-list(upperbound=upper,lowerbound=lower,mean=mean.data)
  }}

##and now we can feed it whatever data vector and confidence interval we want
result<-CI.fun(1:100,.95)    ##try it with a data vector of all integers between 1 and 100
result<-CI.fun(sample.int(100,20),.95)   ###try it with a data vector of 20 random numbers

##whatever data vector we give it, as long as they are real numbers, it will give us an answer
# lets not forget our error message
CI.fun(1:10,2)


###heres how you would write the function shorter
# remember if you use a variable more than once, just store it as a value to make your life easier
CI.fun<-function(data,ci){
  range<-sd(data)/length(data) * qt(ci,(length(data)-1))
  mean.data<-mean(data)
    list1<-list(upper=mean.data+range,lower=mean.data-range,mean=mean.data)
    print(list1)
}
result<-CI.fun(1:10,.95)
#######################
###Finally, what can we do with this? let's work together to build something great.
# So there's this nifty trick that happens often on the internet, and that is that
# website will have url will change based on the input of them. What it's actually doing
# is sending a queery to a data base and returning a product. Let me give you an example of sites that allow this
# eBird - http://ebird.org/ebird/GuideMe?cmd=changeLocation
# radiosondes - http://weather.uwyo.edu/upperair/sounding.html
###################################################################
######So here is what I want to do. I want to create a program that automatically downloads
# eBird prevalence's  and saves them for a variety of states and time periods.
###################################################################
###let's start by creating our variable header
###################################################################
##                     our awesome program                       ##
###################################################################
# We'll start by just trying to get it to download one file
#Variables
##################################################################
#base url (for reference)
# this is the url that when put in as a url will automatically download the ebird prevelances
# for Oklahoma between the years 1900-2015. You can see 'US-OK' tells the website what country and state,
#'byear=1900' tells it the early year, and 'eyear=2015' tells it the latest year

#http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=states&states=US-OK&bYear=1900&eYear=2015&bMonth=1&eMonth=12&reportType=location&parentState=US-OK

#using the download.file() how can we get it to download the file we want, no matter the input?
setwd('C:/Users/Matt/Documents/workshop/ebird')
states<-'OK'
years<-2008

####################################################################
url1<-paste0('http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=states&states=US-',
             states,
             '&bYear=',
              years, 
              '&eYear=',
              years,
             '&bMonth=1&eMonth=12&reportType=location&parentState=US-',
              states
             ) 
download.file(url1,paste0('eBird_',states,'_',years))
###ok that seems to work, now luckily I already know how to read these files
data<-read.delim(paste0('eBird_',states,'_',years),skip=14,header=F,row.names=1)[,1:48]
head(data)
colnames(data)<-paste0(rep(1:12,each=4),'.',1:4)   ###renames the columns in a manner we want
write.csv(data,paste0('eBird_',states,'_',years,'.csv'))   ###writes the file as a csv, and names it how we want
file.remove(paste0('eBird_',states,'_',years))  ### a very dangerous function, you need to know exactly what youre refering too, but this removes the .txt file originally downloaded

###################
#so this is great! we did it once! Now we just have to loop it, and it will do it for all of our inputs
############################
#####new code###############
#####variables####################################################
states<-c('OK','TX')
years<-c(2008:2014)
##################################################################
for(i in states){
  for(p in years){
#base url (for reference)
#http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=states&states=US-OK&bYear=1900&eYear=2015&bMonth=1&eMonth=12&reportType=location&parentState=US-OK
#using the download.file() how can we get it to download the file we want, no matter the input?
#lets start by just doing it once, we can create the for loop later
url1<-paste0('http://ebird.org/ebird/BarChart?cmd=getChart&displayType=download&getLocations=states&states=US-',
             i,
             '&bYear=',
             p, 
             '&eYear=',
             i,
             '&bMonth=1&eMonth=12&reportType=location&parentState=US-',
             p
              )  ###end of paste
download.file(url1,paste0('eBird_',i,'_',p))

data<-read.delim(paste0('eBird_',i,'_',p),skip=14,header=F,row.names=1)[,1:48]
colnames(data)<-paste0(rep(1:12,each=4),'.',1:4)
write.csv(data,paste0('eBird_',i,'_',p,'.csv'))
file.remove(paste0('eBird_',i,'_',p))  ### a very dangerous function, you need to know exactly what youre refering too
} #i loop
} #p loop

#########################################
##we could even use another for loop, or store it as a list, to then combine all these files into one
# giant file. From here the possibilites are endless!
#########################################
##############end #######################