# Some material sourced from http://onepager.togaware.com/
# Hands-On Data Science with R - Text Mining
# Graham.Williams@togaware.com
# 5th November 2014

#setwd("~/r_wdir/2015-07_capstone/Capstone")
library(tm)
library(SnowballC)
library(wordcloud)
library(rJava)
library(qdap)
library(magrittr) # for piping %>%
library(ggplot2)
library(stringr)
library(dplyr)
library(RWeka)

# Create the corpus
dirName <- file.path(".", "samples")
docs <- Corpus(DirSource(dirName))

# Do some cleaning

# Remove symbols
# toSpace <- content_transformer(
#     function(x, pattern)
#         gsub(pattern, " ", x))
# docs <- tm_map(docs, toSpace, "/|@|\\|$|%|#|&")

# Do some transforms here
docs <- tm_map(docs, content_transformer(tolower))          # Convert to lowercase
docs <- tm_map(docs, removeNumbers)                         # Remove numbers
docs <- tm_map(docs, removePunctuation)                     # Remove punctuation
docs <- tm_map(docs, stripWhitespace)                       # Remove extra white space

# View the files now
docs[1][[1]][[1]][1]
docs[2][[1]][[1]][1]
docs[3][[1]][[1]][1]

# Create the document term matrix
dtm <- DocumentTermMatrix(docs)

# Remove sparse terms
dtms <- removeSparseTerms(dtm, 0.05)

# Look at 10 least and most frequent words
freq <- colSums(as.matrix(dtms))
ord <- order(freq)
freq[head(ord, 10)]
freq[tail(ord, 10)]

# Make a word cloud
set.seed(123)
wordcloud(names(freq), freq, min.freq = 10000,
          colors = brewer.pal(6, "Dark2"), scale = c(3, 0.1))

# Look at frequencies of 2-grams and 3-grams
BigramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 2, max = 2))
}

TrigramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 3, max = 3))
}

FourgramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 4, max = 4))
}

# Create term-document matrix
tdm1 <- TermDocumentMatrix(docs)
tdm1s <- removeSparseTerms(tdm1, 0.4)

# Single word frequencies
term1Freq <- rowSums(as.matrix(tdm1s))
ord1Terms <- order(term1Freq)
term1Freq[tail(ord1Terms,10)]


# Create 2-gram tdm and remove sparse terms
tdm2 <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
tdm2s <- removeSparseTerms(tdm2, 0.4)

# Here are some of the most frequent 2-grams.
term2Freq <- rowSums(as.matrix(tdm2s))
ord2Terms <- order(term2Freq)
term2Freq[tail(ord2Terms, 10)]


# Create 3-gram tdm and remove sparse terms
tdm3 <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))
tdm3s <- removeSparseTerms(tdm3, 0.4)

# Here are some of the most frequent 3-grams.
term3Freq <- rowSums(as.matrix(tdm3s))
ord3Terms <- order(term3Freq)
term3Freq[tail(ord3Terms, 10)]


# Create 4-gram tdm and remove sparse terms
tdm4 <- TermDocumentMatrix(docs, control = list(tokenize = FourgramTokenizer))
tdm4s <- removeSparseTerms(tdm4, 0.4)

# Here are some of the most frequent 4-grams.
term4Freq <- rowSums(as.matrix(tdm4s))
ord4Terms <- order(term4Freq)
term4Freq[tail(ord4Terms, 10)]


# EXPLORE: Find terms in the tdm
inspect(tdm3s["one of the",])
term3Freq["one of the"]
results <- term3Freq[grep("one of ", names(term3Freq), fixed = TRUE)]
ordResults <- order(-results)
results[head(ordResults, 5)]

results <- term2Freq[grep("turn ", names(term2Freq), fixed = TRUE)]
results <- results[substring(names(results), 1, nchar("turn")) == "turn"]
ordResults <- order(-results)
results[head(ordResults, 5)]

# FUNCTION: Take in one word, return table showing top 5 next words and counts
getNextWord <- function(word) {
    
    results <- term2Freq[grep(paste0(word, " "), names(term2Freq), fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(word)) == word]
    ordResults <- order(-results)
    results[head(ordResults, 5)]
    
}

getNextWord("the")
getNextWord("and")
getNextWord("i")
getNextWord("you")
getNextWord("ok")
getNextWord("want")
getNextWord("camera")
getNextWord("turned")
getNextWord("turn")
getNextWord("jesus")
getNextWord("library")
getNextWord("sunshine")
getNextWord("lightning")
getNextWord("bazooka")
getNextWord("skeleton")


# TODO:
# Expand the function above to include any string of length up to 3 (use 4-gram)
# Show just next word, not the whole string (use substring?)
# Figure out how to handle non-existant words (e.g. bazooka, skeleton)





