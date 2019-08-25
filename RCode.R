

#the tsne method for Dimension reduction and visualization 
library(Rtsne)
tsne <- Rtsne(matrix, dims=3, pca = F,initial_dims = 10,perplexity = 100,max_iter = 500)

#the lasso and random forest algorithm for exLR-seq marker selection 
n <- training.Norm.data <- training.data[,1: train.zero.sum]
h <- training.PDAC.data <- training.data[,c(train.zero.sum+1): dim(training.data)[2]]
library(glmnet)
lasso.results <- c()
for (j in 1:1000) {
  n1 <- n[,sample(1:ncol(n),ceiling(dim(n)[2]*0.8),replace=F)]
  h1 <- h[,sample(1:ncol(h),ceiling(dim(h)[2]*0.8),replace=F)]
  s <- cbind(n1,h1)
  ts <- t(s)
  ts <- apply(ts,2,as.numeric)
  y <- as.matrix(ts[,1])
  x <- as.matrix(ts[,2:dim(data1)[1]])
  cv.fit <- cv.glmnet(x,y,family="binomial",type.measure = "auc",nfolds=5)
  co<-coef.cv.glmnet(cv.fit,s="lambda.1se")
  name <- rownames(co)[co[,1]!=0]
  lasso.results <- c(lasso.results, name)
}
freq.lasso.results <- table(lasso.results)
library(varSelRF)
facy <- factor(training.data$status)
x <- training.data[,-1]
step=varSelRF(x, facy, c.sd = 1, mtryFactor = 1, ntree = 5000,
              ntreeIterat = 2000, vars.drop.num = NULL, vars.drop.frac = 0.3,
              whole.range = TRUE, recompute.var.imp = FALSE, verbose = FALSE,
              returnFirstForest = TRUE, fitted.rf = NULL, keep.forest = FALSE)
select.history <- step$selec.history

#the training diganostic model construction and SVM algorithm operation
library(pROC)
library(caret)
library(e1071)
fitControl <- trainControl(method = "repeatedcv",
                           number = 10,
                           repeats = 10,
                           ## Estimate class probabilities
                           classProbs = TRUE,
                           ## Evaluate performance using 
                           ## the following function
                           summaryFunction = twoClassSummary)

svmFit <- train(status ~ ., data = training.data, 
                method = "svmRadial", 
                trControl = fitControl, 
                preProc = c("center", "scale"),
                tuneLength = 8,
                metric = "ROC")
train.pred <- predict(svmFit,training.data)
validation.pred <- predict(svmFit,validation.data)
testing.pred <- predict(svmFit,testing.data)

#the caculation of diagnostic efficacy
train.con <- confusionMatrix(train.pred, training.data$status)
validation.con <- confusionMatrix(validation.pred, validation.data$status)
testing.con <- confusionMatrix(testing.pred, testing.data$status)
tr.acc <- train.con$overall[1]
tr.se <- train.con$byClass[1]
tr.sp <- train.con$byClass[2]
va.acc <- validation.con$overall[1]
va.se <- validation.con$byClass[1]
va.sp <- validation.con$byClass[2]
te.acc <- testing.con$overall[1]
te.se <- testing.con$byClass[1]
te.sp <- testing.con$byClass[2]
training.accuracy <- c(training.accuracy,tr.acc)
training.sensitivity <- c(training.sensitivity,tr.se)
training.specificity <- c(training.specificity,tr.sp)
validation.accuracy <- c(validation.accuracy,va.acc)
validation.sensitivity <- c(validation.sensitivity,va.se)
validation.specificity <- c(validation.specificity,va.sp)
testing.accuracy <- c(testing.accuracy,te.acc)
testing.sensitivity <- c(testing.sensitivity,te.se)
testing.specificity <- c(testing.specificity,te.sp)
#



