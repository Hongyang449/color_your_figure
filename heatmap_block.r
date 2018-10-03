
name: heatmap_block.r

library(ggplot2)

# generate a data frame with three columns: x, y, name (e.g. cell line)
set.seed(449)
dat=data.frame(gene=rep(paste0("gene",0:9),each=10),
    id=rep(paste0("id",0:9),10),
    value=rnorm(100,0.5,0.3)) # rnorm to generate some random numbers
#    gene  id     value
#1  gene0 id0 0.3663519
#2  gene0 id1 0.8200528
#3  gene0 id2 0.2844916


p=ggplot(dat, aes(id, gene)) +
    geom_tile(aes(fill = value), colour = "white") + # colour: color of the grid
    scale_fill_gradient(low = "white", high = "red") +
    theme_light() +
    theme(axis.line.x = element_line(color="black", size=0.5)) + # customize the font of y-axis (you can use the default)
    theme(axis.line.y = element_line(color="black", size=0.5)) +
    theme(axis.title.x = element_text(colour="black", size=12)) +
    theme(axis.title.y = element_text(colour="black", size=12)) +
    theme(axis.text.x = element_text(colour="black",size=12, angle=45, hjust=1)) + # rotate x-axis label by 45 degree
    theme(axis.text.y = element_text(colour="black",size=12)) +
    theme(plot.title = element_text(hjust = 0.5)) + # hjust=0.5 set the title in the center
    labs(x='Your X Title',y='Your Y Title',title='Your Figure Title') + # customize titles
        coord_equal() # draw square tiles

png(filename="figure/heatmap_block.png",width=9,height=8,units='in',res=300) # unit inch
p
dev.off()


