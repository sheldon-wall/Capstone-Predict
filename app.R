#
# This is a Shiny web application for predicting the next word - given a 
# set of words that have been entered.  
#

library(stringr)
library(data.table)
library(shiny)
library(markdown)

## set the data directory 
dataDir <- "./data"

## load the ngram 
filename <- file.path(dataDir, "ngram_sentiment.Rds")
ngram_all <- readRDS(filename)
var_list <- c(names(ngram_all), "prob")

# Define UI for application that draws a histogram
ui <- fluidPage(theme = "bootstrap.css",
   
                
  navbarPage("Predict Next Word - with Semantic Bias!",
     tabPanel("Predict",
              sidebarLayout(
                sidebarPanel(
                  numericInput("numwords", "Num Words", value = 5, width = 150),
                         checkboxGroupInput("show_vars", "Columns to show:",
                                            var_list, selected = c("predictor", "prob")),
                  radioButtons("sentiment", "Choose Sentiment Bias",
                               choices = c("Negative" = "neg", "Neutral"= "none"
                                           ,"Positive" = "pos"), selected = "none"),
                  sliderInput("strength","Bias Strength", min = 2, max = 5, value = 2, 
                              step = .5, ticks = FALSE, animate = TRUE)
                  ),
                mainPanel(textInput("sentence", "Enter Sentence", width = 600),
                          dataTableOutput("predictions"))
              )
     ),
     tabPanel("Documentation",
              includeMarkdown("Documentation.md")),
     tabPanel("About",
              includeMarkdown("About.md"))
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
   
   output$predictions <- renderDataTable(
     scrub_and_predict(input$sentence, num_pred_words = input$numwords, 
                       sent_bias = input$sentiment, sent_strength = input$strength)
     [, input$show_vars, with=FALSE],
     ##[,var_list, drop = FALSE],
     options = list(lengthMenu = c(5, 25), pagelength = 5,
                    searching = FALSE)
     )

   
   scrub_and_predict <- function(sentence, num_nodes = 5, num_pred_words = 5, 
                                 sent_bias = "none", sent_strength = 2)
   {
     ## retrieve last number of words in sentence to start applying ngram search
     sentence <- tolower(sentence)
     sentence <- gsub("'", "", sentence)
     sentence <- gsub("[[:punct:][:blank:]]+", " ", sentence)
     sentence <- trimws(sentence, "both")
     
     ## set number of nodes to lessor of max n-grams or number of words in sentence
     num_nodes <- min(num_nodes, str_count(sentence, "\\S+"))
     
     ans <- predict_next_word(sentence, num_nodes)
     
     setkey(ans, predictor)
     ans <- subset(ans, !duplicated(predictor))
     
     ## augment the probability based on the bias indicator
     ## If bias == "pos" 
     ## multiply prob = prob * bias
     
     if (sent_bias == "pos"){
       ans[bias > 0, prob:=sent_strength*bias*prob] 
     }
     
     if (sent_bias == "neg"){
       ans[bias < 0, prob:= -sent_strength * bias * prob] 
     }     
     ## return top num_pred_words 
     setcolorder(ans, c("predictor", "prob", "bias", "n", "base"))
     setorder(ans, -prob)
     return(ans[1:num_pred_words])
   }
   
   ## sentence contains sentence that needs to be matched within ngram_all 
   ## nodes contains N-Gram that we are introspecting, 
   
   predict_next_word <- function(sentence, node)
   {
     ## set search word 
     search_words <- word(sentence, start = -node, end = -1)
     ## if we are completely done backing off - then fill with an empty string
     if (is.na(search_words)){
       search_words <- ""
     }
     
     ans <- ngram_all[base == search_words]
     
     ## if we found matches then 
     if (nrow(ans) > 0){
       ans[,prob:= n/sum(n)]
       if (node > 0){
         backoff <- predict_next_word(search_words, node - 1)
         ## stupid backoff
         backoff[,prob:=prob*.4]
         ans <- rbind(ans, backoff)
       }
     } else {
       if (node > 0){
         ## stupid backoff
         ans <- predict_next_word(search_words, node - 1)
         ans[,prob:=prob*.4]
       }
     }
     
     return(ans)
   }
   
   
}

# Run the application 
shinyApp(ui = ui, server = server)

