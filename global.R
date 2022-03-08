library('fpp3')
library('shiny')
library('readr')

stocks <- read_csv('nyse_stocks.csv.zip')

metrics <- subset(stocks,
                  select = c('open', 'close', 'low', 'high', 'volume' ))