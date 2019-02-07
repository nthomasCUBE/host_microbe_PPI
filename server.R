library(shiny)
library(shinyalert)
library(shinyBS)
library(shinyjs)
library(shinythemes)

server <- function(input, output, session)
{
	v <- reactiveValues(interactome=NA,microbe_host_interactions=NA)
	
	observeEvent(input$goButton,{
		print("server::file1::observe")
		source("methods.R")
		if(!is.null(input$file1$datapath) & !is.null(input$file2$datapath)){
			print("server::file1::not_null")
			interactome_analysis(input$file1$datapath,input$file2$datapath,input$file3$datapath,v)
			output$plot <- renderPlot({
				print("server::plot::create")
				barplot(c(dim(v$interactome)[1],dim(v$microbe_host_interactions)[1]),names=c("interactome","host-microbe interactions"))	
			})
			appendTab(inputId = "tabset",
				tabPanel("Simulation", 			
				isolate(actionButton("bSimulation", "Simulation"))
			))
			appendTab(inputId = "tabset",
				tabPanel("Centrality", 			
				isolate(actionButton("bCentrality", "Centrality"))
			))
			appendTab(inputId = "tabset",
				tabPanel("Orthology", 			
				isolate(actionButton("bOrthology", "Orthology"))
			))
		}
	})

	observeEvent(input$simulation,{
		output$plot <- renderPlot({
			print("server::plot::create")
			source("methods.R")
			do_simulation(v)
		})
	})

	observeEvent(input$preload,{
		print("server::preload")
		source("methods.R")
		#input$file1$datapath="arabidopsis/NIHMS316063-supplement-Table_S4.txt"
	})
	
}
