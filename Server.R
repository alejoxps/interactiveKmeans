library(UsingR)
library(cluster)
#Getting dataset (only numeric rows)
dataset<-data.frame(iris)
nums <- sapply(dataset, is.numeric)
dataset<-dataset[ , nums]
subset<-dataset

shinyServer(  
  function(input, output) {
    #table with iris sample
    output$content <- renderTable({
      if(is.null(input$variables)){
        subset<-dataset
        if(input$scale_on==TRUE){          
          subset<-scale(subset)        
        }
        head(cbind(subset,iris[5]))
      }else{
        subset<-dataset[input$variables]
        if(input$scale_on==TRUE){          
          subset<-scale(subset)         
        }
        head(cbind(subset,iris[5]))      
      }
    })
    
    #plot Within Groups Sum of Squares vs number of clusters
    output$numberOfClusters<-renderPlot({
      set.seed(-1785)
      number_clusters_validation <- input$number_clusters_validation     
      wss<-calculateClusters(number_clusters_validation,input$scale_on)
      plot(1:number_clusters_validation, wss, type="b", xlab="Number of Clusters",
           ylab="Within Groups Sum of Squares")
    }
    )
    
    #plot cluster fitted
    output$fitCluster<-renderPlot({
      if(is.null(input$variables)){        
        subset<-dataset
      }else{
        subset<-dataset[input$variables]
        
      }    
      set.seed(-1785)     
     
      if(input$scale_on==TRUE){       
        subset<-scale(subset)        
      }
      
      fit <- kmeans(subset, input$number_centers)
      output$centers <- renderTable({
        fit$centers
      })
      #Plot Cluster distribution
      output$clusters<-renderPlot({
        par(mar = c(5, 4, 6, 2))
        height <- table(fit$cluster)
        mp <- barplot(height, main = "Clusters Distribution",xlab="Cluster",ylab="Number of Rows")
        text(mp, height, labels = format(height, 2), pos = 1, cex = 0.9)
      })
      #Creating fitted cluster plot
      clusplot(subset, fit$cluster, color=TRUE, shade=TRUE, 
               labels=4, lines=0)
      
    })
    #This function calculates the Sum of Squares form the plot
    calculateClusters<-function(number_clusters_validation,scale_on){
      if(is.null(input$variables)){        
        subset<-dataset
      }else{
        subset<-dataset[input$variables]
        
      }
      
      if(scale_on==TRUE){        
        subset<-scale(subset)        
      }
      wss <- (nrow(subset)-1)*sum(apply(subset,2,var))
      for (i in 2:number_clusters_validation) wss[i] <- sum(kmeans(subset, 
                                                                   centers=i)$withinss)
      wss
    }
    
  })