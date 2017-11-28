#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
options(shiny.sanitize.errors = FALSE)

shinyUI(
        fluidPage(
                
                # Application Title
                titlePanel("Data Science Capstone Word Prediction App"),
                
                sidebarPanel(
                        textInput("userInput", "Enter a phrase below:", value = "Welcome to the App"),
                        br()
                        #actionButton("button1", "Predict")
                ),
                
                # setting up tabs
                mainPanel(
                        tabsetPanel(
                                tabPanel("Prediction", fluid = TRUE,
                                         
                                         br(),
                                         p("Entered phrase is :"), 
                                         #br(),
                                         strong(verbatimTextOutput("phrase")),
                                         br(),
                                         
                                         p("The predicted next word is: "),
                                         strong(verbatimTextOutput("predicted")),
                                         br(),
                                         
                                         p("Top 5 propable next words are :"),
                                         tableOutput("top5")
                                         
                                         
                                         
                                ),
                                tabPanel("Documentation", fluid = TRUE,
                                         h4("Project Requirements"),
                                         p("The goal of this exercise is to create a product to highlight the prediction 
                                           algorithm that you have built and to provide an interface that can be accessed 
                                           by others. For this project you must submit:"),
                                         p("1. A Shiny app that takes as input a phrase (multiple words) in a text box 
                                           input and outputs a prediction of the next word."),
                                         p("2. A slide deck consisting of no more than 5 slides created with R Studio Presenter 
                                           pitching your algorithm and app as if you were presenting to your boss or an investor."),
                                         br(),
                                         
                                         h4("Application Interface"),
                                         p("The User Input Panel on the left contains a text box to enter the 
                                           phrase you'd like to analyze. Algorithm will be called reactively 
                                           to action and initiates the analysis."),
                                         p("The algorithm returns three things. First the 
                                           original text that the user provided, second is the predicted next word, third 
                                           is a table of the top 5 most probable predictions."),
                                         br(),
                                         h4("Appendixes"),
                                         p("[1] The data for making this app was taken from ",
                                         a("coursera.", href = "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip")),
                                         p("[2] I have made the code for the app available at my ",a("github", href = "https://github.com/ajnask/SwiftKeyFinalProject"),
                                           " account for reproducibility sake")
                                         
                                         )
                                         )
                                         )
                
)
                                         )