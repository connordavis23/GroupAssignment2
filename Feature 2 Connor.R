#Candlestick Plot w/ Table of stock data where you select stock ticker, starting date, by different day breaks



library(shiny)

ui <- fluidPage(
  titlePanel("Stock Analyssis"),
  sidebarLayout(
    sidebarPanel(
      textInput("selected_stockticker",
                "Stock Ticker:"),
      dateInput("selected_date",
                "Starting Date:",
                value = "2022-03-08"),
      selectInput("selected_dateBreaks", 
                  "Day Break:",
                  choices = c("1 Day", "1 Week",
                              "1 Month", "1 Year")),
      actionButton("go_button", "GO!")
    ),
    mainPanel(
      plotOutput("candleplot", brush = "plot_brush"),
      tableOutput(stocks)
      )
    )
  )



server <- function(input, output, session) {
  
  stock <- eventReactive(input$go_button, {
    req(input$selected_stockticker, input$selected_date)
    
    getSymbols(input$selected_stockticker,
               from = input$selected_date, 
               auto.assign = FALSE) %>%
      as.data.frame() %>%
      `colnames<-`(c("open", "close", "low", "high"))
      rownames_to_column(var = "date")%>%
      mutate(date = as.Date(date)) %>%
      mutate(greenRed = ifelse(open - close > 0,
                               "Red",
                               "Green"))
  })
  
  candle <- eventReactive(input$go_button, {
    req(input$selected_stockticker, input$selected_date, input$selected_dateBreaks)
    
    ggplot(stock()) +
      geom_segment(aes(x = date,
                       xend = date,
                       y = open,
                       yend = close,
                       color = greenRed),
                   size = 3) +
      geom_segment(aes(x = date,
                       xend = date,
                       y = high,
                       yend = low,
                       color = greenRed))
  })
  
  output$candleplot <- renderPlot({
    candle()
  }, res = 90)
  
  output$stocks <- renderTable({
    brushedPoints(stock(), input$plot_brush)
  })
}

shinyApp(ui, server)
