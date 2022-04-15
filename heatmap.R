options(shiny.maxRequestSize = 10 * 1024^2)
library("ggplot2") 
library("ggfortify")
library(pheatmap)
data<-na.omit(read.csv(file='/Users/sofia/Desktop/Test/d1_vs_d2_counts_normalized_relative_to_library_size.csv', header = TRUE))
#datamatrix <- as.matrix(data[,2]) + as.matrix(data[,5:10])
#dataGene <- as.vector(data[,2])
#dataGene
#matrice<-d
#datashort<- datamatrix[1:20,]
#datashort
#heatmap(datashort,Colv=NA, scale="column")
vars<- c("gene_external_name","n1_d1", "n2_d1","n3_d1","n1_d2","n2_d2", "n3_d2")

datafinal <- data.matrix(data[vars])
#datafinal<-data[vars]
datafinal <- datafinal[1:20,]
head(datafinal,n=3)
#data <- read.delim(datafinal, header=T, row.names ="external_gene_name" )
View(datafinal)
is.infinite(datafinal)
#dataFinal<-data[,2] + data[,5:10]
heatmap(datafinal, scale="row")
