# Some material sourced from http://onepager.togaware.com/
# Hands-On Data Science with R - Text Mining
# Graham.Williams@togaware.com
# 5th November 2014

setwd("~/r_wdir/2015-07_capstone/Capstone")
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
#length(dir(dirName))
docs <- Corpus(DirSource(dirName))
#str(docs)

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
docs <- tm_map(docs, removeWords, stopwords("english"))     # Remove stop words
docs <- tm_map(docs, stripWhitespace)                       # Remove extra white space
docs <- tm_map(docs, stemDocument)                          # Stem words

# View the files now
docs[1][[1]][[1]][1]
docs[2][[1]][[1]][1]
docs[3][[1]][[1]][1]

# Create the document term matrix
dtm <- DocumentTermMatrix(docs)

# Look at the first 10 words
inspect(dtm[1:3, 1:10])

# Look at 10 most frequent words
freq <- colSums(as.matrix(dtm))
ord <- order(freq)
freq[head(ord, 10)]
freq[tail(ord, 10)]

# Look at frequencies of frequencies
head(table(freq), 15)
tail(table(freq), 15)

dim(dtm)
dtms <- removeSparseTerms(dtm, 0.05)
dim(dtms)

# Now check that there are fewer terms and less sparsity
dtm
dtms

freq <- colSums(as.matrix(dtms))
ord <- order(freq)
freq[head(ord, 15)]
freq[tail(ord, 15)]

# Make a word cloud
set.seed(123)
wordcloud(names(freq), freq, min.freq = 10000,
          colors = brewer.pal(6, "Dark2"), scale = c(3, 0.1))

# Do some quantitative analysis
#words <- colnames(as.matrix(dtm))[nchar(colnames(as.matrix(dtm))) < 20]
words <- dtm %>%
    as.matrix %>%
    colnames %>%
    (function(x) x[nchar(x) < 20])

summary(nchar(words))
dist_tab(nchar(words))

# Create a histogram of the word lengths
data.frame(nletters=nchar(words)) %>%
    ggplot(aes(x=nletters)) +
    geom_histogram(binwidth=1) +
    geom_vline(xintercept=mean(nchar(words)),
               colour="green", size=1, alpha=.5) +
    labs(x="Number of Letters", y="Number of Words")

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

tdm2 <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
inspect(tdm2[1000000:1000020,])

tdm3 <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))
inspect(tdm3[1000000:1000020,])

findFreqTerms(tdm2, 5000)
findFreqTerms(tdm3, 500)

