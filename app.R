options(shiny.maxRequestSize = 10 * 1024^2)
library("ggplot2") 
library("ggfortify")
library("gprofiler2")
library("ggrepel")
shinyApp(
  ui = tagList(
    #shinythemes::themeSelector(),
    navbarPage("Projet BIF7104",
      # theme = "cerulean",  # <--- To use a theme, uncomment this
      #"shinythemes",
      tabPanel("Data Table",
               h4("Table"),
               dataTableOutput("table"),
               sidebarPanel(
                 fileInput("file1", "Choose CSV File", accept = ".csv"),
                 checkboxInput("header", "Header", TRUE),
               )
      ),
      tabPanel("Volcano Plot",
               h4("Volcano Plot"),
               plotOutput("volcano_plot",
                          width = "70%",
                          height = "600px",
                          hover = "volcano_hover",
                          click = "volcano_click",
                          dblclick = "volcano_dbl_click",
                          brush = brushOpts(
                            id = "volcano_brush",
                            resetOnNew = TRUE)),
               sidebarPanel(
                 sliderInput("p_value_axis",
                             "Set pvalue axis",
                             min = 0,
                             max = 100,
                             value = 50),
                 sliderInput("h_treshold",
                             "Set pvalue treshold",
                             min = 0,
                             max = 50,
                             value = 10),
               )
      ),
      
      tabPanel("PCA", 
               h4("PCA plot"),
               plotOutput("PCAPlot"),
               textInput("titre","Diagram title:",value="")
      ),
      tabPanel("Heatmap",
             h4("Heatmap"),
             plotOutput("HeatmapPlot",
                        width = "80%",
                        height = "600px",),
             sliderInput("p_value",
                         "Set pvalue target",
                         min = 0,
                         max = 0.05,
                         value = 0.005,
                         step = 0.0001),
             textInput("titreHeatmap","Diagram title:",value=""),
      ),
      tabPanel("Gene Ontology",
             h4("Gene Ontology"),
             uiOutput('GenePlot'),
             selectInput("specie", "Species", c("hsapiens","mmusculus")),
             uiOutput("var_ui")
      ),
      tabPanel("Gene Ontology Table",
               h4("Gene Ontology Table"),
               plotOutput('GeneTable',
                          width = "100%",),
      ),
    )
  ),
  server = function(input, output) {
    
    myfile<- reactive({
      mydata<-input$file1
      cleanfile<-na.omit(read.csv(mydata$datapath, header = input$header))
    })
    
    output$table <- renderDataTable({
      #file <- input$file1
      #read.csv(file$datapath, header = input$header)
      myfile()
    })
    output$volcano_plot <- renderPlot({
      #file<- input$file1
      #cleanfile<-na.omit(read.csv(file$datapath, header = input$header))
      ggplot(data=myfile(), aes(x=log2FoldChange, y=-log10(pvalue), colour = -log10(pvalue)>input$h_treshold), label=external_gene_name) + 
        geom_point() + 
        #geom_text_repel( max.overlaps = getOption("ggrepel.max.overlaps", default = 20))+
        theme_minimal()+
        ylim(0,input$p_value_axis)+
        scale_color_manual(values=c("Blue", "red")) +
        geom_hline(yintercept=input$h_treshold, col="red")+
        geom_text(aes(label=ifelse(-log10(pvalue)>input$h_treshold,as.character(external_gene_name),'')),hjust=0,vjust=0)
      })
    output$PCAPlot <- renderPlot({
      file<- input$file1
      data<-na.omit(read.csv(file$datapath, header = input$header))
      data <- data.frame(data)
      data_cts <- na.omit(data[,(5:10)])
      datafinale <- t(data_cts)
      z <- datafinale[ , which(apply(datafinale, 2, var) != 0)]
      pcaB<-prcomp(z, center = TRUE, scale. = TRUE)
      pcaB.var<-pcaB$sdev^2
      pcaB.var.per <- round(pcaB.var/sum(pcaB.var)*100, 1)
      pcaB.data <- data.frame(Sample= rownames(pcaB$x), X=pcaB$x[,1], Y=pcaB$x[,2])
      ggplot(data= pcaB.data, mapping= aes(x=X, y=Y, label=Sample), shape= sample)+
        geom_point(shape=18, color= "#00AFBB")+
        geom_text_repel( max.overlaps = getOption("ggrepel.max.overlaps", default = 20))+
        xlab(paste("PC1 - ", pcaB.var.per[1],"%", sep="")) + 
        ylab(paste("PC2 - ", pcaB.var.per[2],"%", sep="")) +
        theme_bw() +
        ggtitle(input$titre) +
        theme(plot.title = element_text(hjust = 0.5))
    })
    output$HeatmapPlot <- renderPlot({
      file<- input$file1
      data<-na.omit(read.csv(file$datapath, header = input$header))
      vars<- c("external_gene_name","n1_d1", "n2_d1","n3_d1","n1_d2","n2_d2", "n3_d2","pvalue")
      datafinal<-data[vars]
      rownames(datafinal)<-make.names(datafinal$external_gene_name, unique=TRUE)
      datafinal<-subset(datafinal,datafinal$pvalue<input$p_value)
      datafinal<-data.matrix(datafinal[,2:7])
      heatmap(datafinal, scale="row", main=input$titreHeatmap)
      
    })
    output$var_ui <- renderUI({
      vars<- c("external_gene_name","ensembl_gene_id")
      datafinal<-myfile()[vars]
      databis<-datafinal[,1]
      selectInput("var", "choose variable:", choices=databis, multiple=TRUE)
    })
    output$GenePlot <- renderUI({
      gostres <- gost(query = list(c(input$var),
                                   organism = input$specie))
      names(gostres)
      gostres
      gostplot(gostres, capped = TRUE, interactive = TRUE)
    })
    output$GeneTable <- renderPlot({
      gostres <- gost(query = list(c(input$var),
                                   organism = input$specie))
      publish_gosttable(
        gostres,
        highlight_terms = NULL,
        use_colors = TRUE,
        show_columns = c("source", "term_name", "term_size", "intersection_size"),
        filename = NULL,
        ggplot = TRUE
      )
    })
  }
)