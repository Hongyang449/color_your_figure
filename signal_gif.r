
library(ggplot2)
library(reshape2)
set.seed(449)

## simulate trigonometric signals
d1=250
d2=14
tmp=NULL
for(i in 1:7){
    tmp=c(tmp,sin(seq(2*pi/d1,2*pi,2*pi/d1)*i),cos(seq(2*pi/d1,2*pi,2*pi/d1)*i))
}
x=data.frame(matrix(tmp, nrow=d1, byrow=F))
# add some Gaussian noises
x=x + rnorm(length(x),mean=0,sd=0.05)
# normalize channels
ind=abs(x[,1])>0.7
x[ind,1]=1; x[!ind,1]=0 # binarize
for(i in 2:d2){ # normalize to 0-1
    x[,i]=(x[,i]-min(x[,i])) / (max(x[,i]) - min(x[,i]))
}
# channel name
colnames(x)=paste0("channel_",sprintf("%02d",1:14)) # format number - sprintf
rownames(x)=1:d1


l=nrow(x) # total length
window=50 # the length of smooth color-transition regions
slide=1 # 

dat=melt(x)
dat=cbind(x=rep(1:d1,d2)/5,dat,channel=rep(seq(1,d2*window-1,window),each=d1))

label1=c("Sleep (zZ)","cos(x)","sin(2x)","cos(2x)","sin(3x)","cos(3x)","sin(4x)",
    "cos(4x)","sin(5x)","cos(5x)","sin(6x)","cos(6x)","sin(7x)","cos(7x)")
label2=c("Arousal (!!)","cos(x)","sin(2x)","cos(2x)","sin(3x)","cos(3x)","sin(4x)",
    "cos(4x)","sin(5x)","cos(5x)","sin(6x)","cos(6x)","sin(7x)","cos(7x)")

col_multi=c(
    "#616161","#FFFFFF",
    "#006064","#18FFFF",
    "#1A237E","#BBDEFB",
    "#E65100","#FFFF8D",
    "#004D40","#A7FFEB",
    "#311B92","#D1C4E9",
    "#3E2723","#EFEBE9",
    "#37474F","#ECEFF1",
    "#1B5E20","#CCFF90",
    "#880E4F","#FF80AB",
    "#F57F17","#FFFF00",
    "#B71C1C","#FF8A80",
    "#827717","#F0F4C3",
    "#4A148C","#EA80FC")

# non-overlapping regions for coloring different channels
loc=1:28
loc[c(1,seq(2,28,2),seq(3,28,2))]=c(0,(1:14)*window-0.5,(1:13)*window+0.5)

system("mkdir -p png")
for(i in seq(1,(l-window+1),slide)){
    print(i)
    first=i
    last=i+window-2
    dat1=dat[rep(seq(0,nrow(dat)-1,d1),each=last) + rep(1:last,d2),]
    ind=rep(seq(0,nrow(dat1)-1,last),each=window-1) + rep(first:last,d2)
    dat1[ind,"channel"]=dat1[ind,"channel"]+rep(1:(window-1)-1,by=d2)

    # label & color for sleep or arousal
    if(dat1[last,"value"]==0){ 
        tmp_label=label1
        tmp_col="grey80"
        }else{
        tmp_label=label2
        tmp_col=c("#FFFF8D",rep("grey80",13))
    }

    p1=ggplot(dat1, aes(x, value,colour=channel)) + 
        geom_line(size=1) + 
        facet_grid(variable ~ .) + # multi-panel
        scale_colour_gradientn(colours=col_multi, # multiple gradient colors (instead of 1)!
            values   = loc,
            #breaks   = c(-0.05,-0.005,0.005,0.05),
            rescaler = function(x,...) x,
            oob      = identity) +
        xlim(-1,50) +
        theme_light() +
        labs(title="arousal example",x="time(s)",y="signal strength") +
        theme(strip.background = element_blank(), # facet label
            strip.text.x = element_blank(), # facet strip
            axis.text.y=element_blank(),
            axis.ticks.y=element_blank(),
            axis.title.y=element_blank(),
            panel.background = element_rect(fill = "black"), # backgroud color
            panel.grid.major = element_blank(), # grid
            panel.grid.minor = element_blank(),
            panel.spacing = unit(0,"lines"), # spacing between panels
            panel.border = element_rect(color = "black"),
            plot.title = element_text(hjust = 0.5),
            legend.position="none") + # legend
        annotate("text", x = -1, y = 0.8, label=tmp_label, color=tmp_col,size=5)
    #p1
    png(filename=paste0("./png/",sprintf("%04d",i),".png"),width=960,height=640)
    print(p1)
    dev.off()
}

# generate gif; real    0m28.570s
# 100/delay = frames per second
system("time convert -delay 2 -loop 0 png/*.png trigonometry.gif") 

