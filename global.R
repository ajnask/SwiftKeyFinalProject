library(stringi)
library(stylo)
library(stringr)
library(quanteda)
library(data.table)
library(dplyr)

#library(doParallel)
load("fivepercent.RData")
#load("onepercent.RData")
# Generic function for parallelizing any task (when possible)
# parallelizeTask <- function(task, ...) {
#         # Calculate the number of cores
#         ncores <- detectCores() - 1
#         # Initiate cluster
#         cl <- makeCluster(ncores)
#         registerDoParallel(cl)
#         #print("Starting task")
#         r <- task(...)
#         #print("Task done")
#         stopCluster(cl)
#         r
# }

preprocess <- function(x){
        x <- tolower(x)
        #x <- removeWords(x, stopwords("english"))
        #x <- gsub("  ", " ",x)
        x <- iconv(x = x,from = "latin1", "ASCII",sub="")
        x <- gsub("\u0094","", gsub("\u0093","", gsub("\u0092","'",x)))
        x <- gsub("'ll"," will",x, ignore.case = TRUE)
        x <- gsub("'m"," am",x, ignore.case = TRUE)
        x <- gsub("can't","can not",x, ignore.case = TRUE)
        x <- gsub("won'?t","will not",x, ignore.case = TRUE)
        x <- gsub("ain'?t","am not",x, ignore.case = TRUE)
        x <- gsub("n't"," not",x, ignore.case = TRUE)
        x <- gsub("'ve"," have",x, ignore.case = TRUE)
        x <- gsub("it's","it is",x, ignore.case = TRUE)
        x <- gsub("he's","he is",x, ignore.case = TRUE)
        x <- gsub("why's","why is",x, ignore.case = TRUE)
        x <- gsub("where's","where is",x, ignore.case = TRUE)
        x <- gsub("\\bb\\b", "be", x)
        x <- gsub("\\bc\\b", "see", x)
        x <- gsub("\\br\\b", "are", x)
        x <- gsub("\\bu|ya\\b", "you", x)
        x <- gsub("\\by\\b", "why", x)
        x <- gsub("'d"," would",x, ignore.case = TRUE)
        x <- gsub("when's","when is",x, ignore.case = TRUE)
        x <- gsub("what's","what is",x, ignore.case = TRUE)
        x <- gsub("how's","how is",x, ignore.case = TRUE)
        x <- gsub("there's","there is",x, ignore.case = TRUE)
        x <- gsub("here's","here is",x, ignore.case = TRUE)
        x <- gsub("'re"," are",x, ignore.case = TRUE)
        x <- gsub("she's","she is",x, ignore.case = TRUE)
        x <- gsub("that's","that is",x, ignore.case = TRUE)
        x <- gsub("#\\S+","",x, ignore.case = TRUE)
        x <- gsub("@\\S+","",x, ignore.case = TRUE)
        #x <- stripWhitespace(x)
        return(x)
}


predictwords <- function(inputPhrase){
        input <- txt.to.words(preprocess(inputPhrase))
        numwords <- length(input)
        if(numwords > 4){
                numwords <- 4
                input <- tail(input,4)
        }
        result <- NULL
        for (i in numwords:2) {
                nextword <- NULL
                match <- NULL
                # nextword <- parallelizeTask(getnextword,tail(input, i))
                # nextword <- parallelizeTask(breakword,nextword)
                nextword <- getnextword(tail(input,i))
                nextword <- breakword(nextword)
                match <- nextword$ngram %in% result$ngram
                result <- rbind(result, nextword[!match])
                
        }
        rm(nextword)
        if (nrow(result)==0) {
                
                # when the loop reaches ngram1, it should just return the top 4 common words
                result <- dts[n==1][1:5,1:2]
                names(result) <- c("word","score")
                return(result)
                break
                
        } 
        #if the match is non zero
        #result <- parallelizeTask(predProb,result,numwords)
        result <- predProb(result, numwords)
        
        if( nrow(result) > 5){
                return(result[1:5][,2:3])
        } else {
                return(result[1:nrow(result)][,2:3])
        }
        
        
}

predictedword <- function(inputPhrase){
        Words <- predictwords(inputPhrase)
        return(Words$word[1])
}

breakword <- function(x){
        
        x$ngram <- word(x$ngram, -1, sep = "_")
        return(x)
}


predProb <- function(word,numwords){
        
        occurances <- word %>% group_by(n) %>% summarise(total = sum(count))
        word <- merge(x = word,y = occurances, by = "n")
        word <- mutate(word, count = (count/total)*0.4^(numwords - n +1)) #%>% arrange(desc(count))
        word <- as.data.table(word)
        word <- word[order(-count)]
        names(word)[2:3] <- c("word","score")
        #return(as.data.table(word))
        return(word)
}


getnextword <- function(input){
        regex <- paste("^",paste(input, collapse = "_"),"_",sep = "")
        #match <- dts[[n+1]][grep(pattern = regex,x = dts[[n+1]][,ngram])]
        temp <- dts[n==(length(input)+1)]
        temp <- temp[grep(pattern = regex,x = temp$ngram)]
        return(temp)
}
