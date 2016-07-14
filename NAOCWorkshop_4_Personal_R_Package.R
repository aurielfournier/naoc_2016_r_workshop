# Personal R Package
# This is all based off of/copied from the great blog post by Hilary Parker
# https://hilaryparker.com/2014/04/29/writing-an-r-package-from-scratch/
# all credit to Hilary @hspter 

# Step 0

install.packages("devtools")
library("devtools")
devtools::install_github("klutometis/roxygen")
library(roxygen2)

# step 1

setwd("parent_directory")
create("cats")

# step 2

# If you're reading this, you probably have functions that you've been meaning to create a package for. Copy those into your R folder. If you don't, may I suggest something along the lines of:

rail_function <- function(love=TRUE){
  if(love==TRUE){
    print("I love RAILS!")
  }
  else {
    print("I am not a cool person.")
  }
}

# copy and paste the function above into a seperate script and save it as rail_function.R in the 'R' directory in your new folder

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

# step 4

# This automatically adds in the .Rd files to the man directory, and adds a NAMESPACE file to the main directory. You can read up more about these, but in terms of steps you need to take, you really don't have to do anything further.

setwd("./cats")
document()

# step 5

setwd("..")
install("cats")

# Now you have a real, live, functioning R package. For example, try typing ?cat_function. You should see the standard help page pop up!

# you can also set up the package to be a github repo, see Hilary's post (link at top)


# other function examples

# open theme_krementz.R
# talk about custom ggplot themes
# show how the functions created in the programming lesson can be saved here
