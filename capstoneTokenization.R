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

# The set of samples has already been created using a sampling function

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
getNextWordBigram <- function(word) {
    
    results <- term2Freq[grep(paste0(word, " "), names(term2Freq), fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(word)) == word]
    ordResults <- order(-results)
    return(names(results[head(ordResults, 5)]))
    
}

# Examples here show that some words have never been seen in the corpus,
# like "bazooka" and "skeleton"
getNextWordBigram("the")
getNextWordBigram("and")
getNextWordBigram("turned")
getNextWordBigram("turn")
getNextWordBigram("sunshine")
getNextWordBigram("bazooka") # this word is in the corpus twice. Problem here.
getNextWordBigram("skeleton")
getNextWordBigram("overflow")

# Same thing for tri-grams
getNextWordTrigram <- function(w1, w2) {
    
    results <- term3Freq[grep(paste0(w1, " ", w2, " "), names(term3Freq), fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(w1)) == w1]
    ordResults <- order(-results)
    return(names(results[head(ordResults, 5)]))
    
}

getNextWordTrigram("the", "first")
getNextWordTrigram("and", "it")
getNextWordTrigram("turned", "around")
getNextWordTrigram("turn", "into")
getNextWordTrigram("sunshine", "and")
getNextWordTrigram("sunshine")
getNextWordTrigram("the", "[:alnum:]")

# Now do 4-grams
getNextWordFourgram <- function(w1, w2, w3) {
    
    results <- term4Freq[grep(paste0(w1, " ", w2, " ", w3, " "), names(term4Freq), fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(w1)) == w1]
    ordResults <- order(-results)
    return(names(results[head(ordResults, 1)]))
    
}

getNextWordFourgram("the", "first", "time")
getNextWordFourgram("and", "it", "was")

getMLE <- function(w1, w2) {
    num <- term2Freq[names(term2Freq) == paste(w1, w2)]
    den <- term1Freq[names(term1Freq) == w1]
    prob <- num / den
    return(prob)
}

getMLE("the", "first")
getMLE("the", "same")
getMLE("the", "best")
getMLE("the", "sunshine")

getMLE("the", names(term1Freq)) # throws an error; use lapply?


getLaplace <- function(w1, w2) {
    num <- term2Freq[names(term2Freq) == paste(w1, w2)]
    if (length(num) == 0) { num = 1 }
    den <- term1Freq[names(term1Freq) == w1] + tdm1s$nrow
    prob <- num / den
    return(prob)
}

getLaplace("the", "first")
getLaplace("the", "bazooka")
getLaplace("bazooka", "Was")
getLaplace("bazooka", "skeleton")


# TODO:
# Compute probabilities (MLE) for bigrams (DONE!), trigrams, 4-grams
# Figure out how to calculate MLE for all words in vocab (e.g. term1Freq)
# Do Laplace smoothing for trigrams and 4-grams
# Try Lidstone and JP (ELE) on pg. 204
# Investigate Good-Turing and Kneser-Ney (may not be necessary)



# Function gets the last n words of string of text
# Very crude, will throw error if n > words in string
getLastWords <- function(textString, n) {
    
    s <- strsplit(textString, " ")
    if (length(s) != 0) {
        if (length(s[[1]]) < n) { n <- length(s[[1]]) }
        r <- s[[1]][(length(s[[1]]) - n + 1):(length(s[[1]]))]
    } else { r <- character(0) }
    return(r)
}

# Test it
getLastWords("The quick brown fox jumps", 3)
getLastWords("fox jumps", 3)
getLastWords("", 3)
getLastWords(character(0), 3)

textString <- character(0)
n <- 3


# Now combine into a function
# Take in a string, look at last 3 words first
# Back off to 2 words, 1 word...
# Return next word

textString <- "bottom to the"

predictNextWord <- function (textString) {
    
    w <- rev(getLastWords(textString, 3))
    if (length(w) == 3) {
        lw <- getLastWords(getNextWordFourgram(w[3], w[2], w[1]), 1)
    }
    if (length(w) == 2 | length(lw) == 0) {
        lw <- getLastWords(getNextWordTrigram(w[2], w[1]), 1)
    }
    if (length(w) == 1 | (length(lw) == 0)) {
        lw <- getLastWords(getNextWordBigram(w[1]), 1)   
    }
    if (length(lw) == 0) {
        lw <- names(term1Freq[tail(ord1Terms,1)])
    }
    return(lw)
    
}


# Quiz 2
predictNextWord("and a case of")
predictNextWord("It would mean the")
predictNextWord("Hey sunshine, can you follow me and make me the")
predictNextWord("Offense still struggling but the")
predictNextWord("Go on a romantic date at the")
predictNextWord("garage I'll dust them off and be on my")
predictNextWord("Love that film and haven't seen it in quite some")
predictNextWord("push his long wet hair out of his eyes with his little")
predictNextWord("and keep the faith during the")
predictNextWord("If this isn't the cutest thing you've ever seen, then you must be")

# Quiz 3
predictNextWord("I'll be there for you, I'd live and I'd")
predictNextWord("and he started telling me about his")
predictNextWord("I'd give anything to see arctic monkeys this")
predictNextWord("Talking to your mom has the same effect as a hug and helps reduce your")
predictNextWord("but you hadn't time to take a")
predictNextWord("a presentation of evidence, and a jury to settle the")
predictNextWord("I can't even hold an uneven number of bags of groceries in each")
predictNextWord("Every inch of you is perfect from the bottom to the")
predictNextWord("filled with imagination and bruises from playing")
predictNextWord("I like how the same people are in almost all of Adam Sandler's")


# Just for fun, generate some text
generateText <- function (seed, n) {
    
    i <- 0
    w <- seed
    while (i < n) {
        w <- paste(w, predictNextWord(w))
        i <- i + 1
    }
    return(w)
}

generateText("Luke I am", 50)
generateText("The experiment was", 50)
generateText("My wife", 100)



