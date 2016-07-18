######################################
## GGPLOT SECTION OF AOU WORKSHOP
######################################

# use install.packages() if you don't have these already
library(dplyr) #
library(ggplot2) # 
library(ggthemes)
library(RColorBrewer)
library(gridExtra)
library(gapminder) #

# the data we are using today is called the gapminder dataset

data(gapminder)

gdat <- gapminder

colnames(gdat) <- tolower(colnames(gdat))

# we are not going to use qplot
# we are going to dive into the real meat of ggplot
# I find qplot REALLY confusing, and it hurts you long term

# to begin every plot in ggplot we start with the ggplot() command
# often this is where you give it your data and start things off, but it is never where you end

# ggplot(gdat, aes(x = gdppercap, y = lifeexp))

## no layers in plot

## what we have done so far is told ggplot what data we want to use and what axis we want it on, but we haven't told it what kind of graph we want. 

# we can take our graphing object p and add the kind of graph we want, (geom) in this case we want the data represented as points 
ggplot(gdat, aes(x = gdppercap, y = lifeexp)) + geom_point()


ggplot(gdat, aes(x = gdppercap, y = lifeexp)) + 
    geom_point() + 
    scale_x_log10()

#add COLOR
ggplot(gdat, aes(x = gdppercap, y = lifeexp))+ 
    geom_point(aes(color=continent)) + 
    scale_x_log10()


# you can also put the data and aesthetics in the geom_layer
#alpha gives you transparent points
ggplot(data=gdat, aes(x=gdppercap, y=lifeexp))+scale_x_log10()+ 
    geom_point(aes(alpha=(1/3), size=3))


ggplot(gdat, aes(x=gdppercap, y=lifeexp))+
    scale_x_log10() + 
    geom_point() + 
    geom_smooth()

# turn on and off the standard error 
ggplot(gdat, aes(x=gdppercap, y=lifeexp))+scale_x_log10() +
  geom_point() + 
  geom_smooth(lwd = 3, se = FALSE, method = "lm")
# argument added = method 
# lm = linear model


ggplot(gdat, aes(x=gdppercap, y=lifeexp, color=continent))+
  scale_x_log10()+ 
  geom_point()+
  geom_smooth(lwd=3, se=F,method="lm")

# ok but that is ALOT of lines on the same graph, and is super messy. Maybe good for a first glance, but not beyond that
# thsi is where facet wrap comes into play
# explain facet wrap

ggplot(gdat, aes(x=gdppercap, y=lifeexp))+
  scale_x_log10()+ 
  geom_point(alpha=(1/3), size=3)+
  facet_wrap(~continent)


ggplot(gdat, aes(x=gdppercap, y=lifeexp))+
  scale_x_log10()+ 
  geom_point(alpha = (1/3), size = 3)+ 
  facet_wrap(~ continent) +
  geom_smooth(lwd = 1, se = FALSE, method="lm")

# exercises:
# plot lifeexp against year

# make mini-plots, split out by continent

# add a fitted smooth and/or linear regression


ggplot(gdat, aes(x = year, y = lifeexp))+ 
  geom_point()

ggplot(gdat, aes(x = year, y = lifeexp))+ 
  geom_point()+ 
  facet_wrap(~continent)

ggplot(gdat, aes(x = year, y = lifeexp))+ 
  geom_point()+ 
  geom_smooth(se = FALSE, lwd = 2)+
  facet_wrap(~ continent)

# ok what if we want to draw this with lines connecting the life expectancy of each country? 
ggplot(gdat[gdat$continent=="Africa",], aes(x = year, y = lifeexp))+ 
  geom_point()+ 
  geom_line() # uh, no

# need to give the aesthetic group = country otherwise it runs one line through all the points. 

# talk about group versus color
# color gives you legend, group does not
# add the group aes to ggplot because it 
# doesnt' matter if geom_point is grouped
ggplot(gdat[gdat$continent=="Africa",], aes(x = year, y = lifeexp, group=country))+ 
  geom_point()+ 
  geom_line()

####################
## CHALLENGE
####################

# We can use vectores of names and the %in% operator to grab a subset of countries

