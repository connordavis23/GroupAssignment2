
library('fpp3')
library('shiny')
#Read Data
stocks <- read.csv('nyse_stocks.csv')

#Make tsibble
stocks$date <- as.Date(stocks$date)
stocks <- tsibble(stocks, index = date, key = symbol )

#1 Stock
#selected_stock <- 'AAPL'

stocks %>% 
  filter(symbol == selected_stock) %>%
  autoplot(open) +
  labs(title = selected_stock)

#Multiple Stocks
selected_stocks <- c('GOOG', 'AAPL')

stocks %>%
  filter(symbol %in% selected_stocks) %>%
  autoplot(open) 


names(stocks) 
metrics <- subset(stocks,
                  select = c('open', 'close', 'low', 'high', 'volume' ))

ui <- fluidPage(
  selectInput(
    inputId =  'selected_stock',
    label = "Select Stock",
    choices = unique(stocks$symbol) ),
  
  selectInput(
    inputId = 'selected_metric',
    label = 'Select Metric',
    choices = names(metrics)
  ),
  
  dateRangeInput(
    inputId = 'selected_date_range',
    label = 'Select Date Range',
    min = min(stocks$date),
    max = max(stocks$date)
),
plotOutput('ts_plot')
)


server <- function(input, output) {
  output$ts_plot <- renderPlot({
    min.date <- input$selected_date_range[1]
    max.date <- input$selected_date_range[2]
    
    plot_df <- stocks[stocks$symbol == input$selected_stock & stocks$date >= min.date & stocks$date <= max.date  ,]

    autoplot(plot_df, input$selected_metric)
    
  })
  
}

shinyApp(ui, server)

 plot_df <- stocks[stocks$symbol == 'AAPL' & stocks$date >= "2013-1-16" & stocks$date <= "2013-12-16"  ,]

autoplot(plot_df, open)

