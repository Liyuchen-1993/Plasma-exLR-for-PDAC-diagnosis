## The SVM classifier construction in training cohort

For binary (PDAC vs CP/Healthy) sample classification, the support vector machine (SVM) algorithm was performed by the “e1071” R software package. In principal, the SVM algorithm determines the location of all samples in a high dimensional space, of which each axis represents an exLR included and the sample expression level of a particular exLR determines the location on the axis. During the training process, the SVM algorithm draws a hyperplane best separating two classes, based on the distance of the closest sample of each class to the hyperplane. The different sample classes were positioned at each side of the hyperplane. Moreover, in order to assess the predictive value of the SVM algorithm on an independent dataset, which is not previously involved in the SVM training process, the algorithm was trained on the training dataset, all SVM parameters were fixed, and the samples belonging to the validation and independent cohort were predicted. Internal training performance of the SVM algorithm could be improved by enabling the SVM tuning function, which implies optimal determination of parameters of the SVM algorithm (gamma, cost) by randomly sub-sampling the dataset used for training (‘‘5-fold internal
cross-validation’’) of the algorithm.

```
svmFit <- train(status ~ ., data = training.data, 

​            method = "svmRadial", 

​            trControl = fitControl, 

​            preProc = c("center", "scale"),

​            tuneLength = 8,

​            metric = "ROC")
```



## The establishment of d-signature from three cohort

The d-signature is computed from the predict strength of support vector machine (SVM) classifier output. We used SVM algorithm (“e1071” package from R) for the binary sample classification (in this study: PDAC vs Healthy/CP). During the training process, the SVM algorithm draws a hyperplane best separating two classes and provides the qualitative predict label for input sample. To assess the probability on how much the samples was predict as PDAC, we used the R function “predict” to evaluate the predict strength in
quantitative value on validation and independent cohort. The predict strength of SVM classifier output was served as the d-signature. The SVM algorithm predicts the d-signature score for the combination of eight markers but not for each markers. 

```
train.pred <- predict(svmFit,training.data)

validation.pred <- predict(svmFit,validation.data)

testing.pred <- predict(svmFit,testing.data)
```



## The calculation of diagnostic efficacy of d-signature

```
train.con <- confusionMatrix(train.pred, training.data$status)

validation.con <- confusionMatrix(validation.pred, validation.data$status)

testing.con <- confusionMatrix(testing.pred, testing.data$status)
```

```
tr.acc <- train.con$overall[1]

tr.se <- train.con$byClass[1]

tr.sp <- train.con$byClass[2]

va.acc <- validation.con$overall[1]

va.se <- validation.con$byClass[1]

va.sp <- validation.con$byClass[2]

te.acc <- testing.con$overall[1]

te.se <- testing.con$byClass[1]

te.sp <- testing.con$byClass[2]
```
