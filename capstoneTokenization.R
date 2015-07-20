setwd("~/r_wdir/2015-07_capstone/Capstone")
library(tm)

# Create the corpus
dirName <- file.path(".", "samples")
length(dir(dirName))
docs <- Corpus(DirSource(dirName))
str(docs)

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

# View the files now
str(docs)

# Stem words



