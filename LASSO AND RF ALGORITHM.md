# **The lasso and random forest algorithm for exLR-seq marker selection** 



## Two statistical learning algorithms, least absolute shrinkage and selection operator (LASSO) and random forest based on the out-of-bag (OOB) error, were used to shrink sparse high-dimensional data in the training cohort. 

For LASSO regularization, 50% of the training cohort was randomly sampled to process LASSO regression in 1,000 repetitions. We used 5-fold cross-validation and the Akaike information criterion to estimate the expected generalization error and then selected optimal value of “1-se” lambda parameter to construct an adaptive general linear model for marker selection. 

```
library(glmnet)`

`lasso.results <- c()`

`for (j in 1:1000) {`

  `n1 <- n[sample(1:nrow(n),ceiling(dim(n)[1]*0.5),replace=F),]`

  `h1 <- h[sample(1:nrow(h),ceiling(dim(h)[1]*0.5),replace=F),]`

  `s <- rbind.data.frame(n1,h1)`

  `ts <- apply(s,2,as.numeric)`

  `y <- as.matrix(ts[,1])`

  `x <- as.matrix(ts[,2:dim(ts)[1]])`

  `cv.fit <- cv.glmnet(x,y,family="binomial", type.measure = "auc", nfolds=5)`

  `co<-coef.cv.glmnet(cv.fit,s="lambda.1se")`

  `name <- rownames(co)[co[,1]!=0]`

  `lasso.results <- c(lasso.results, name)`

`}`

`freq.lasso.results <- table(lasso.results)`


```

For the random forest method, the OOB error was used as a minimizing criterion to select variates, and the
dropping fraction parameter was set at 0.1 between two shrinking steps. 

```
library(varSelRF)`

`facy <- factor(training.data$status)`

`x <- training.data[,-1]`

`step=varSelRF(x, facy, c.sd = 1, mtryFactor = 1, ntree = 500,`

​          `ntreeIterat = 500, vars.drop.num = NULL, vars.drop.frac = 0.1,`

​          `whole.range = TRUE, recompute.var.imp = FALSE, verbose = FALSE,`

​          `returnFirstForest = TRUE, fitted.rf = NULL, keep.forest = FALSE)`

`select.history <- step$selec.history`


```

