모델 튜닝 
========================================================




```r
library(caret)
data(iris)
TrainData <- iris[, 1:4]
TrainClasses <- iris[, 5]

knnFit1 <- train(TrainData, TrainClasses, method = "knn", preProcess = c("center", 
    "scale"), tuneLength = 10, trControl = trainControl(method = "cv"))

print(knnFit1)
```

```
## 150 samples
##   4 predictors
##   3 classes: 'setosa', 'versicolor', 'virginica' 
## 
## Pre-processing: centered, scaled 
## Resampling: Cross-Validation (10 fold) 
## 
## Summary of sample sizes: 135, 135, 135, 135, 135, 135, ... 
## 
## Resampling results across tuning parameters:
## 
##   k   Accuracy  Kappa  Accuracy SD  Kappa SD
##   5   1         0.9    0.05         0.07    
##   7   1         1      0.05         0.07    
##   9   1         0.9    0.05         0.07    
##   10  1         0.9    0.05         0.07    
##   10  1         1      0.05         0.07    
##   20  1         1      0.05         0.07    
##   20  1         1      0.05         0.07    
##   20  1         1      0.05         0.07    
##   20  1         0.9    0.06         0.08    
##   20  1         0.9    0.05         0.08    
## 
## Accuracy was used to select the optimal model using  the largest value.
## The final value used for the model was k = 19.
```

```r

knnFit2 <- train(TrainData, TrainClasses, method = "knn", preProcess = c("center", 
    "scale"), tuneLength = 10, trControl = trainControl(method = "boot"))

print(knnFit2)
```

```
## 150 samples
##   4 predictors
##   3 classes: 'setosa', 'versicolor', 'virginica' 
## 
## Pre-processing: centered, scaled 
## Resampling: Bootstrap (25 reps) 
## 
## Summary of sample sizes: 150, 150, 150, 150, 150, 150, ... 
## 
## Resampling results across tuning parameters:
## 
##   k   Accuracy  Kappa  Accuracy SD  Kappa SD
##   5   0.9       0.9    0.03         0.04    
##   7   0.9       0.9    0.03         0.04    
##   9   0.9       0.9    0.02         0.04    
##   10  1         0.9    0.02         0.04    
##   10  1         0.9    0.02         0.04    
##   20  0.9       0.9    0.02         0.03    
##   20  0.9       0.9    0.02         0.04    
##   20  0.9       0.9    0.03         0.04    
##   20  0.9       0.9    0.02         0.04    
##   20  0.9       0.9    0.02         0.04    
## 
## Accuracy was used to select the optimal model using  the largest value.
## The final value used for the model was k = 13.
```


