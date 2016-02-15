dat <- data.frame(a=seq(1,100, by=2), b=rnorm(50,0,1))


ggplot()+geom_line(data=dat, aes(x=a, y=b), color="white")+theme(panel.background=element_rect(fill="black"),
                                                  plot.background=element_rect(fill="black"),
                                                  text=element_text(color="white"),
                                                  panel.grid=element_blank(),
                                                  axis.line=element_line(color="white"))
