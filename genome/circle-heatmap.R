#install.packages("circlize")
#install.packages("devtools")
#install.packages("ComplexHeatmap")
#install_github("jokergoo/ComplexHeatmap")



library(devtools)
library(circlize)
library(ComplexHeatmap)

setwd("home/pectin")
rm(list=ls())

#-------------group heatmap------------------------------
mydata <- read.table("test.txt",row.names=1,sep = "\t",header = T)
cluster=c(rep("7-Bi",time=65),
          rep("6-Ga",time=192))
#rep("5-LF4",time=16),
#rep("4-LF5",time=51),
#rep("3-LKki",time=17),
#rep("2-Snod",time=73),
#rep("1-Bar",time=28))
#Numbers are added here to sort the names, otherwise they are sorted alphabetically.
split=factor(cluster)
#-------------Set the starting Angle and group spacing------------------------------
circos.par(start.degree = 75, gap.degree = 1)
circos.par(gap.after = c(5,15))
#circos.heatmap.initialize(mydata, split = split,cluster = FALSE)
#draw circoheatmap
#-------------Draw column annotation--------------------------
#first draw this.
species <- read.table("test_annotation.txt",row.names=1,sep = "\t",header = T)
col_species = colorRamp2(c(1,2,3,4,41,42,43,44),
                         c("#BFBFFF","#B2ABD2","#C2A5CF",
                           "#9970AB","#FFEA46","#E08214",
                           "#F6E8C3","#FDB863"#,"#F4A582",
                           #"#F46D43","#92C5DE","#80CDC1",
                           #"#4393C3","#3288BD","#FF7F7F",
                           #"#FFBFBF","#F1B6DA","#B8E186"
                         )
)

circos.heatmap(species, col = col_species,split=split,
               show.sector.labels = TRUE,cluster = FALSE,
               track.height = 0.05
               #,colnames(),#,rownames.cex =0.2,bg.border ="white" ,rownames.side = "outside"
)
#So you can skip this sentence here and go ahead and draw, just inside this picture.
circos.clear()

#-------------draw heatmap------------------------------
col_gene = colorRamp2(c(0,1), c("#F5F5F5","#9F9F9F"))
circos.heatmap(mydata, col = col_gene,split=split,cell.border = "white",
               #show.sector.labels = TRUE,
               cluster = FALSE,
               track.height = 0.4,
               #bg.border ="black"
               #rownames.cex =0.3,rownames.side = "outside"
)
circos.clear()#For redrawing at any time

circos.track(
  track.index = get.current.track.index(), 
  panel.fun = function(x, y) {
    if (CELL_META$sector.numeric.index == 7) {
      # Add in the last sector
      cn = colnames(mydata)
      n = length(cn)
      circos.text(
        rep(CELL_META$cell.xlim[2], n) + convert_x(1, "mm"),
        n:1 - 0.5, cn, cex = 0.6, adj = c(0, 0.5),
        facing = "inside"
      )
    }
  }, 
  bg.border = NA
)



#----------------draw legend-----------------------------------------

lgd_genes <- Legend(
  title = "GalA genes",
  labels = c("Absence","Presence"),
  legend_gp = gpar(fill=c("#F5F5F5","#9F9F9F"))
)
#grid.draw(lgd_genes)

lgd_clster <- Legend(
  title = "host", 
  labels = c("Bi_Am","Bi_Ac","Bi_Bom","Bi_XYL","Ga_Ac","Ga_Am","Ga_Bom","Ga_Ador"
             #,"LF4_Am","LF4_Bom","Lkki","LF5_Ac","F5_Am","F5_Bom","Sn_Ac","Sn_Am","Sn_Bom","Bar_Am"
  ),
  legend_gp = gpar(fill=c("#BFBFFF","#B2ABD2","#C2A5CF",
                          "#9970AB","#FFEA46","#E08214",
                          "#F6E8C3","#FDB863"#,"#F4A582",
                          #"#F46D43","#92C5DE","#80CDC1",
                          #"#4393C3","#3288BD","#FF7F7F","#FFBFBF",
                          #"#F1B6DA","#B8E186"
  ))
  
)
lgd_list = packLegend(lgd_clster,lgd_genes,direction = "horizontal",gap=unit(1,"cm"))

#circlize_plot()
# next the grid graphics are added directly to the plot
# where circlize has created
draw(lgd_list, x = unit(0.5, "npc"), y = unit(0.5, "npc"))
#When manually saving pdf, select 8x8inch. After output, it is 20x20cm

circos.clear()#Be sure to add this to indicate that the heat map is complete

