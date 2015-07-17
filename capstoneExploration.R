setwd("~/r_wdir/2015-07_capstone/Capstone")
library(tm)

# This function takes a file and samples some percentage of lines from it
# It creates a new file with the sampled lines only


sampleLines <- function(oldFileName, percentage, newFileName){

    # Open a new connection to the file
    con <- file(oldFileName, "r")
    
    # Make sure the new file is blank
    if (file.exists(newFileName)) {
        file.remove(newFileName)
    }
    
    file.create(newFileName)
    
    # Read each line and flip a coin to decide whether to include it
    while (length(line <- readLines(con, 1)) > 0) { 
        
        if (rbinom(1, 1, percentage) == 1) {
            cat(line, file = newFileName, append = TRUE, sep = "\n")
        }
    }
    
    close(con)
}

# Now apply this function to the English database

set.seed(12345)
sampleLines(oldFileName = "Coursera-SwiftKey/final/en_US/en_US.blogs.txt",
            percentage = 0.1,
            newFileName = "sample_en_US.blogs.txt")

sampleLines(oldFileName = "Coursera-SwiftKey/final/en_US/en_US.twitter.txt",
            percentage = 0.1,
            newFileName = "sample_en_US.twitter.txt")

sampleLines(oldFileName = "Coursera-SwiftKey/final/en_US/en_US.news.txt",
            percentage = 0.1,
            newFileName = "sample_en_US.news.txt")

# Create the corpus
dirName <- file.path(".", "samples")
length(dir(dirName))
docs <- Corpus(DirSource(dirName))
summary(docs)
str(docs[1])

# Do some cleaning

# Remove symbols
# Convert to lowercase
# Remove numbers
# Remove punctuation
# Remove stop words



