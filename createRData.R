# Create a clean RData file for Shiny deploy

# First remove everything
rm(list = ls())

# Load libraries
library(tm)
library(SnowballC)
library(RWeka)

# Create the corpus
docs <- Corpus(DirSource(file.path(".", "samples")))

# Do some transforms here
docs <- tm_map(docs, content_transformer(tolower))  # Convert to lowercase
docs <- tm_map(docs, removeNumbers)                 # Remove numbers
docs <- tm_map(docs, removePunctuation)             # Remove punctuation
docs <- tm_map(docs, stripWhitespace)               # Remove extra white space

# Make unigram term-document matrix
tdm1 <- TermDocumentMatrix(docs)
tdm1s <- removeSparseTerms(tdm1, 0.4)
rm(tdm1)
term1Freq <- rowSums(as.matrix(tdm1s))
ord1Terms <- order(term1Freq)

# Make bigram tdm
BigramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 2, max = 2))
}

tdm2 <- TermDocumentMatrix(docs, control = list(tokenize = BigramTokenizer))
tdm2s <- removeSparseTerms(tdm2, 0.4)
rm(tdm2)
term2Freq <- rowSums(as.matrix(tdm2s))
ord2Terms <- order(term2Freq)

# Make trigram tdm
TrigramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 3, max = 3))
}

tdm3 <- TermDocumentMatrix(docs, control = list(tokenize = TrigramTokenizer))
tdm3s <- removeSparseTerms(tdm3, 0.4)
rm(tdm3)
term3Freq <- rowSums(as.matrix(tdm3s))
ord3Terms <- order(term3Freq)

# Make four-gram tdm
FourgramTokenizer <- function (x) {
    NGramTokenizer(x, Weka_control(min = 4, max = 4))
}

tdm4 <- TermDocumentMatrix(docs, control = list(tokenize = FourgramTokenizer))
tdm4s <- removeSparseTerms(tdm4, 0.4)
rm(tdm4)
term4Freq <- rowSums(as.matrix(tdm4s))
ord4Terms <- order(term4Freq)

# Save the workspace
save.image()




