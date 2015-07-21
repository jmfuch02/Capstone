setwd("~/r_wdir/2015-07_capstone/Capstone")
library(tm)

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

# Convert to lowercase
docs <- tm_map(docs, content_transformer(tolower))

# Remove numbers
docs <- tm_map(docs, removeNumbers)

# Remove punctuation
docs <- tm_map(docs, removePunctuation)

# Remove stop words
docs <- tm_map(docs, removeWords, stopwords("english"))

# Remove extra white space
docs <- tm_map(docs, stripWhitespace)

# Stem words
library(SnowballC)
docs <- tm_map(docs, stemDocument)

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
library(wordcloud)
set.seed(123)
wordcloud(names(freq), freq, min.freq = 10000,
          colors = brewer.pal(6, "Dark2"), scale = c(3, 0.1))
