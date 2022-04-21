library(tidyverse)
library(dplyr)
library(ggplot2)


#import file
DeTEST <- read.csv("/Users/myriamennajimi/Desktop/MYRIAM_Projet_Rshiny/d1_vs_d2_counts_normalized_relative_to_library_size.csv",header = TRUE)


#générer data frame, transposer et exclure les valeurs qui ont pas de variance
data <- data.frame(DeTEST)
head(data, n=3)
data_cts <- na.omit(data[,(5:10)])
datafinale <- t(data_cts)
z <- datafinale[ , which(apply(datafinale, 2, var) != 0)]
head(datafinale, n=3)


#running Prcomp
pcaB<-prcomp(z, center = TRUE, scale. = TRUE)
pcaB.var<-pcaB$sdev^2
pcaB.var.per <- round(pcaB.var/sum(pcaB.var)*100, 1)
pcaB.data <- data.frame(Sample= rownames(pcaB$x), X=pcaB$x[,1], Y=pcaB$x[,2])

#générer plot
ggplot(data= pcaB.data, mapping= aes(x=X, y=Y, label=Sample), shape= sample)+
  geom_text(size=3)+
  xlab(paste("PC1 - ", pcaB.var.per[1],"%", sep="")) + 
  ylab(paste("PC2 - ", pcaB.var.per[2],"%", sep="")) +
  theme_bw() +
  ggtitle("Ajoutez input de titre") +
  theme(plot.title = element_text(hjust = 0.5))

#essai PCAgrid
#pcaC <- PcaGrid(pcab2)
#pcab2<-as.numeric(unlist(pcaB))