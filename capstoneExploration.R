
# This function takes a file and samples some percentage of lines from it
# It creates a new file with the sampled lines only

sampleLines <- function(oldFileName, percentage, newFileName){

    con <- file(oldFileName, "r")
    if (file.exists(newFileName)) {
        file.remove(newFileName)
    }
    
    file.create(newFileName)
    
    #TODO: Fix this error on last line
    while (nchar(line <- readLines(con, 1)) > 0) { 
        
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
