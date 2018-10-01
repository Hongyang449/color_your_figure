## name: scatter_plot.r

library(ggplot2)

# these three palettes were copied from here:
# https://github.com/road2stat/ggsci/blob/master/data-raw/data-generator.R
p_jama=c(
  'Limed Spruce' = '#374E55', 'Anzac'         = '#DF8F44',
  'Cerulean'     = '#00A1D5', 'Apple Blossom' = '#B24745',
  'Acapulco'     = '#79AF97', 'Kimberly'      = '#6A6599',
  'Makara'       = '#80796B')
p_jco=c(
  'Lochmara' = '#0073C2', 'Corn'         = '#EFC000',
  'Gray'     = '#868686', 'ChestnutRose' = '#CD534C',
  'Danube'   = '#7AA6DC', 'RegalBlue'    = '#003C67',
  'Olive'    = '#8F7700', 'MineShaft'    = '#3B3B3B',
  'WellRead' = '#A73030', 'KashmirBlue'  = '#4A6990')
p_d3=c(
  'Matisse'      = '#1F77B4', 'Flamenco'     = '#FF7F0E',
  'ForestGreen'  = '#2CA02C', 'Punch'        = '#D62728',
  'Wisteria'     = '#9467BD', 'SpicyMix'     = '#8C564B',
  'Orchid'       = '#E377C2', 'Gray'         = '#7F7F7F',
  'KeyLimePie'   = '#BCBD22', 'Java'         = '#17BECF',
  'Spindle'      = '#AEC7E8', 'MaC'          = '#FFBB78',
  'Feijoa'       = '#98DF8A', 'MonaLisa'     = '#FF9896',
  'LavenderGray' = '#C5B0D5', 'Quicksand'    = '#C49C94',
  'Chantilly'    = '#F7B6D2', 'Silver'       = '#C7C7C7',
  'Deco'         = '#DBDB8D', 'RegentStBlue' = '#9EDAE5')

# customize the color palette
the_palette=c(p_jco[-3],p_jama[5:6],p_d3[3:2])
names(the_palette)=paste0("object ", sprintf("%02d",1:13))

# generate a data frame with three columns: x, y, name (e.g. cell line)
set.seed(3.14)
dat=data.frame(x=rnorm(n=30,mean=0.5,sd=0.2),y=rnorm(30,0.5,0.2), # rnorm to generate some random numbers
    name=sort(names(the_palette)[sample(13,30,replace=T)]))
# dat looks like this:
#           x          y      name
#1  0.3076133 0.68012495 object 02
#2  0.4414949 0.67035409 object 02
#3  0.5517576 0.64554303 object 03
#4  0.2695736 0.64730043 object 03
#5  0.5391566 0.42957408 object 03
#6  0.5060248 0.64110310 object 04

# save your plot in p1
p1=ggplot(dat, aes(x,y,color=name)) + # use column "name" to color 
    geom_segment(aes(x = 0.0, y = 0.0, xend = 0.9, yend = 0.9), colour = "grey", linetype=3) + # draw a line
    geom_point(size=3,pch=19,alpha=0.6) + # pch controls plot symbols; alpha controls the transparency
    scale_colour_manual(values=the_palette) + # use the customized palette
    geom_smooth(method="lm", size=0.5, colour='blue', se=F) + # draw a regression line
    theme_light() + # light background
    ylim(0.0,0.9) + # set y limit
    xlim(0.0,0.9) + # set x limit
    theme(axis.line.x = element_line(color="black", size=0.5)) + # customize the font of y-axis (you can use the default)
    theme(axis.line.y = element_line(color="black", size=0.5)) +
    theme(axis.title.x = element_text(colour="black", size=12)) +
    theme(axis.title.y = element_text(colour="black", size=12)) +
    theme(axis.text.x = element_text(colour="black",size=12, angle=45, hjust=1)) + # rotate x-axis label by 45 degree
    theme(axis.text.y = element_text(colour="black",size=12)) +
    theme(plot.title = element_text(hjust = 0.5)) + # hjust=0.5 set the title in the center
    labs(x='Your X Title',y='Your Y Title',title='Your Figure Title') + # customize titles
    annotate("text", x = 0.15, y = 0.7, label=paste0("median Y= ",format(median(dat[,"y"]),digits=2)),size=5) + # add annotations
    annotate("text", x = 0.7, y = 0.15, label=paste0("median X= ",format(median(dat[,"x"]),digits=2)),size=5)
# have a look at p1
p1   

# save your plot (if your illustrator doesn't accept the pdf dots, add this "useDingbats=F")
pdf(file="figure/scatter_plot.pdf",width=10,height=8) # customize the size of the pdf
p1
dev.off()



