library(xlsx)

options(stringsAsFactors=FALSE)

interactome_analysis=function(cur_f, host_microbe, search_space_1, v){
	print("methods:interactome_analysis")
	data=read.csv(cur_f,sep="\t",header=T)
	my_interactome=subset(data,data[,3]==1 | data[,4]==1)

	data_F=subset(data,data[,3]==1 | data[,4]==1)
	d_prot=c(data_F[,1],data_F[,2])
	d_prot=unique(sort(d_prot))
	v$interactome=my_interactome

	data=read.csv(host_microbe,sep="\t",header=T)
	v$microbe_host_interactions=data
	print(paste0("microbe_host_interactions=",length(v$microbe_host_interactions)))

	data2=read.csv(search_space_1,sep="\t",header=T)
	v$search_space_1=data2[,2]
	print(paste0("search_space_1=",length(v$microbe_host_interactions)))

	shinyalert(paste(dim(my_interactome)[1]," interactions loaded from the INTERACTOME and ",dim(data)[1],"interactions loaded from the HOST-MICROBE interactions and search space contains",dim(data2)[1]), type = "info")
}

do_simulation=function(v){
	
	print(v$interactome)
	hist(c(1,2,2,2,3,3,3),main="Simulation")
}


