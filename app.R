#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(coindeskr) #R-Package connecting to Coindesk API 
library(dygraphs)


last31 <- get_last31days_price() 
currentPrice<- get_current_price()

ui <- shinyUI(
  fluidPage(
    titlePanel('Bitcoin USD Price for Last 31 days & Current Price'),
    mainPanel(
      h3('Minimum'),
      h3(htmlOutput('minprice')),
      h3('Maximum'),
      h3(htmlOutput('maxprice')),
      dygraphOutput("btcprice"),
      h3('Current Price'),
      h3(htmlOutput("currentprice"))
      
      
    )
  ))

server <- function(input,output){
  
  output$minprice <- renderText(
    paste('Price : $', min(last31), '<br>Date :', rownames(last31)[which.min(last31$Price)] )
  )
  
  
  output$maxprice <- renderText(
    paste('Price : $', max(last31), '<br>Date :', rownames(last31)[which.max(last31$Price)] )
  )
  output$btcprice <- renderDygraph(
    dygraph(data = last31, main = "Bitcoin USD Price for Last 31 days") %>% 
      dyHighlight(highlightCircleSize = 5, 
                  highlightSeriesBackgroundAlpha = 0.2,
                  hideOnMouseOut = FALSE, highlightSeriesOpts = list(strokeWidth = 3)) %>%
      dyRangeSelector()
  )
  
  output$currentprice <- renderText(
    paste('Price : $', currentPrice$bpi.USD.rate, '<br>Last Updated at:', currentPrice$time.updated)
  )
  
  
  
  
  
}

shinyApp(ui,server)
