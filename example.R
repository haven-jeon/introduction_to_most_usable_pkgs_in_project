library(caret)
set.seed(3456)
trainIndex <- createDataPartition(iris$Species, p = 0.8, list = FALSE,  times = 1)
head(trainIndex)

irisTrain <- iris[trainIndex, ]
irisTest <- iris[-trainIndex, ]

plot(iris[,-5])

bxcx <- BoxCoxTrans(irisTrain$Petal.Length, fudge=0.004)

hist(predict(bxcx, irisTrain$Petal.Length))

mdl <- preProcess(irisTrain[,-5], method=c("BoxCox", "center", "scale", "pca"))

transformed <- predict(mdl, irisTrain[,-5])

head(transformed)

plot(transformed)

nearZeroVar(irisTrain)


correlations <- cor(irisTrain[,-5])

library(corrplot)
corrplot(correlations, order="hclust")
  
highCorr <- findCorrelation(correlations, cutoff=.75)

correlations[,highCorr]


# creating dummy variable 

load("carSubset.Rdata")

simp<- dummyVars(~ Mileage + Type, data=carSubset, levelsOnly=TRUE)

predict(simp, head(carSubset))

simp2 <- dummyVars( ~ Mileage + Type + Mileage:Type, data=carSubset, levelsOnly=TRUE)

predict(simp2, head(carSubset))


#######################################
## Classification Example

data(iris)
TrainData <- iris[,1:4]
TrainClasses <- iris[,5]

knnFit1 <- train(TrainData, TrainClasses,
                 method = "knn",
                 preProcess = c("center", "scale"),
                 tuneLength = 10,
                 trControl = trainControl(method = "cv"))

knnFit2 <- train(TrainData, TrainClasses,
                 method = "knn",
                 preProcess = c("center", "scale"),
                 tuneLength = 10, 
                 trControl = trainControl(method = "boot"))


library(MASS)
nnetFit <- train(TrainData, TrainClasses,
                 method = "nnet",
                 preProcess = "range", 
                 tuneLength = 2,
                 trace = FALSE,
                 maxit = 100)

#######################################
## Regression Example

library(mlbench)
data(BostonHousing)

lmFit <- train(medv ~ . + rm:lstat,
               data = BostonHousing, 
               "lm")

library(rpart)
rpartFit <- train(medv ~ .,
                  data = BostonHousing,
                  "rpart",
                  tuneLength = 9)

#######################################
## Example with a custom metric

madSummary <- function (data,
                        lev = NULL,
                        model = NULL) 
{
  out <- mad(data$obs - data$pred, 
             na.rm = TRUE)  
  names(out) <- "MAD"
  out
}

robustControl <- trainControl(summaryFunction = madSummary)
marsGrid <- expand.grid(.degree = 1,
                        .nprune = (1:10) * 2)

earthFit <- train(medv ~ .,
                  data = BostonHousing, 
                  "earth",
                  tuneGrid = marsGrid,
                  metric = "MAD",
                  maximize = FALSE,
                  trControl = robustControl)

#######################################
## Parallel Processing Example via multicore package

## library(doMC)
## registerDoMC(2)

## NOTE: don't run models form RWeka when using
### multicore. The session will crash.

## The code for train() does not change:
set.seed(1)
usingMC <-  train(medv ~ .,
                  data = BostonHousing, 
                  "glmboost")

## or use:
## library(doMPI) or 
## library(doSMP) and so on
