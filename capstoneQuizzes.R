# Quiz 1

# Q1.3: longest lines

#con <- file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r")
con <- file("Coursera-SwiftKey/final/en_US/en_US.news.txt", "r")

longestLine <- 0

while (nchar(line <- readLines(con, 1)) > 0) {
    
    if (nchar(line) > longestLine) {
        longestLine <- nchar(line)
    }
}

close(con)


# Q1.4: love and hate
