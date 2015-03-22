library(shiny)
dataset<-data.frame(iris)
nums <- sapply(dataset, is.numeric)       
dataset<-dataset[ , nums]
shinyUI(pageWithSidebar(
  headerPanel("interactive K-Means "),  
  sidebarPanel(
    h5("This application uses  iris dataset to show the basic process of clustering."),
       sliderInput('number_clusters_validation', 'Chose the interval for Cluster Selection Plot. You can select how many centers to compare in order to make the right decision',value = 8, min = 2, max = 15, step = 1),
      
  checkboxInput("scale_on", "Scale dataset: This option will help you if the columns of the dataset are not comparable. For example a column in millions vs a column in years", FALSE),
  sliderInput('number_centers', 'Select the Number of Centers of the Solution.  The plot of the within groups sum of squares by number of clusters extracted can help you to determinate the appropriate number of clusters',value = 4, min = 2, max = 15, step = 1),
  checkboxGroupInput("variables", "Select Variables for clustering: You can select which variables are important in the clusters construction", choices = names(dataset),selected = names(dataset))),
  mainPanel(
    h3("Dataset Iris for clustering (First rows)"),
    tableOutput("content"),
    h3("This plot will help you to determinate the appropriate Number of Clusters(look for a bend in the plot )"),
    plotOutput('numberOfClusters',width = "500px", height = "400px"),
    h3("Look at the Cluster results"),
    plotOutput('fitCluster',width = "500px", height = "400px"),
    h3("Clusters Centers"),
    tableOutput("centers"),
    h3("Clusters Distribution"),
    plotOutput('clusters',width = "500px", height = "400px")
    
  )
))

