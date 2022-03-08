

ui <- fluidPage(
  selectInput(
    inputId =  'selected_stock',
    label = "Select Stock",
    choices = unique(stocks$symbol) 
  ),
  
  selectInput(
    inputId = 'selected_metric',
    label = 'Select Metric',
    choices = names(metrics)
  ),
  
  dateRangeInput(
    inputId = 'selected_date_range',
    label = 'Select Date Range',
    start = min(stocks$date),
    end = max(stocks$date),
    min = min(stocks$date),
    max = max(stocks$date)
  ),
  
  plotOutput('ts_plot')
  
)
