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
                 sliderInput("pvalue_threshold",
                             "Set significance threshold",
                             min = 0,
                             max = 5,
                             value = .05),
               )
      ),
      
      tabPanel("PCA", 
               h4("PCA plot"),
               plotOutput("PCAPlot")
      ),
      tabPanel("Heatmap",
             h4("Heatmap"),
             plotOutput("HeatmapPlot")
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
      ggplot(data=cleanfile, aes(x=log2FoldChange, y=-log10(pvalue))) + 
        geom_point() + 
        theme_minimal()+
        scale_color_manual(values=c("blue", "black", "red")) +
        geom_vline(xintercept=c(-input$pvalue_threshold, input$pvalue_threshold), col="red") +
        geom_hline(yintercept=-log10(0.05), col="red")
    })
    output$PCAPlot <- renderPlot({
      file<- input$file1
      data<-na.omit(read.csv(file$datapath, header = input$header))
      pca<-prcomp(data[,5:10])
      autoplot(pca)
    })
  }
)