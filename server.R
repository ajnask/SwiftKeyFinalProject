#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(stylo)
library(data.table)
library(stringr)
library(stringi)
library(quanteda)
source(file = "global.R",local = TRUE)

shinyServer(function(input,output){
        
        # userInput <- eventReactive(input$button1, { paste( input$userInput )} )
        # output$phrase <- renderText({ userInput() })
        # prediction <- eventReactive(input$button1, predictwords(userInput()))
        # output$top5 <- renderTable( { prediction() } )
        # bestpredict <- eventReactive(input$button1, predictedword(userInput()))
        # # sprintf('<font color=red>%s</font>',bestpredict())
        # output$predicted <- renderText({ bestpredict() })

        phrase <- reactive( { paste( input$userInput )} )
        output$phrase <- renderText({ phrase() })
        prediction <- reactive( predictwords(phrase()))
        output$top5 <- renderTable( { prediction() } )
        bestpredict <- reactive( predictedword(phrase()))
        # sprintf('<font color=red>%s</font>',bestpredict())
        output$predicted <- renderText({ bestpredict() })
})