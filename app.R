options(shiny.maxRequestSize = 10 * 1024^2)
library(ggplot2) 
shinyApp(
  ui = tagList(
    #shinythemes::themeSelector(),
    navbarPage(
      # theme = "cerulean",  # <--- To use a theme, uncomment this
      #"shinythemes",
      tabPanel("Projet BIF7104",
               sidebarPanel(
                 fileInput("file1", "Choose CSV File", accept = ".csv"),
                 checkboxInput("header", "Header", TRUE),
               ),
               mainPanel(
                 tabsetPanel(
                   tabPanel("Table de donnees",
                            h4("Table"),
                            dataTableOutput("table"),
                   ),
                   tabPanel("VolcanoPlot", 
                            h4("vulcano Plot"),
                            plotOutput("outputVulcano")
                            ),
                   tabPanel("Tab 3", "This panel is intentionally left blank")
                 )
               )
      ),
    )
  ),
  server = function(input, output) {
    output$table <- renderDataTable({
      file <- input$file1
      read.csv(file$datapath, header = input$header)
      #tmp<-read.csv(file$datapath, header = input$header)
    })
    output$outputVulcano <- renderPlot({
      file<- input$file1
      ggplot(data=read.csv(file$datapath, header = input$header), aes(x=log2FoldChange, y=-log10(pvalue))) + 
        geom_point() + 
        theme_minimal()+
        scale_color_manual(values=c("blue", "black", "red")) +
        geom_vline(xintercept=c(-0.6, 0.6), col="red") +
        geom_hline(yintercept=-log10(0.05), col="red")
    })
  }
)