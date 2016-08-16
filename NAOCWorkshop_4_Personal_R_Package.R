# Personal R Package
# This is all based off of/copied from the great blog post by Hilary Parker
# https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
# all credit to Hilary @hspter 

# Step 0
# library("devtools")
# devtools::install_github("klutometis/roxygen")
# library(roxygen2)

install.packages("roxygen2")
library(devtools)
library(roxygen2)

# step 1
#setwd("parent_directory")
create("package")

# step 2


rail_function <- function(love=TRUE){
  if(love==TRUE){
    print("I love RAILS!")
  }
  else {
    print("I am not a cool person.")
  }
}

# copy and paste the function above into a seperate script and save it as rail_function.R in the 'R' directory in your new folder


########## Data in a package

# you can also store data in a package, which is super handy. to do this 

some_random_data <- data.frame(a=1:10, b=rep(200,10),c="BIRDS RULE")

save(some_random_data, file="~/naoc_2016_r_workshop/package/data/some_random_data.rda")

# Step 3 

# add some documentation to the top of your function
# future you will thank you

#' A Rail Function
#'
#' This function allows you to express your love of rails.
#' @param love Do you love rails? Defaults to TRUE.
#' @keywords rails
#' @export
#' @examples
#' rail_function()


# you should also document your data!

#' some data Auriel cooked up
#'
#' #'
#' @format A data frame with 10 rows and 3 columns
#' \describe{
#'   \item{a}{numbers from 1 to 10}
#'   \item{b}{the number 200}
#'   \item{c}{proof that BIRDS RULE}
#' }
#' @source NAOC 2016 
"some_random_data"

# step 4

# This automatically adds in the .Rd files to the man directory, and adds a NAMESPACE file to the main directory. You can read up more about these, but in terms of steps you need to take, you really don't have to do anything further.

setwd("./package")
document()

# step 5

setwd("..")
install("package")

library(package)
data("some_random_data")
rail_function()

# Now you have a real, live, functioning R package. For example, try typing ?cat_function. You should see the standard help page pop up!

# you can also set up the package to be a github repo, see Hilary's post (link at top)


# other function examples

# open theme_krementz.R
# talk about custom ggplot themes
# show how the functions created in the programming lesson can be saved here


## This isn't a post about learning to use git and GitHub - for that I recommend Karl Broman's Git/GitHub Guide (http://kbroman.github.io/github_tutorial/). The benefit, however, to putting your package onto GitHub is that you can use the devtools install_github() function to install your new package directly from the GitHub page.
## which is super helpful, but by no means required. 



# examples of other people's personal R packages
# https://github.com/dwinter/MoreUtils/tree/master/R
# https://github.com/eheisman/hydroutils/tree/master/R & # https://t.co/PGCsTXZJuI
# https://github.com/aurielfournier/rel