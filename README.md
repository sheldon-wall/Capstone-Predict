# Capstone Project - Version 1.1 - February 4, 2018
### Sheldon Wall

# Executive Summary

The challenge laid out for the capstone project was predict the next word of an incomplete sentence providing the result in near real time with limited storage and compute resources.
The solution developed in response consists of a shiny application that utilizes sophisticated natural language processing (NLP) language model - specifically utilizing Stupid Backoff smoothing (a derivation of Katz-Backoff) to deliver highly predictive results nearly instantly.  The solution is both highly predictive and provides near real-time response.  An option to bias the results based on sentiment of a predicted word was added for a little user enjoyment. 

# Details
## Significant solution components
- A corpus of text from news, blog and twitter [feeds](https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip)
- R packages for text explortaion, mining and natural language processing such as [TM](https://cran.r-project.org/web/packages/tm/index.html) and [TidyText](https://cran.r-project.org/web/packages/tidytext/index.html)
- N-gram language modeling with [stupid backoff](http://www.aclweb.org/anthology/D07-1090.pdf) smoothing
- [Datatables](https://cran.r-project.org/web/packages/data.table/index.html) for fast lookup table (LUT) functionality

## The Application
This shiny application consists of a user interface (UI) that provisions entry of text and returns a list of probable next words - based on decreasing probability.
- The user enters in the **Input** text they wish to type in the _Enter Sentence_ field and can use **Side Panel Control** options in the display of the results
- By default a table of predicted 5 next words is displayed below the input parameter and is ordered by descending probability (number of words and ordering is configurable by user preference)
- Based on a capstone [benchmarking](https://github.com/hfoffani/dsci-benchmark) mechanism (Week 4 [Forum](https://www.coursera.org/learn/data-science-project/discussions/weeks/4/threads/qnLGp_1IEealOAqmTyI3zA)) the application scored very well compared to other posted results.  Top-3 score = 18.29% and quick response = 8.16 msec
- The application code can be found at: <https://sdwall.shinyapps.io/predict/>
