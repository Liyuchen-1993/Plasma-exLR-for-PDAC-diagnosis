#Description
#The core R codes for manuscript gutjnl-2019-318860
#If you have any question of our source code, please contact me at yuchen_li@foxmail.com
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#The tsne method for Dimension reduction and visualization 
library(Rtsne)
tsne <- Rtsne(matrix, dims=3, pca = F, initial_dims = 10, perplexity = 100, max_iter = 500)

#the lasso and random forest algorithm for exLR-seq marker selection 
library(glmnet)
lasso.results <- c()
for (j in 1:1000) {
  n1 <- n[sample(1:nrow(n),ceiling(dim(n)[1]*0.5),replace=F),]
  h1 <- h[sample(1:nrow(h),ceiling(dim(h)[1]*0.5),replace=F),]
  s <- rbind.data.frame(n1,h1)
  ts <- apply(s,2,as.numeric)
  y <- as.matrix(ts[,1])
  x <- as.matrix(ts[,2:dim(ts)[1]])
  cv.fit <- cv.glmnet(x,y,family="binomial", type.measure = "auc", nfolds=5)
  co<-coef.cv.glmnet(cv.fit,s="lambda.1se")
  name <- rownames(co)[co[,1]!=0]
  lasso.results <- c(lasso.results, name)
}
freq.lasso.results <- table(lasso.results)

library(varSelRF)
facy <- factor(training.data$status)
x <- training.data[,-1]
step=varSelRF(x, facy, c.sd = 1, mtryFactor = 1, ntree = 500,
              ntreeIterat = 500, vars.drop.num = NULL, vars.drop.frac = 0.1,
              whole.range = TRUE, recompute.var.imp = FALSE, verbose = FALSE,
              returnFirstForest = TRUE, fitted.rf = NULL, keep.forest = FALSE)
select.history <- step$selec.history


#The training diganostic model construction and SVM algorithm operation
set.seed(1)
library(pROC)
library(caret)
library(e1071)
fitControl <- trainControl(method = "repeatedcv",
                           number = 5,
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

#The establishment of d-signature from three cohort
train.pred <- predict(svmFit,training.data)
validation.pred <- predict(svmFit,validation.data)
testing.pred <- predict(svmFit,testing.data)

#The caculation of diagnostic efficacy of d-signature
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

#The Normfinder method for RT-qPCR
source("r.NormOldStab5.txt")
Result=Normfinder("Datafile.txt",ctVal=FALSE)
selected.exLRs.normfinder.results <- Result$Ordered

