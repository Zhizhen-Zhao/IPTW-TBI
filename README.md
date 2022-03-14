# IPTW-TBI
## 1. Introduction
This repository contains source code for paper "Data Imputation for Clinical Trial Emulation: A Case Study on Impact of Intracranial Pressure Monitoring for Traumatic Brain Injury".

Randomized clinical trial emulation using real-world data is significant for treatment effect evaluation. Missing values are common in the observational data. In this paper, we selected one proper methodology to deal with the missing data issue in the estimation of average treatment effect(ATE) in the observational study. Since the ground truth of treatment effect in RWD is not available, we performed four different imputation strategies and a complete data analysis on two benchmark datasets (Twins and IHDP) to estimate ATE through inverse probability of treatment weighting (IPTW).

Multiple imputation is valid under the assumption of MAR that missing data are related to other available characteristics and are random conditional on other observed variables. MI imputes missing values multiple times through random draws from distributions inferred from available data. We adopted one popular approach, multiple imputation by chained equations (‘MICE’) to fill in missing data in baseline covariates. MICE consists of three steps shown in Figure 1: generate m imputed datasets, analyze the imputed data, and pool the analysis results.

![mice_new](https://user-images.githubusercontent.com/79823323/158080345-91f54fa8-57f6-4519-a84c-a404922df267.png)

Figure 1: Three steps used in MI: The first step is to create multiple $m$ imputed datasets where missing values are replaced by m plausible values through random draws. k_ij^s represents the imputed data for the (i,j) missing value during the s-th iteration, where s = 1,...,m. Next is to estimate ATE \hat\tau for each imputed dataset by IPTW separately. The last step is to pool the results obtained in each imputed dataset together to arrive at a single ATE estimation \hat\tau. 

In addition, we conducted a case study to evaluate the effect of ICP monitoring on in-hospital mortality among patients with severe traumatic brain injury (TBI). Record-level National Trauma Data Bank (NTDB) data for patients with TBI from 2017 to 2018 were analyzed in the study.

## 2. Datasets
Benchmark datasets can be found at https://github.com/AMLab-Amsterdam/CEVAE/tree/master/datasets.

NTDB dataset can be requested at https://www.facs.org/quality-programs/trauma/tqp/center-programs/ntdb. Variable descriptions are included. 
In our case study, 18 pre-treatment covariates were selected. Covariates description and their missing ratios in the original dataset are shown in Table 1. 




| Covariate     | Description   | Type          | Missing Rate (%) |
| ------------- | ------------- | ------------- | ------------- |
| AGEYears      | Age (years)  | Continuous | 2.84  |
| TRANSPORTMODE   | Transport Mode  | Categorical | 0.46  |
| EMSSBP      | Initial EMS Systolic Blood Pressure  | Continuous  | 37.09  |
| EMSPULSERATE   | Initial EMS Pulse Rate | Continuous  | 32.93|
| EMSTOTALGCS      | EMS Total GCS  | Continuous  | 32.60  |
| EMSMins  | Time from dispatch to ED/hospital arrival (mins)  | Continuous  | 19.69  |
|INTERFACILITYTRANSFER       |Inter-Facility Transfer  |  Binary  | 0 |
| EDMins   | Total time between ED/hospital arrival and ED discharge (mins) | Continuous  | 7.15  |
| SBP      | Systolic Blood Pressure | Continuous  | 1.57  |
| PULSERATE   | Pulse Rate  | Continuous | 1.06  |
| RESPIRATORYRATE      | Respiratory Rate  | Continuous  | 5.77  |
| RESPIRATORYASSISTANCE   | Respiratory Assistance |Binary  | 3.17  |
| TOTALGCS      | Total GCS  | Continuous | 0  |
| TBIMIDLINESHIFT  | Midline Shift | Categorical  | 1.23  |
| BLOOD4HOURS    | Transfusion Blood (4 Hours)  | Continuous  | 0.05 |
| HOSPITALTYPE      | Hospital Type  | Categorical  | 0.25  |
| BEDSIZE  | Bed size |Continuous  | 0  |
| VERIFICATIONLEVEL  | ACS Verification Level  | Categorical | 24.73  |

Table 1: Full list of covariates
