# host_microbe_PPI

host_microbe_PPI is a tool that allows for **compare interspecies protein-protein interaction** data of *Arabidopsis thaliana* 
with other microbes against the interactome of protein-protein interaction *Arabidopsis thaliana*.
Even so the demo data is using *A.thaliana*, it can be also used for other species where intra- and inter-species PPI
is available.
It allows to compare interspecies PPI to the simulation, allows to analyse the conservatio of orthologs if available
and allows to compare centrality measurements between intra- and inter-species PPI datasets.

Data was integrated from various resources such as the [Interactome](http://science.sciencemag.org/content/333/6042/601), [Pseudomonas/Hyaloperonospora arabopsidis - A.thaliana Y2H](http://science.sciencemag.org/content/333/6042/596)
as well as [Golovinomyces orontii - A.thaliana Y2H](https://www.sciencedirect.com/science/article/pii/S1931312814002960).

![host_microbe_PPI](https://github.com/nthomasCUBE/host_microbe_PPI/blob/master/pix/figure-github.png)

## Installation and start

**In order to execute host_microbe_PPI you need to install following R packages:**
```
library(d3heatmap)
library(gplots)
library(scales)
library(shiny)
library(shinyalert)
library(shinyBS)
library(shinyjs)
library(shinythemes)
library(xlsx)
```

**If the packages are installed, it can be executed via**

```
library("ui.R)
library("methods.R")
library("source.R")
shinyApp(ui,server)
```
