# Text files
#~/Coursera-SwiftKey/final/en_US/en_US.blogs.txt
#~/Coursera-SwiftKey/final/en_US/en_US.news.txt
#~/Coursera-SwiftKey/final/en_US/en_US.twitter.txt

con <- file("Coursera-SwiftKey/final/en_US/en_US.blogs.txt", "r")
line <- readLines(con, 5)
line <- readLines(con, 10)
readLines(con, 1)
close(con)
