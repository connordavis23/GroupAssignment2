

ui <- fluidPage(
 sidebarPanel(  
  selectInput(
    inputId =  'selected_stock',
    label = "Select Stock",
    choices = unique(stocks$symbol) 
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



