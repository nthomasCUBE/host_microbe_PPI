library(d3heatmap)
library(scales)
library(xlsx)
library(gplots)

options(stringsAsFactors=FALSE)

make_pie=function(v){
	A=unique(c(v$interactome[,1],v$interactome[,2]))
	A=length(unique(A))

	B=(unique(v$microbe_host_interactions[,2]))
	B=B[seq(1,length(B),2)]
	B=length(B)
	AB=A[B%in%A]
	pie(c(A-length(AB),B),labels=c(paste("interactom",paste0("(",A,")")),paste("host-microbe interactions",paste0("(",B,")"))),cex=2,col=c("#128289","383899"))
}

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

do_bCentrality=function(v){
	print(paste0("INFO|do_bCentrality"))
	data=read.csv(v$file4,sep="\t",header=T,dec=",")
	my_genes=v$microbe_host_interactions[,2]
	my_genes=my_genes[seq(1,length(my_genes),2)]
	#boxplot(log(data[,c(4,5,6,7)]),outline=F)
	ix=which(my_genes%in%data[,"name"])
	par(mfrow=c(1,2))
	if(v$bCentralityNorm=="normalize"){
		for(x in 4:6){
			dd=data[,x]
			dd=dd[!is.na(dd)]
			dd=(data[,x]-mean(dd))/(sd(dd))
			data[,x]=dd
		}
	}
	boxplot((data[-ix,c(4,5,6)]),col=2:4,outline=F,main="interactome (excl. intraspecies PPI)")
	boxplot((data[ix,c(4,5,6)]),col=2:4,outline=F,main="intraspecies PPI - host proteins")
	df=data.frame()
	for(x in 4:6){
		A=data[-ix,x]
		B=data[ix,x]
		A=A[!is.na(A)]
		B=B[!is.na(B)]
		wp=wilcox.test(A,B)$p.value
		df=rbind(df,c(colnames(data)[x],round(median(A),2),round(median(B),2),scientific(wp)))
	}
	colnames(df)=c("measurement","all-interspecies target","interspecies targets","p.value wilcox.test")
	return(df)
}

do_bSimulation=function(v){
	my_genes=v$search_space_1
	my_genes=unique(my_genes)
	N=length(v$microbe_host_interactions[,2])
	N_d=length(unique(v$microbe_host_interactions[,2]))
	INTER1=unique(v$microbe_host_interactions[,2])
	INTER1=INTER1[seq(1,length(INTER1),2)]
	obs=c()
	for(i in 1:v$itr){
		el=sample(1:length(my_genes),N,replace=TRUE)
		el=length(unique(el))
		obs=c(obs,el)
	}
	if(!is.null(v$file6)){
		par(mfrow=c(1,2))	
	}
	h=hist(obs,breaks=1000,xlim=c(0,max(obs,N_d)),main="Are there more/less targets than expected?",xlab="#host proteins",ylab="rel frequency")
	arrows(N_d,0,N_d,50,code=1)	
	if(!is.null(v$file6)){
		data=read.csv(v$file6,sep="\t",header=T)
		INTER2=data[,2]
		INTER12=INTER1[INTER1%in%INTER2]
		INTER12=length(INTER12)
		obs=c()
		for(i in 1:v$itr){
			e1=sample(1:length(my_genes),length(INTER1),replace=TRUE)
			e2=sample(1:length(my_genes),length(INTER2),replace=TRUE)
			n_shared=e1[e1%in%e2]
			n_shared=length(n_shared)
			obs=c(obs,n_shared)
		}
		h=hist(obs,breaks=1000,xlim=c(0,max(obs,INTER12)),main="Are there more host proteins targeted in both than expected?",xlab="#host proteins",ylab="rel frequency")		
		arrows(INTER12,0,INTER12,50,code=1)	
	}
}

do_bOrthology=function(v,o){
	print(paste0("INFO|bOrthology"))
	data=read.csv(v$file5,header=TRUE,sep="\t")
	if(v$orthoOptions=="inter"){
		my_genes=v$microbe_host_interactions[,2]
		my_genes=my_genes[seq(1,length(my_genes),2)]
		data=subset(data,data[,2]%in%my_genes)
	}else{
		my_genes=((v$interactome))
		my_genes=subset(my_genes,my_genes[,3]==1 | my_genes[,4]==1)
		my_genes=c(my_genes[,1],my_genes[,2])
		my_genes=unique(my_genes)
		data=subset(data,data[,2]%in%my_genes)
	}

	MAT=as.matrix(data[,3:dim(data)[2]])
	my_ret=renderD3heatmap({d3heatmap(cor(MAT))}) 
	my_ret2=MAT
	
	L=list()
	L[[1]]=my_ret
	L[[2]]=my_ret2
	return(L)
}
