# Clean Shiny deploy

# FUNCTION: Take in one word, return table showing top 5 next words and counts
getNextWordBigram <- function(word) {
    
    word <- tolower(word)
    results <- term2Freq[grep(paste0(word, " "), names(term2Freq),
                              fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(word)) == word]
    ordResults <- order(-results)
    return(names(results[head(ordResults, 5)]))
    
}

# Same thing for tri-grams
getNextWordTrigram <- function(w1, w2) {
    
    w1 <- tolower(w1)
    w2 <- tolower(w2)
    results <- term3Freq[grep(paste0(w1, " ", w2, " "), names(term3Freq),
                              fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(w1)) == w1]
    ordResults <- order(-results)
    return(names(results[head(ordResults, 5)]))
    
}

# Now do 4-grams
getNextWordFourgram <- function(w1, w2, w3) {
    
    w1 <- tolower(w1)
    w2 <- tolower(w2)
    w3 <- tolower(w3)
    results <- term4Freq[grep(paste0(w1, " ", w2, " ", w3, " "),
                              names(term4Freq), fixed = TRUE)]
    results <- results[substring(names(results), 1, nchar(w1)) == w1]
    ordResults <- order(-results)
    return(names(results[head(ordResults, 5)]))
    
}

# Given a string, get the last n words
getLastWords <- function(textString, n) {
    
    s <- strsplit(textString, " ")
    if (length(s) != 0) {
        if (length(s[[1]]) < n) { n <- length(s[[1]]) }
        r <- s[[1]][(length(s[[1]]) - n + 1):(length(s[[1]]))]
    } else { r <- character(0) }
    return(r)
}

# The main model, takes in string and predicts next word
predictNextWord <- function (textString) {
    
    w <- rev(getLastWords(textString, 3))
    lw <- character(0)
    
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