jCountries <- c("Canada", "Rwanda", "Cambodia", "Mexico")

ggplot(subset(gdat, country %in% jCountries), aes(x = year, y = lifeexp, color = country))+ 
  geom_line()+ 
  geom_point()

#what if we want the order of the colors and legend to match the order of the lines?
# we can use the reorder function as part of the color argument
ggplot(subset(gdat, country %in% jCountries),
  aes(x = year, y = lifeexp, color = reorder(country, -1 * lifeexp, max))) +
  geom_line()+ 
  geom_point()

## SAVING PLOTS ##

## Talk about working directories!!
y <- ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_point()

ggsave(y, filename="y.png", width=10, height=10, units="cm")

# this is not in ggplot
png(filename="plot.png")

ggplot(subset(gdat, country %in% jCountries),
  aes(x = year, y = lifeexp, color = reorder(country, -1 * lifeexp, max))) +
  geom_line()+ 
  geom_point()

dev.off()

# talk about manually exporting

#########################
## Kinds of Graphs ##
#########################

## so there are different geoms for different kinds of graphs, we'll cover some of the basics here

## Bar Graph

ggplot(gdat, aes(x=continent))+
  geom_bar()

ggplot(gdat, aes(x=reorder(continent, continent, length))) + 
  geom_bar()

ggplot(gdat, aes(x=continent))+
  geom_bar() +
  coord_flip()

#you can make the bars bigger or smaller

ggplot(gdat, aes(x=reorder(continent, continent, length))) + 
  geom_bar(width=0.05)+
  coord_flip()


 # bar plots with already given y values
(jDat <- gdat %>% group_by(continent) %>% summarise(avg=mean(pop)))

ggplot(jDat, aes(x = continent)) + 
  geom_bar()

ggplot(jDat, aes(x = continent, y = avg)) + 
  geom_bar(stat = "identity")

## Line Graph

ggplot(gdat, aes(x=year,y=lifeexp, group=country)) + 
  geom_line()


ggplot(gdat, aes(x=year,y=lifeexp, group=country)) + 
  geom_line() +
  facet_wrap(~continent)


## Histogram

ggplot(gdat, aes(x=lifeexp))+
  geom_histogram()

## Scatter Plot

ggplot(gdat, aes(x=lifeexp, y=gdppercap)) + 
  geom_point()

## box plots

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()

###################################
## THEMES ##
###################################

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")+ 
  theme_grey()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_bw()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_calc()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_economist()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_economist_white()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_few()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_gdocs()

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + 
  theme_wsj()

###############################
# BUT YOU CAN DO IT YOURSELF
# OF COURSE
###############################

# these is where ggplot can become really really exhausting
# ALMOST anything you want to do, can be done

# things I know cannot be done
###############################################
    # you cannot have two different y axis

## so you can add things onto a default theme, to make it better/what you want
## here we can remove the gridlines from theme_bw

ggplot(gdat, aes(x=continent, y=lifeexp)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")+
  theme_bw()+
  theme(panel.grid=element_blank())

# you can also make BUTT UGLY GRAPHS

ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country, color=country)) + 
  geom_line()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")+
  theme(axis.text = element_text(size = 35),
    axis.title=element_text(size=50, color="red"),
    legend.key = element_rect(fill = "navy"),
    legend.background = element_rect(fill = "white"),
    legend.position = "bottom",
    legend.direction = "vertical",
    panel.grid.major.x = element_line(colour = "grey40"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "navy")
)

## Custom Legend Position


ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country, color=country)) + 
  geom_line()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")+
  theme(axis.text = element_text(size = 35),
    axis.title.x=element_text(size=50, color="red"),
    legend.key = element_rect(fill = "navy"),
    legend.background = element_rect(fill = "white"),
    legend.position = c(.15,.75),
    legend.direction = "vertical",
    panel.grid.major.x = element_line(colour = "grey40"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "navy")
)

