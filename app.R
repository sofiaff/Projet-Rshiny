options(shiny.maxRequestSize = 10 * 1024^2)
library("ggplot2") 
library("ggfortify")
shinyApp(
  ui = tagList(
    #shinythemes::themeSelector(),
    navbarPage("Projet BIF7104",
      # theme = "cerulean",  # <--- To use a theme, uncomment this
      #"shinythemes",
      tabPanel("Table de données",
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
                 #sliderInput("pvalue_threshold",
                            # "Set significance threshold",
                            # min = 1,
                             #max = 50,
                            # value = .05),
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
               plotOutput("PCAPlot")
      ),
      tabPanel("Heatmap",
             h4("Heatmap"),
             plotOutput("HeatmapPlot"),
             sliderInput("p_value",
                         "Set pvalue target",
                         min = 0,
                         max = 1,
                         value = 0,01),
      ),
      tabPanel("Gene Ontology",
             h4("Gene"),
             plotOutput('Gene plot')
     
      ),
    )
  ),
  server = function(input, output) {
    output$table <- renderDataTable({
      file <- input$file1
      read.csv(file$datapath, header = input$header)
    })
    output$volcano_plot <- renderPlot({
      file<- input$file1
      cleanfile<-na.omit(read.csv(file$datapath, header = input$header))
      ggplot(data=cleanfile, aes(x=log2FoldChange, y=-log10(pvalue), colour = -log10(pvalue)>input$h_treshold), label=external_gene_name) + 
        geom_point() + 
        theme_minimal()+
        ylim(0,input$p_value_axis)+
        scale_color_manual(values=c("Blue", "red")) +
        geom_hline(yintercept=input$h_treshold, col="red")+
        geom_text(aes(label=ifelse(-log10(pvalue)>input$h_treshold,as.character(external_gene_name),'')),hjust=0,vjust=0)
    })
    output$PCAPlot <- renderPlot({
      file<- input$file1
      data<-na.omit(read.csv(file$datapath, header = input$header))
      pca<-prcomp(data[,5:10])
      autoplot(pca)
    })
    output$Heatmap <- renderPlot({
      file<- input$file1
      data<-na.omit(read.csv(file$datapath, header = input$header))
      datamatrix <- as.matrix(data[,5:10])
      
    })
  }
)