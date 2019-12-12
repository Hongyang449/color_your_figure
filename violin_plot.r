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


model_all=c('Linear','Ridge','SVM','RF')
m=length(model_all) # e.g. number of models

set.seed(449)
n=100 # 100 example points
dat=NULL
j=0.7
avg=NULL
for (i in 1:m){
    tmp=sample(n*10,n)/n/100 + j # range [j,j+0.1]
    avg=c(avg,mean(tmp))
    the_dat=data.frame(value=tmp,rep(model_all[i],n))
    dat=rbind(dat, the_dat)
    j=j+0.05*(sample(10,1)/10+0.5)
}
colnames(dat)=c('value','model')

the_palette=p_jco[1:m]
names(the_palette)=unique(dat[,'model'])

p1=ggplot(dat, aes(model,value,fill=model)) + # use column "name" to color 
    #geom_violin(width=0.5, colour="grey50",draw_quantiles = 0.5) +    
    geom_violin(width=0.7,aes(fill=model),colour="grey50",alpha=1,linetype=1,lwd=0.5)+
    geom_boxplot(width=0.1)+
    stat_summary(fun.y=mean, geom="point", aes(shape="Mean"), size=2,color='red')+
    scale_fill_manual(values=the_palette) +
    ylim(0.7,0.95) +
    theme_light() + # light background
    theme(axis.line.x = element_line(color="black", size=0.5)) +
    theme(axis.line.y = element_line(color="black", size=0.5)) +
    theme(axis.title.x = element_text(colour="black", size=15)) +
    theme(axis.title.y = element_text(colour="black", size=15)) +
    theme(axis.text.x = element_text(colour="black",size=15)) +
    theme(axis.text.y = element_text(colour="black",size=15)) +
    theme(plot.title = element_text(hjust = 0.5)) + # hjust=0.5 set the title in the center
    theme(legend.position="none") +
    annotate("text", x = 1:4+0.2, y = 0.95, label=paste0(format(avg,digits=3)),size=5)+
    labs(x='base learner',y="Pearson's correlation coefficient" ,title='Predictive Performance')
p1

png(filename="figure/violin_plot.png",width=10,height=8,units='in',res=300) # unit inch
p1
dev.off()


