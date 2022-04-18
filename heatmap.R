options(shiny.maxRequestSize = 10 * 1024^2)
library("ggplot2") 
library("ggfortify")
library(pheatmap)
data<-na.omit(read.csv(file='/Users/sofia/Desktop/Test/d1_vs_d2_counts_normalized_relative_to_library_size.csv', header = TRUE))
#View(data)
#data<-subset(data,data$pvalue<0.001)

vars<- c("external_gene_name","n1_d1", "n2_d1","n3_d1","n1_d2","n2_d2", "n3_d2","pvalue")
datafinal<-data[vars]
rownames(datafinal)<-make.names(datafinal$external_gene_name, unique=TRUE)
datafinal<-subset(datafinal,datafinal$pvalue<0.001)
View(datafinal)
datafinal<-data.matrix(datafinal[,2:7])
View(datafinal)
#datafinal<-data.matrix(datafinal[,2:7])
#datafinal<-datafinal[,2:8]
#datafinal<-subset(datafinal,datafinal$pvalue<0.001)
#datafinal<-datafinal[,1:6]
#View(datafinal)

#colnames(datafinal)<-data["external_gene_name"]
#datafinal<-data[vars]
#datafinal <- datafinal[1:20,]
#head(datafinal,n=3)
#data <- read.delim(datafinal, header=T, row.names ="external_gene_name" )
#View(datafinal)
#is.infinite(datafinal)
#dataFinal<-data[,2] + data[,5:10]
heatmap(datafinal, scale="row")

