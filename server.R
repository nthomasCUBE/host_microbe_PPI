library(d3heatmap)
library(shiny)
library(shinyalert)
library(shinyBS)
library(shinyjs)
library(shinythemes)

server <- function(input, output, session)
{
	v <- reactiveValues(file1=NULL, itr=NULL, file2=NULL, file3=NULL, interactome=NA,microbe_host_interactions=NA)
	
	run_go_button=function(){
		print("server::goButton::observe")
		source("methods.R")
		if(!is.null(v$file1) & !is.null(v$file2) & !is.null(v$file3)){

			print("server::file1::not_null")
			print("server::file2::not_null")
			print("server::file3::not_null")
			interactome_analysis(v$file1,v$file2,v$file3,v)
			output$plot <- renderPlot({
				source("methods.R")
				make_pie(v)
			})
			appendTab(inputId = "tabset",
				tabPanel("Simulation", 			
				numericInput("itr", "Amount of iterations:", 1000, min = 100, max = 100000),
				verbatimTextOutput("value"),
				fileInput("file6", "Second inter-species PPI", multiple=TRUE, accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
				isolate(actionButton("bSimulation", "Simulation"))
			))
			appendTab(inputId = "tabset",
				tabPanel("Centrality", 			
				radioButtons("bCentralityNorm","Normalisation",c("Normalized"="normalize","Raw"="raw")),
				isolate(actionButton("bCentrality", "Centrality"))
			))
			appendTab(inputId = "tabset",
				tabPanel("Orthology", 			
				 radioButtons("orthoOptions", "Options:",
				               c("Intraspecies PPI" = "intra",
				                 "Interspecies PPI" = "inter")),
				isolate(actionButton("bOrthology", "Orthology"))
			))
		}

	}
	
	observeEvent(input$goButton,{
		run_go_button()
	})

	observeEvent(input$orthoOptions,{
		v$orthoOptions=input$orthoOptions
	})
	
	observeEvent(input$itr,{
		v$itr=input$itr		
	})

	observeEvent(input$bSimulation,{
		output$plot <- renderPlot({
			print("server::bSimulation::create")
			source("methods.R")
			do_bSimulation(v)
		})
	})

	observeEvent(input$bCentrality,{
		output$plot <- renderPlot({
			print("server::bCentrality::create")
			source("methods.R")
			my_table=do_bCentrality(v)
			output$table <- renderDataTable(my_table,
				options = list(
				  pageLength = 5
				)
			)
		})
	})
	
	observeEvent(input$simulation,{
		output$plot <- renderPlot({
			print("server::plot::create")
			source("methods.R")
			do_simulation(v)
		})
	})

	observeEvent(input$file1,{
		print(paste0("info|file1|",input$file1$datapath))
		v$file1=input$file1$datapath
	})

	observeEvent(input$file2,{
		print(paste0("info|file2|",input$file2$datapath))
		v$file2=input$file2$datapath
	})

	observeEvent(input$file3,{
		print(paste0("info|file3|",input$file3$datapath))
		v$file3=input$file3$datapath
	})

	observeEvent(input$file4,{
		print(paste0("info|file4|",input$file4$datapath))
		v$file4=input$file4$datapath
	})

	observeEvent(input$file5,{
		print(paste0("info|file5|",input$file5$datapath))
		v$file5=input$file5$datapath
	})

	observeEvent(input$file6,{
		print(paste0("info|file6|",input$file6$datapath))
		v$file6=input$file6$datapath
	})


	observeEvent(input$bCentralityNorm,{
		print(paste0("info|bCentralityNorm|",input$file4$datapath))
		v$bCentralityNorm=input$bCentralityNorm
	})
	
	observeEvent(input$preload,{
		print("server::preload")
		source("methods.R")
		v$file1="arabidopsis/A.NIHMS316063-supplement-Table_S4.txt"
		v$file2="arabidopsis/B.interspecies_dataset1_Mukhtar_et_al_2009.txt"
		v$file3="arabidopsis/C.Search_Space_1.txt"
		v$file4="arabidopsis/D.CentralityMeasurements.txt"
		v$file5="arabidopsis/E.0_extract_arath.txt"
		shinyalert("Arabidopsis data has been added into host_microbe_PPI", type = "info")
		run_go_button()
	})

	observeEvent(input$preload2,{
		print("server::preload")
		source("methods.R")
		v$file1=""
		v$file2=""
		v$file3=""
		v$file4=""
	})

	observeEvent(input$bOrthology,{
		print("server::bOrthology")
		source("methods.R")
		my_ret=do_bOrthology(v)
		output$heatmap=my_ret[[1]]
		M=(my_ret[[2]])
		x=100.0*apply(M,2,sum)/dim(M)[1]
		output$plot <- renderPlot({
			print(barplot(x,ylim=c(0,100),col=2:(length(x)+1),ylab="% conserved orthologs"),ylim=c(0,100),ylab="% of total")
			abline(h=40,lty=2)
			abline(h=60,lty=3)
			abline(h=80,lty=4)
		})
	})
}
