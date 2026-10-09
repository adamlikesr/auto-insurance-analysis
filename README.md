# Automobile Insurance Risk Analysis Using SAS

## Project Overview
This SAS project analyzes 67,856 auto insurance policies from 2004 to 2005, using this data to investigate how driver and vehicle characteristics contribute to insurance risk.

This analysis is centered around three actuarial metrics:
- **Claim Frequency:** How frequently is an insurance claim made?
- **Claim Severity:** What is the average cost per claim?
- **Pure Premium:** What is the average insurance loss per policy year?

The objective is to identify key differences in insurance risk across policyholder groups and analyze the reliability of the observed loss costs.

## Tools Used
- SAS Programming
- SAS DATA Steps
- PROC MEANS, PROC FREQ, PROC SORT, PROC SGPLOT
- Data Cleaning and Validation
- Exploratory Data Analysis (EDA)
- Actuarial Risk Analysis
- Risk Segmentation
- Data Visualization

## About the Dataset
The project uses the Australian Automobile Insurance dataset (dataCar) from the R package insuranceData.

The dataset contains 67,856 auto insurance policy records.

Some key variables include:
| Variable | Description |
|----------|-------------|
| veh_value | Vehicle value |
| exposure | Insurance exposure in policy-years |
| numclaims | Number of insurance claims |
| claimcst0 | Total claim costs |
| agecat | Driver age category |
| veh_age | Vehicle age category |
| veh_body | Vehicle body type |
| gender | Driver gender |
| area | Geographic area |

## Methodology

### 1. Cleaning Data and Performing Exploratory Data Analaysis

Imported the data into SAS, checked for any missing values, outliers and unusual variable distributions.

Used descriptive statistics and visualizations to investigate risk variables and historical claims.

### 2. Claim Frequency Analysis

Calculated the claim frequency adjusted for exposure across risk variables including driver age, vehicle age, vehicle type, gender, and geographic area.

**Formula:**
Claim Frequency = Total Claims Made / Total Exposure

### 3. Claim Severity Analysis

Calculated the average cost per claim (severity) across the previously mentioned risk variables.

**Formula:**
Severity = Total Claim Cost / Total Claims Made

The overall severity across the entire dataset was approximately **$1,886.69 per claim**.

### 4. Pure Premium Analysis

Calculated historical insurances losses per policy year.

**Formula:**
Pure Premium = Total Claim Costs / Total Exposure

The overall observed pure premium was **$292.90 per policy year**.

### 5. Multivariate Risk Segmentation

Analyzed combinations of drive age and vehicle age to determine if there differences in claim frequency, severity, and pure premium costs.

Investigated total exposure within the risk segments to evaluate the reliability of observed loss costs.

## Key Findings

### Claim Frequency
- Claim frequency generally decreased as driver age increased
- Area F had the highest observed claim frequency among the six areas
- Buses had the highest observed claim frequency, but also made up a small proportion of insured vehicles in the dataset

### Pure Premium
- Driver age category 1 (the youngest drivers) exhibited the highest observed pure premiums
- Area F exhibited the highest pure premiums amongst all areas
- Coupes exhibited the highest pure premiums amongst all car types

### Risk Segmentation
- The four highest observed pure premiums across age category and vehicle age category belonged to age group 1
- Five of the lowest exposure lengths also belonged to age group 1
- Due to a smaller exposure length relative to the rest of the dataset, there may be increased variability in the pure premium estimates

## Project Limitaions
This project uses strictly statistical analysis and does not establish relationships between policyholder characteristics and insurance risk

Some risk segments have relatively low exposure as discussed earlier, which could produce less reliable estimates

This analysis focuses on historical data and loss costs rather than predictive modeling or pricing

## Conclusion

This project demonstrates how to use fundamental acturaial metrics to analyze insurance risks in automobiles

The findings highlight the significance of exposure adjusted measurements for reliability, risk segmentation, and evaluating the reliability of historical claims experience.
