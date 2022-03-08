

server <- function(input, output) {
  
  output$ts_plot <- renderPlot({
    
    min.date <- input$selected_date_range[1]
    max.date <- input$selected_date_range[2]
    
    plot_df <- stocks[stocks$symbol == input$selected_stock & stocks$date >= min.date & stocks$date <= max.date , ]
    
    plot_df <- plot_df[ ,c('date', 'symbol', input$selected_metric) ]
    autoplot(plot_df)
    
  })
  
}


