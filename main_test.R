library(XML)
library(dplyr)

rm(list = ls())

start <- 1
book_list <- read.csv("books.csv", header = FALSE)
book_list <- as.matrix(book_list)
chapter_list <-  read.csv("chapters.csv", header = FALSE, sep = ",")
chapter_list <- as.matrix(chapter_list)

domain <- 'http://www.bibles.co.za/search/search-detail.php?prev=-2&book='
n = 66
LAN = 3

for (i in 1:n){
  book = book_list[i]
  k = chapter_list[i]
  for (j in 1:k) {
    url = paste(domain, book,  "&chapter=", j, 
                "&version=", LAN, "&GO=Show", sep = "")
    verses <-  readHTMLTable(url, header=T, which=1,stringsAsFactors=F)
    verses <- mutate(verses, book = book, chapter = j)
    
    if(start==1){
      bible <- verses
      start <- 0
      }
    else{
      bible <- bind_rows(bible, verses)
      print(i)
      }
  }
}
write.csv(bible, file = "bible_xhosa.csv")
  