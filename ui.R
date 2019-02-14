library(d3heatmap)
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
	#background-color: #23443333;
}
body, label, input, button, select { 
	font-family: 'Arial';
}"))
  ), 
  theme = shinytheme("united"),  useShinyjs(), useShinyalert(), 
	sidebarLayout(
		sidebarPanel(
		tabsetPanel(id = "tabset",
		tabPanel("Analysis of protein-protein data",
			fileInput("file1", "A.Inter-species protein-protein data (required)", multiple = TRUE, accept = c("text/text", ".txt")),
			fileInput("file2", "B.Intra-species protein-protein data (required)", multiple = TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
			fileInput("file3", "C.Search space (required)", multiple=TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
			fileInput("file4", "D.Centrality Measurements (optional)", multiple=TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
			fileInput("file5", "E.Orthologous groups (optinal)", multiple=TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
			actionButton("preload", "Preload Arabidopsis thaliana!"),
			actionButton("goButton", "Analyse dataset!")
		)
		)
		),
		mainPanel(
			useShinyjs(),
			plotOutput(outputId = "plot"),
			dataTableOutput('table'),
			d3heatmapOutput("heatmap", width = "75%", height="300px")
		)
	)
)