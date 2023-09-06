# API app -----------------------------------------------------------------

# Shiny App for providing data input to cars plumber API
library(shiny)
library(httr)

# base_url <- config::get("base_url")

base_url <- "localhost:5112"

ui <- fluidPage(
  
  # Application title
  titlePanel("Cars MPG Predictor"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("hp",
                  "Horsepower",
                  min = min(mtcars$hp),
                  max = max(mtcars$hp),
                  value = median(mtcars$hp)),
      selectInput("cyl",
                  "Cylinder",
                  choices = sort(unique(mtcars$cyl)),
                  selected = sort(unique(mtcars$cyl))[1]),
      fluidRow(
        actionButton("add",
                     "Add"),
        actionButton("remove",
                     "Remove"),
        actionButton("predict",
                     "Predict")
      )
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tableOutput("data"),
      wellPanel(
        textOutput("raw_results")
      )
    )
  )
)

server <- function(input, output) {
  # Create reactive_values
  reactive_values <- reactiveValues(data = data.frame(),
                                    predicted_values = NULL)
  
  # Update user data
  observeEvent(input$add, {
    # Reset predicted_values
    reactive_values$predicted_values <- NULL
    
    # Add to data
    data <- reactive_values$data
    # Remove predicted column if present
    reactive_values$data <- rbind(data[!names(data) %in% "predicted_mpg"],
                                  data.frame(hp = as.numeric(input$hp), cyl = as.numeric(input$cyl)))
  })
  
  observeEvent(input$remove, {
    # Reset predicted_values
    reactive_values$predicted_values <- NULL
    
    # Set aside existing data
    data <- reactive_values$data
    
    # Remove rows that match current input
    reactive_values$data <- dplyr::anti_join(data[!names(data) %in% "predicted_mpg"],
                                             data.frame(hp = as.numeric(input$hp), cyl = as.numeric(input$cyl)))
  })
  
  observeEvent(input$predict, {
    # Make API request
    api_res <- httr::POST(url = paste0(base_url, "/predict"),
                          body = reactive_values$data,
                          encode = "json")
    
    # Extract JSON from API response
    reactive_values$predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
    
    # Add predicted values to data
    if (!"predicted_mpg" %in% names(reactive_values$data)) {
      reactive_values$data <- cbind(reactive_values$data, 
                                    predicted_mpg = as.numeric(jsonlite::fromJSON(reactive_values$predicted_values)))
    }
  })
  
  output$data <- renderTable(reactive_values$data)
  output$raw_results <- renderPrint({
    if (is.null(reactive_values$predicted_values)) {
      "No predictions"
    } else {
      jsonlite::prettify(reactive_values$predicted_values)
    }
  })
}

shinyApp(ui = ui, server = server)