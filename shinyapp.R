library(shiny)
library(tidyverse)
library(plotly)

## Input port argument
args <- commandArgs(trailingOnly=TRUE)
port <- as.numeric(args[[1]])

age_data <- read_csv("source_data/baker_results.csv")
age_data <- age_data %>%
    select(series, age)

## Define UI
ui <- fluidPage(
    
    titlePanel("Age Distribution of GBBO Contestants"),
    
    sidebarLayout(
        position = "right",
        sidebarPanel(
            radioButtons(
                inputId = "series",
                label = "Series",
                choices = 1:10
            ),
            sliderInput(
                inputId = "range",
                label = "Age Range",
                min = 0,
                max = 100,
                value = c(0, 100)
            )
        ),
        
        mainPanel(
            
            plotlyOutput(outputId = "age_dist")
            
        )
    )
    
)

## Define server
server <- function(input, output){
    output$age_dist <- renderPlotly({
        s <- input$series
        series_data <- age_data %>% 
            filter(series == s)
        ggplotly(ggplot(series_data, aes(age)) +
                            geom_histogram(bins = nrow(series_data),
                                           fill = "#f8d6b8") +
                            xlim(c(input$range[1], input$range[2])) +
                            theme_minimal())
            
    })
    
}

## Run
shinyApp(ui = ui, server = server, options = list(port = port,
                                                  host = "0.0.0.0"))
