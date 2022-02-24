options(shiny.maxRequestSize = 10 * 1024^2)
library(shiny)
ui <- fluidPage(
  fileInput("upload", NULL, accept = c(".csv", ".tsv")),
  numericInput("n", "Number of Rows you want to display", value = 5, min = 1, step = 1),
  tableOutput("head")
)

server <- function(input, output, session) {
  data <- reactive({
    req(input$upload)
    
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           csv = vroom::vroom(input$upload$datapath, delim = ","),
           tsv = vroom::vroom(input$upload$datapath, delim = "\t"),
           validate("Invalid file; Please upload a .csv or .tsv file")
    )
  })
  
  output$head <- renderTable({
    head(data(), input$n)
  })
}
shinyApp(ui, server)