## change legend title

ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country, color=country)) + 
  geom_line()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")+
  theme(axis.text = element_text(size = 35),
    axis.title.x=element_text(size=50, color="red"),
    legend.key = element_rect(fill = "navy"),
    legend.background = element_rect(fill = "white"),
    legend.position = c(.15,.75),
    legend.direction = "vertical",
    panel.grid.major.x = element_line(colour = "grey40"),
    panel.grid.major.y = element_blank(),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "navy")
)+
  scale_color_discrete(name="Countries in\nOceania")


## Clearly this is very ugly

## What I do is have a script with these theme defaults that I can throw in. 
ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country, color=country)) + 
  geom_line()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") +
  theme(axis.text.x = element_text(ang=90,color="black", size=15),
        axis.text.y = element_text(ang=90,size=15,color="black"),
        axis.title.x=element_blank(),
        axis.title.y=element_text(size=20),
        plot.background = element_rect(fill = "white" ),
        panel.grid.major= element_line(colour=NA), 
        panel.grid.minor=element_line(colour=NA),
        panel.background = element_rect(fill = "white"),
        legend.position="none",
        axis.line=element_line(colour="black"))



ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country, color=country)) + 
  geom_line()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")  +
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = c(0.14, 0.80),
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank()
  )

###################
# Legends
###################

ggplot(gdat, aes(x=pop, y=lifeexp, color=continent)) + 
  geom_point()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")  +
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = c(.6,.1),
        legend.direction= "horizontal",
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank()
  )


#########
# Error Bars
#########

gdat$se <- 5000


ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=gdppercap, color=country)) + 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here")  +
  theme_bw()+
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = c(.6,.1),
        legend.direction= "horizontal",
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()
  )+
  geom_ribbon(aes(ymin=gdppercap-se, ymax=gdppercap+se), alpha=0.4)+
    geom_line()



ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=gdppercap, color=country)) + 
  geom_point()+ 
  theme(axis.text = element_text(size = 14),
        legend.key = element_rect(fill = "navy"),
        legend.background = element_rect(fill = "white"),
        legend.position = c(.6,.1),
        legend.direction= "horizontal",
        panel.grid.major = element_line(colour = "grey40"),
        panel.grid.minor = element_blank()
  )+
  geom_line()+
  geom_errorbar(aes(ymin=gdppercap-se, ymax=gdppercap+se))


######################
# Colors (RColorBrewer)
#####################
#http://colorbrewer2.org/
  
display.brewer.all(n=NULL, type="all", select=NULL, exact.n=TRUE,colorblindFriendly=TRUE)
  
# explain WHAT this is doing
mypalette<-brewer.pal(5,"Greens")

ggplot(gdat, aes(x=continent, y=lifeexp, fill=continent)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + scale_fill_manual(values=mypalette)

mypalette<-brewer.pal(5,"Set2")

ggplot(gdat, aes(x=continent, y=lifeexp, fill=continent)) + 
  geom_boxplot()+ 
  ggtitle("TITLE HERE")+ 
  xlab("text here")+ 
  ylab("text here") + scale_fill_manual(values=mypalette)

# mention that you can come up with your own vectores of hexidecimal or 'word' colors

# put in explanation of how to store graphs as objects

# you can always add onto the aesthetics later by adding an additional aes command. 
ggplot(gdat, aes(x=gdppercap, y=lifeexp))+
  scale_x_log10()+ 
  aes(color=continent)+
  geom_point()+
  geom_smooth(lwd=3, se=F)

###################################
## Stacking and Rearranging Graphs (gridExtra)
###################################

a <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country)) + 
  geom_line()

b <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=gdppercap, group=country)) + 
  geom_line()


grid.arrange(a,b,a,b,nrow=2)

png("x.png")
grid.arrange(a,b,nrow=2)
dev.off()

graphs <- list()

graphs[[1]] <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country)) + 
  geom_line()

graphs[[2]] <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=gdppercap, group=country)) + 
  geom_line()

graphs[[3]] <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country)) + 
  geom_line()

graphs[[4]] <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=gdppercap, group=country)) + 
  geom_line()

graphs[[5]] <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=lifeexp, group=country)) + 
  geom_line()

graphs[[6]] <- ggplot(gdat[gdat$continent=="Oceania",], aes(x=year, y=gdppercap, group=country)) + 
  geom_line()

do.call(grid.arrange,graphs)
