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
#docs <- tm_map(docs, removeWords, stopwords("english"))     # Remove stop words
#docs <- tm_map(docs, stemDocument)                          # Stem words

# View the files now
docs[1][[1]][[1]][1]
docs[2][[1]][[1]][1]
docs[3][[1]][[1]][1]

# Create the document term matrix
dtm <- DocumentTermMatrix(docs)

# Remove sparse terms
dtms <- removeSparseTerms(dtm, 0.05)

# Look at 10 least and most frequent words
freq <- colSums(as.matrix(dtm))
ord <- order(freq)
freq[head(ord, 10)]
freq[tail(ord, 10)]

# Look at frequencies of frequencies
head(table(freq), 15)
tail(table(freq), 15)

# Make a word cloud
set.seed(123)
wordcloud(names(freq), freq, min.freq = 10000,
          colors = brewer.pal(6, "Dark2"), scale = c(3, 0.1))

# Show most common letters
words %>%
    str_split("") %>%
    sapply(function(x) x[-1]) %>%
    unlist %>%
    dist_tab %>%
    mutate(Letter=factor(toupper(interval),
                         levels=toupper(interval[order(freq)]))) %>%
    ggplot(aes(Letter, weight=percent)) +
    geom_bar() +
    coord_flip() +
    ylab("Proportion") +
    scale_y_continuous(breaks=seq(0, 12, 2),
                       label=function(x) paste0(x, "%"),
                       expand=c(0,0), limits=c(0,12))

# Look at frequencies of 2-grams and 3-grams
BigramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 2, max = 2))
}

TrigramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 3, max = 3))
}

# Create 2-gram tdm and remove sparse terms
tdm2 <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
tdm2s <- removeSparseTerms(tdm2, 0.4)

# Create 3-gram tdm and remove sparse terms
tdm3 <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))
tdm3s <- removeSparseTerms(tdm3, 0.4)

# Here are some of the most frequent 2-grams.
term2Freq <- rowSums(as.matrix(tdm2s))
ord2Terms <- order(term2Freq)
term2Freq[tail(ord2Terms, 10)]
term2Freq[head(ord2Terms, 10)]

# Here are some of the most frequent 3-grams.
term3Freq <- rowSums(as.matrix(tdm3s))
ord3Terms <- order(term3Freq)
term3Freq[tail(ord3Terms, 10)]
term3Freq[head(ord3Terms, 10)]

inspect(tdm3s["one of the",])
term3Freq["one of the"]/length(term3Freq)




