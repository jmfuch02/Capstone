Text Predictor Web Application
========================================================
author: Jason Fuchs
date: August 23, 2015
font-family: 'Helvetica'
transition: fade

Introduction
========================================================

Let's say you're texting a friend. You are typing on your smart phone.
No one likes typing on a phone because it's so slow.
This is where text prediction is useful.
Instead of typing a word, you can simply have the app offer you the most
probable next word in the sentence you're typing.

My algorithm involves two main steps:

1. Creating a sample set to train the algorithm (Preprocessing & Sampling)
2. Using this training set to predict the next word (Prediction Algorithm)

Preprocessing & Sampling
========================================================

The initial training data was a set of three documents.
I took a 10% sample from each file. This was a reasonable amount that
struck a balance between accuracy and speed/size.

Document    | Length (lines)    | Sampled length (lines)
---------   | ---------------   | ---------------------
blogs       | ~900 k            | 90,479
news        | ~1.01 M           | 101,145
twitter     | ~2.36 M           | 236,474

I originally tried 20% and this caused me to run out of memory later on.

Prediction Algorithm: Part I
========================================================

Now that we have a sample to train on, the most common approach to text prediction is to use an n-gram model. We can assume a Markov process here. That is, we can assume the next word depends only on the word or words preceding it. For a bigram (a set of two words), let $w_{i}$ denote the last word in a string of text and let $w_{i-1}$ denote the word immediately preceding it. The probability of the bigram appearing in a test set is calculated as the count of that bigram $c(w_{i-1}w_{i})$ in the training set divided by the total number of bigrams,

$$ p(w_i|w_{i-1})=\frac{c(w_{i-1}w_{i})}{\sum_{w_i}c(w_{i-1}w_{i})} $$

This is the maximum likelihood estimate, or MLE.

Prediction Algorithm: Part II
========================================================

There are several methods for dealing with words or groups of words that have zero probability. The simplest of these methods, known as Laplace smoothing, depends ONLY on the previous word, however. It would not affect the prediction of the final word. There are more complex smoothing algorithms, but I did not use these, although I would like to in future work.

My algorithm does not use smoothing and uses counts instead of probability. It starts with the four-gram. I simply look up the last three words in the text and find the most likely next word based on the highest counted four-gram. If I can't find a similar four-gram, I move to the three-gram, and then on down the line.

This is very basic but seems to give acceptable results.


How the application works
========================================================

Simply type some text into the input box and hit "Enter" or click the "Predict" button. The next most likely word will show up next to the box.
 
The app can be found at https://jmfuch02.shinyapps.io/textPredictor
