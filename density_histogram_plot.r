library(ggplot2)
source("multiplot.R") # this function allows for multiple ggplots in one output

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


model_all=c('Leopard','Anchor','DeepSleep')
m=length(model_all) # e.g. number of models

set.seed(449)
n=100 # 100 example points
dat1=data.frame(value=rnorm(100,0.7,0.1),model=rep(model_all[1],n))
dat2=data.frame(value=rnorm(100,0.6,0.1),model=rep(model_all[2],n))
dat3=data.frame(value=rnorm(100,0.4,0.1),model=rep(model_all[3],n))
avg=c(mean(dat1[,1]),mean(dat2[,1]),mean(dat3[,1]))

the_palette=p_jco[c(4,1,2)]
names(the_palette)=model_all

## 1. first way
p1=ggplot() +
    geom_density(dat3, mapping=aes(value, fill = model, colour = model), alpha = 0.2, linetype=2) +
    geom_density(dat2, mapping=aes(value, fill = model, colour = model), alpha = 0.2) +
    geom_density(dat1, mapping=aes(value, fill = model, colour = model), alpha = 0.2) +
    scale_fill_manual(values=the_palette) +
    scale_colour_manual(values=the_palette) +
    xlim(0,1) +
    theme_light() +
    labs(title="density distribution",y='count/density',x='correlation') +
    theme(plot.title = element_text(hjust = 0.5,size=18))+
    theme(axis.title.x = element_text(colour="black", size=15))+
    theme(axis.title.y = element_text(colour="black", size=15))+
    theme(axis.text.x = element_text(colour="black", size=15))+
    theme(axis.text.y = element_text(colour="black",size=15))+
    geom_segment(aes(x=avg,xend=avg,y=0,yend=5),linetype=2, color='grey70') +
    annotate("text", x = avg+0.03, y = 5, label=paste0(format(avg,digits=3)),size=5)
p1

## 2. second way
dat=rbind(dat1,dat2,dat3)

p2=ggplot() +
    geom_density(dat, mapping=aes(value, fill = model, colour = model), alpha = 0.2) +
    scale_fill_manual(values=the_palette) + 
    scale_colour_manual(values=the_palette) + 
    xlim(0,1) +
    theme_light() +
    labs(title="density distribution",y='count/density',x='correlation') +
    theme(plot.title = element_text(hjust = 0.5,size=18))+
    theme(axis.title.x = element_text(colour="black", size=15))+
    theme(axis.title.y = element_text(colour="black", size=15))+
    theme(axis.text.x = element_text(colour="black", size=15))+
    theme(axis.text.y = element_text(colour="black",size=15))+
    geom_segment(aes(x=avg,xend=avg,y=0,yend=5),linetype=2, color='grey70') +
    annotate("text", x = avg+0.03, y = 5, label=paste0(format(avg,digits=3)),size=5)
p2

## 3. histogram

p3=ggplot() +
    geom_histogram(dat1, mapping=aes(value, fill = NA, colour = model), bins=100, alpha=0.4) + # bin number
    geom_density(dat1, mapping=aes(value, fill = model, colour = model),alpha=0.2) +
    scale_fill_manual(values=the_palette) + 
    scale_colour_manual(values=the_palette) + 
    xlim(0,1) +
    theme_light() +
    labs(title="density distribution",y='count/density',x='correlation') +
    theme(plot.title = element_text(hjust = 0.5,size=18))+
    theme(axis.title.x = element_text(colour="black", size=15))+
    theme(axis.title.y = element_text(colour="black", size=15))+
    theme(axis.text.x = element_text(colour="black", size=15))+
    theme(axis.text.y = element_text(colour="black",size=15))+
    theme(legend.position="none")
p3

p4=ggplot() +
    geom_histogram(dat2, mapping=aes(value, fill = NA, colour = model), alpha=0.4) +
    geom_density(dat2, mapping=aes(value, fill = model, colour = model),alpha=0.2) +
    scale_fill_manual(values=the_palette) + 
    scale_colour_manual(values=the_palette) + 
    xlim(0,1) +
    theme_light() +
    labs(title="density distribution",y='count/density',x='correlation') +
    theme(plot.title = element_text(hjust = 0.5,size=18))+
    theme(axis.title.x = element_text(colour="black", size=15))+
    theme(axis.title.y = element_text(colour="black", size=15))+
    theme(axis.text.x = element_text(colour="black", size=15))+
    theme(axis.text.y = element_text(colour="black",size=15))+
    theme(legend.position="none")
p4

p5=ggplot() +
    geom_histogram(dat3, mapping=aes(value, fill = NA, colour = model), alpha=0.4) +
    geom_density(dat3, mapping=aes(value, fill = model, colour = model),alpha=0.2) +
    scale_fill_manual(values=the_palette) + 
    scale_colour_manual(values=the_palette) + 
    xlim(0,1) +
    theme_light() +
    labs(title="density distribution",y='count/density',x='correlation') +
    theme(plot.title = element_text(hjust = 0.5,size=18))+
    theme(axis.title.x = element_text(colour="black", size=15))+
    theme(axis.title.y = element_text(colour="black", size=15))+
    theme(axis.text.x = element_text(colour="black", size=15))+
    theme(axis.text.y = element_text(colour="black",size=15))+
    theme(legend.position="none")
p5


list_p=c(list(p1),list(p2),list(p3),list(p4),list(p5))

mat_layout=matrix(0,nrow=3,ncol=3)
mat_layout[1,]=1
mat_layout[2,]=2
mat_layout[3,]=3:5

png(filename="figure/density_histogram_plot.png",width=10,height=8,units='in',res=300) # unit inch
multiplot(plotlist=list_p,layout = mat_layout)
dev.off()


