#' A theme that Krementz seems to not hate too much
#' 
#' This function makes ggplots look in a way that my adviser will hopefully not hate
#' there are no arguments
#' @keywords ggplot2 
#' @export
#' @examples 
#' ggplot(data=dat, aes(x=x, y=y))+geom_point()+theme_krementz()


theme_krementz <- function(){
  theme(axis.text.x = element_text(size=12,color="black"),
        axis.text.y = element_text(size=12,color="black"),
        axis.title.y=element_text(size=20),
        plot.background = element_blank(),
        panel.border=element_blank(),
        panel.grid.major= element_blank(), 
        panel.grid.minor=element_blank(),
        title=element_text(size=20),
        panel.background = element_rect(fill = "white"),
        axis.line.x=element_line(colour="black"),
        axis.line.y=element_line(colour="black"),
        strip.background=element_rect(fill="white", color="black"),
        strip.text=element_text(size=15))
}