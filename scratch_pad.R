library(fpp3)
library(readr)

# Read zipped data
stocks <- read_csv("nyse_stocks.csv.zip")

# Convert to `tsibble()`
stocks$date <- as.Date(stocks$date)
stocks <- tsibble(stocks, index = date, key = symbol)

# 1 stock
selected_stock <- "AAPL"

stocks %>%
  filter(symbol == selected_stock) %>%
  autoplot(open) +
  labs(title = selected_stock)

# Multiple stocks
selected_stocks <- c("GOOG", "AAPL")

stocks %>%
  filter(symbol %in% selected_stocks) %>%
  autoplot(open)

# output$ts_plot2 <- renderPlot({

#   min.date <- input$selected_date_range[1]
#  max.date <- input$selected_date_range[2]

# plot_df2 <- stocks[stocks$gics_sector == input$selected_sector & stocks$date >= min.date & stocks$date <= max.date , ]

#plot_df2 <- plot_df2[ ,c('date', 'symbol', input$selected_metric, input$selected_sector) ]
#autoplot(plot_df2)
# }
#)

#plot_df2 <- stocks[stocks$gics_sector == 'Information Technology' & stocks$date >= '2012/10/10' & stocks$date <= '2012/11/11' , ]
#autoplot(plot_df2, close)

ui <- fluidPage(
  sidebarPanel(  
    selectInput(
      inputId =  'selected_stock1',
      label = "Select Stock",
      choices = unique(stocks$symbol) 
    ),
    selectInput(
      inputId =  'selected_stock2',
      label = "Select Stock",
      choices = unique(stocks$symbol) 
    ),
    
    selectInput(
      inputId = 'selected_metric',
      label = 'Select Metric',
      choices = names(metrics)
    ),
    
    selectInput(
      inputId = 'selected_sector',
      label = 'Select Sector',
      multiple = TRUE,
      choices = names(stocks$gics_sector)
    ),
    
    dateRangeInput(
      inputId = 'selected_date_range',
      label = 'Select Date Range',
      start = min(stocks$date),
      end = max(stocks$date),
      min = min(stocks$date),
      max = max(stocks$date)
    )),
  mainPanel(
    plotOutput('ts_plot'))
)

#Select a Forecast to see
server  <- function(input, output) {
  
  output$forecast <- renderPlot({
    
    min.date <- input$selected_date_range[1]
    max.date <- input$selected_date_range[2]
    
    plot_df <- stocks[stocks$symbol == input$selected_stock1 & stocks$symbol == input$selected_stock2 & stocks$date >= min.date & stocks$date <= max.date , ]
    
    plot_df <- plot_df[ ,c('date', 'symbol', 'close') ]
    
    autoplot(plot_df)
  })
  
}

shinyApp(ui, server)