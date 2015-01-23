library(shiny)
shinyUI(pageWithSidebar(
  headerPanel("Iris species prediction"),
  sidebarPanel(
    h2("Enter the Iris parameters"),
    sliderInput('Petal.Length','Petal.Length',value=4.3,min=1,max=7,step=0.1,),
    sliderInput('Petal.Width','Petal.Width',value=1.3,min=0,max=2.5,step=0.1,),
    sliderInput('Sepal.Length','Sepal.Length',value=5.8,min=4,max=8,step=0.1,),
    sliderInput('Sepal.Width','Sepal.Width',value=3,min=2,max=4.5,step=0.1,)
  ),
  mainPanel(
    h2("Predicted species of your iris"),
    verbatimTextOutput('ps'),
    h2("Where your iris is positionned regarding others"),
    plotOutput('plot'),
    h3("How to use the App?"),
    p("Just enter the parameters of your iris using the sliders."),
    p("You get in ouput the predicted species of your iris, defined through a prediction algorithm built by machine learning on the Fisher/Anderson's iris data."),
    p("You can also see on plots where your iris is positioned regarding other iris of which we know the species.")
  )
))