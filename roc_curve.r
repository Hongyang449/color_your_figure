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

set.seed(449)
n=100 # 100 example points
m=5 # e.g. number of models/cross-validation
dat=NULL
for (i in 1:m){
    tmp=sort(sample(n*10,n)/n/10)
    tmp=sort(tmp*c(seq(1.01,2,0.02),rev(seq(1.01,2,0.02)))) # try to simulate the curve lol
    tmp=tmp/max(tmp)
    the_dat=data.frame(y=tmp,x=sort(sample(n*10,n)/n/10),rep(paste0('model',i),n))
    dat=rbind(dat, the_dat)
}
colnames(dat)=c('y','x','model')

the_palette=p_jco[1:5]
names(the_palette)=unique(dat[,'model'])

p1=ggplot()+
    geom_line(dat,mapping=aes(x,y,color=model),linetype=1,alpha=0.9,size=0.5) +
    geom_segment(aes(x=0,xend=1,y=0,yend=1),linetype=2,color='grey') + # draw the diagonal baseline
    scale_colour_manual(values=the_palette) +
    xlim(0,1) +
    ylim(0,1) +
    theme_light() +
    labs(x='false postive rate',y='true positive rate',title='AUROC') +
#    theme(legend.position="none") +
    theme(plot.title = element_text(hjust = 0.5,size=18))+
    theme(axis.title.x = element_text(colour="black", size=15))+
    theme(axis.title.y = element_text(colour="black", size=15))+
    theme(axis.text.x = element_text(colour="black", size=15))+
    theme(axis.text.y = element_text(colour="black",size=15))+
    annotate('text', x = 0.8, y= seq(0.1,0.3,0.05), label=paste0('model',5:1,' : ',seq(0.51,0.71,0.05)), color='black', size=5)
p1

png(filename="figure/roc_curve.png",width=10,height=8,units='in',res=300) # unit inch
p1
dev.off()


