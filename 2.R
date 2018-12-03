library("csvread")
library(caret)
ratings<-csvread('ratings.csv',coltypes=c("integer", "integer", "double"), header=TRUE )
movies <- read.csv('movies.csv', header=TRUE, stringsAsFactors=FALSE)
totaldata<-merge(ratings, movies)
totaldata<-totaldata[c(order(totaldata$userId)),]
inTrain <-createDataPartition(y=totaldata$userId, p=0.7, list=FALSE)
training <- totaldata[inTrain,]
testing <- totaldata[-inTrain,]

wssplot <- function(intrain, nc=15, seed=1234){
       wss <- (nrow(intrain)-1)*sum(apply(intrain, 2, var))
     for(i in 2:nc){
             wss[i] <- sum(kmeans(intrain, centers=i)$withinss)
         }
       plot(1:nc, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
   }
 wssplot(intrain)

intrain <- training
intrain$title <-NULL
intrain$genres<-NULL
train.cluster <- kmeans(intrain, centers=3)
plot(intrain, col=train.cluster$cluster)
points(train.cluster$centers, col=1:3, pch=8, cex=2)
table(real=intrain$userId, pred=train.cluster$cluster)


