# About - Predict Next Word with Sentiment Bias

### Capstone Project - Version 1.1 - February 4, 2018
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

## Approach
The approach to creating this solution involved a number of steps and were created and executed over a number of weeks using an iterative approach.
- **Text** was downloaded from a central source. An initial random sampling (10%) of that text was selected for further processing then increased to 50%.
- **Corpus** creation, cleansing and tokenization.  This step included removing invalid characters, whitespace, punctuation and numbers. Profanity was removed but common (stop) words were not.
- General **Exploratory** Analyis was performed using the TidyText package and invovled exploring unigram, bi-grams and tri-grams and also TF-IDF analysis and Zipf's law.
- **N-gran models** were created (1-5 grams) stored in fast lookup tables and removing low-frequency N-grams during **benchmarking** of impact on predictability and performance.
- Creation of a **Predict Next Word** function using backoff language model with Stupid-backoff smoothing.  This method is similar to Katz backoff but it does not generate normalized probabilities. Rather it uses relative frequency scores with fixed backoff factor of **.4** based on the authors' recommendation.
- Finally the creation of a **Shiny application**, with limited resources, to provide a means of entering a sentence and executing the function to predict the next word.


## The Application
This shiny application consists of a user interface (UI) that provisions entry of text and returns a list of probable next words - based on decreasing probability.
- The user enters in the **Input** text they wish to type in the _Enter Sentence_ field and can use **Side Panel Control** options in the display of the results
- By default a table of predicted 5 next words is displayed below the input parameter and is ordered by descending probability (number of words and ordering is configurable by user preference)
- Based on a capstone [benchmarking](https://github.com/hfoffani/dsci-benchmark) mechanism (Week 4 [Forum](https://www.coursera.org/learn/data-science-project/discussions/weeks/4/threads/qnLGp_1IEealOAqmTyI3zA)) the application scored very well compared to other posted results.  Top-3 score = 18.29% and quick response = 8.16 msec
- The application source code can be found at: <https://github.com/sheldon-wall/Capstone-Predict>

## Cool Features (Sentiment Bias)
A user can choose to bias the prediction of the next word into either a positive **(glass half full)** or negative **(glass half empty)** perspective.  

A sentiment score (bias) has been set for each predictor, in a range from (positive 5 to negative 5) with 0 as neutral, as defined by the [AFINN](http://neuro.imm.dtu.dk/wiki/AFINN) lexicon.

Based on the **bias** selection and **strength** settings the user can bias ("bubble up or down") the prediction of a word with their sentiment selection.  

### Polarity Shifting
A very simply sentiment [polarity shifting](http://www.lr.pi.titech.ac.jp/~takamura/pubs/ikeda_ijcnlp2008.pdf) negation voting technique was used to ensure preceding words such as ("not", "no", "yet", "never", etc.) correctly shifted the polarity of the bias correct.

For instance the presence of **not** after "I do" ("I do not") switches the polority of the sentiment score and the resulting next word probability.
