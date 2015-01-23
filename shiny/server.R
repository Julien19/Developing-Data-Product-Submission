####INIT - predictive model creation

##libraries & seed
library(caret);
library(e1071);
library(lattice);
library(ggplot2);
library(randomForest);
library(grid);
set.seed(1234);

##datasets
#
data(iris);
datainit=iris;
output="Species";
#

inTrain <- createDataPartition(datainit[,output], p = 0.7, list = FALSE)
training <- datainit[ inTrain,]
testing <- datainit[-inTrain,]

##model
#
form=Species~.;
method="rf";
#
modelFit<-train(form=form,data=training,method=method)

##out of sample error
predictions<-predict(modelFit,newdata=testing)
confusionMatrix(predictions,testing[,output])

####################

shinyServer(
  function(input,output){
  
    ongoing_iris <- reactive(data.frame(Petal.Width=input$Petal.Width,Petal.Length=input$Petal.Length,Sepal.Width=input$Sepal.Width,Sepal.Length=input$Sepal.Length))
    
    output$ps <- renderText({as.character(predict(modelFit,newdata=ongoing_iris()))})
    
    output$plot <- renderPlot({
      p_P <- ggplot(iris,aes(Petal.Width,Petal.Length))+geom_point(aes(color=Species))+geom_point(data=ongoing_iris(),colour="#CC0000",size=4)
      p_S <- ggplot(iris,aes(Sepal.Length,Sepal.Width))+geom_point(aes(color=Species))+geom_point(data=ongoing_iris(),colour="#CC0000",size=4)
      p_L <- ggplot(iris,aes(Sepal.Length,Petal.Length))+geom_point(aes(color=Species))+geom_point(data=ongoing_iris(),colour="#CC0000",size=4)
      p_W <- ggplot(iris,aes(Petal.Width,Sepal.Width))+geom_point(aes(color=Species))+geom_point(data=ongoing_iris(),colour="#CC0000",size=4)
      multiplot(p_P,p_W,p_L,p_S, cols=2)
    })
  }
)

####################
# needed function

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

####################