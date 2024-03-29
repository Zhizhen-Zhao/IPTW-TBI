library(mice)
library(WeightIt)
library(missMethods)
library(MatchThem)

set.seed(1234)
write(sample(1:10000000,size=1000),file="seeds.txt",ncolumns=1)
seeds = read.table("seeds.txt",header=F)$V1
# other datasets can be performed in the same way
ihdp = read.csv('ihdp_cleaned.csv')
ihdp_cov = ihdp[,2:26]
covariate_name = colnames(ihdp_cov)

for (i in 1:1000){
    set.seed(seeds[i])
    # randomly select 20 covs
    a = sample.int(25,12)
    b = setdiff(sample.int(25, 25),a)[1:12] 
   
    # genearte missing ratios in Experiment 1
    # miss_r =runif(20, min = 0, max = 0.8)
   
    # generate missing ratios in Experiment 2
    p1 = runif(3, min = 0.3, max = 0.4)
    p2 = runif(2, min = 0.2, max = 0.3)
    p3 = runif(5, min = 0.01, max = 0.1)
    p4 = runif(2, min = 0, max = 0.01)
     
    miss_r = c(p1,p2,p3,p4)
    
    # create missing data under MAR
    ds_mar = delete_MAR_censoring(ds = ihdp_cov, p = miss_r, cols_mis = covariate_name[a], cols_ctrl = covariate_name[b])
    init = mice(ds_mar, maxit=0) 
    meth = init$method
    predM = init$predictorMatrix
    
    # select different imputation models for different caovariates
    # continuous 
    meth[c("V6" , "V7",  "V8",  "V9",  "V10", "V11")]="pmm"     
    # binary
    meth[c("V12", "V13", "V14", "V15", "V16", "V17", "V18", "V19" ,"V20", "V21", "V22", "V23" ,"V24", "V25", "V26", "V27", "V28", "V29", "V30")] = "logreg" 
        
    # missing data imputation
    tempData = mice(ds_mar, method=meth, predictorMatrix=predM, m = 5, maxit = 5)  # change m
    
    # IPTW for each generated data
    weighted.datasets = weightthem(ihdp$V1 ~ V6 + V7 + V8 + V9 + V10 + V11 +
                                     V12 + V13 + V14 + V15 + V16 + V17 + V18 + V19 + V20 + 
                                     V21+ V22 + V23 + V24 + V25 + V26 + V27 + V28 + V29 + V30, 
                                   tempData,
                                   approach = 'within',
                                   method = 'ps',
                                   estimand = "ATE"
                                   ,stabilize = TRUE )
    # ATE estimations and pooled result                               
    models = with(weighted.datasets, lm(as.numeric(ihdp$outcome)~ihdp$V1))
    results = summary(pool(models), conf.int = TRUE,conf.level = 0.95) 
    
    write(c(results$estimate[2], results$p.value[2],  results$std.error[2]), "ihdp_mi.txt", ncol=3, append=T)

}

bias = mean(results_imputation$V1) - true_ate
se = sqrt(var(results_imputation$V1))