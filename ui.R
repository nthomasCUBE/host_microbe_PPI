library(shiny)
library(shinyalert)
library(shinyBS)
library(shinyjs)
library(shinythemes)

options(shiny.maxRequestSize = 50*1024^2)

ui <- fluidPage(  

  tags$head(
    tags$style(HTML("
      .shiny-output-error {
        visibility: hidden;
      }
       body {
              background-color: #23443333;
          }
      
          body, label, input, button, select { 
            font-family: 'Arial';
    }
    "))
  ), 
  theme = shinytheme("united"),  useShinyjs(), useShinyalert(), 
	sidebarLayout(
		sidebarPanel(
		tabsetPanel(id = "tabset",
		tabPanel("Analysis of protein-protein data",
			fileInput("file1", "Choose inter-species protein-protein data", multiple = TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
			fileInput("file2", "Choose intra-species protein-protein data", multiple = TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
			actionButton("goButton", "Analyse dataset!")
		)
		)
		),
		mainPanel(
			useShinyjs(),
			plotOutput(outputId = "plot", height="50%", width = "50%"),
			dataTableOutput('table')
		)
	)
)