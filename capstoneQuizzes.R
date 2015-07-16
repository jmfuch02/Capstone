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

con <- file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r")

loveLines <- 0
hateLines <- 0

while (nchar(line <- readLines(con, 1)) > 0) {
    
    if ((grepl("love", x = line)) == TRUE) {
        loveLines <- loveLines + 1
    }
    
    if ((grepl("hate", x = line)) == TRUE) {
        hateLines <- hateLines + 1
    }
}

loveLines / hateLines

close(con)


con <- file("Coursera-SwiftKey/final/en_US/en_US.twitter.txt", "r")
line <- readLines(con, 1)
grepl("aredfvb", x = line) == FALSE
close(con)




