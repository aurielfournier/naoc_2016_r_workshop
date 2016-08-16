#http://stackoverflow.com/questions/22116518/add-x-and-y-axis-to-all-facet-wrap


ggplot(data=gapminder, 
       aes(x = year, 
           y = lifeExp, 
           group=country)) +
  geom_line() + 
  facet_wrap(~continent, ncol=2,scales='free')+
  scale_x_continuous(limits=c(1952,2007)) + 
  scale_y_continuous(limits=c(20,100))

# by setting scales='free' in facet_wrap we are telling it to let the scales vary between facets
# and so it has to label all of them
# but we want them to be the same, so then we have to define them


#http://stat.ethz.ch/R-manual/R-devel/library/base/html/double.html

# double is basically just another kind of numeric, with additional precision, for our purposes it is the same

#https://www.r-bloggers.com/change-fonts-in-ggplot2-and-create-xkcd-style-graphs/

install.packages("extrafont")
library(extrafont)
font_import(pattern="[A/a]rial")
fonts()
loadfonts(device="win")

ggplot(data=gapminder, 
       aes(x = year, 
           y = lifeExp, 
           group=country)) +
  geom_line()+
  theme(text=element_text(size=16, 
                          family="Arial"))