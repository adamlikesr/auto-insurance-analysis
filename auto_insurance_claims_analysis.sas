/* =========================================

   Automobile Insurance Risk Analysis

   Adam Estrellado

   ========================================= */

/* 1. Import data */
data car_insurance;
infile "/home/u64579987/auto_insurance.csv" dlm = "," dsd firstobs = 2;
input veh_value exposure clm numclaims claimcst0 veh_body $ veh_age gender $ area $ agecat$;


/* 2. Data cleaning */

* Check variables, data types;
proc contents data = car_insurance;
run;
* Check for empty values;
proc means data = car_insurance n nmiss;
run;

* Check data for outliers, large values;
proc means data = car_insurance min max mean median stddev;
var exposure clm numclaims;
run;

* Run some basic statistics;
proc means data = car_insurance;
var veh_value exposure numclaims claimcst0;
run;

/* Findings:
	Average exposure: 0.4686515
	Average number of claims: 0.0727570
	Largest claim cost: $55,922.13
	Average vehicle value: $17,770.21
*/


* Check frequency of claims;
proc freq data = car_insurance;
tables numclaims;
run;

* Analyze claim costs;
proc means data = car_insurance;
var claimcst0;
where claimcst0 > 0; * Filter for claims greater than $0;
run;

/*
4,624 claims made
Average claim cost: $2,014.40
*/


* Plot claim costs on histogram;
proc sgplot data = car_insurance;
where claimcst0 > 0;
histogram claimcst0;

title "Distribution of Automobile Claim Costs";
xaxis label = "Claim Cost in Dollars";

run;

/*
Appears to be heavily right skewed.
Over 60% of claims are relatively small.
*/


* Analyze risk variables;
proc freq data = car_insurance;
tables veh_body veh_age gender area agecat;
run;

* Plot frequency of car types;
proc sgplot data = car_insurance;
vbar veh_body;
title "Frequency of Car Types";
xaxis label = "Car Type";
yaxis label ="Number of Policies";
run;

/*
Sedans, hatchbacks, and station wagons
have the highest frequency of policies
*/


/* 4. Claim Frequency Analysis */

* Total claim frequency;
proc means data = car_insurance sum;
var numclaims exposure;
run;

* Sum the claims and exposure by age category;
proc means data = car_insurance NWAY sum;
class agecat;
var numclaims exposure;
output out = age_claims
sum(numclaims) = age_claims_total
sum(exposure) = age_claims_exposure;
run;

* Calculate the frequency of claims by age;
data age_claims;
set age_claims;
claim_frequency = age_claims_total / age_claims_exposure;
format claim_frequency percent8.2
run;

* Plot the claim frequency against age;
proc sgplot data = age_claims;
vbar agecat / response = claim_frequency;
xaxis label = "Age Category of Policyholder";
yaxis label = "Frequency of Claims";

title "Claim Frequency by Age Category";
run;
/*
As age group increases, the frequency of claims made decreases
*/

* Sum the claims and exposure by vehicle age;
proc means data = car_insurance NWAY sum;
class veh_age;
var numclaims exposure;
output out = veh_age_claims
sum(numclaims) = veh_age_claims_total
sum(exposure) = veh_age_exposure;
run;

* Calculate the frequency by vehicle age; 
data veh_age_claims;
set veh_age_claims;
claim_frequency = veh_age_claims_total / veh_age_exposure;
format claim_frequency percent8.2;
run;

* Plot the claim frequency against vehicle age;
proc sgplot data = veh_age_claims;
vbar veh_age / response = claim_frequency;
xaxis label = "Age Category of Vehicle";
yaxis label = "Frequency of Claims";

title "Claim Frequency by Vehicle Category";
run;

/* Vehicle age group 2 has the highest frequency of claims, followed
by a decrease in claim frequency in groups 3 and 4
*/

* Sum the claims by area category;
proc means data = car_insurance NWAY sum;
class area;
var numclaims exposure;
output out = area_claims
sum(numclaims) = area_numclaims
sum(exposure) = area_exposure;
run;

* Calculate frequency of claims by area;
data area_claims;
set area_claims;
claim_frequency = area_numclaims / area_exposure;
format claim_frequency percent8.2;
run;

* Plot the claim frequency against area category;
proc sgplot data = area_claims;
vbar area / response = claim_frequency;
xaxis label = "Area Category";
yaxis label = "Frequency of Claims";

title "Claim Frequency by Area";
run;

/* 
Area F has the highest frequency of claims at 17.57 claims per
100 policy years 
*/

* Sum the claims by gender;
proc means data = car_insurance NWAY sum;
class gender;
var numclaims exposure;
output out = gender_claims
sum(numclaims) = gender_numclaims
sum(exposure) = gender_exposure;
run;

* Calculate frequency of claims by gender;
data gender_claims;
set gender_claims;
claim_frequency = gender_numclaims / gender_exposure;
format claim_frequency percent8.2;
run;

* Plot the claim frequency against gender;
proc sgplot data = gender_claims;
vbar gender / response = claim_frequency;
xaxis label = "Gender";
yaxis label = "Frequency of Claims";
title "Claim Frequency by Gender";
run;

/* Men and women share similar claim frequencies (F = 15.77, M = 15.20) */


* Sum the claims by vehicle type;
proc means data = car_insurance NWAY sum;
class veh_body;
var numclaims exposure;
output out = veh_body_claims
sum(numclaims) = veh_body_numclaims
sum(exposure) = veh_body_exposure;
run;

* Calculate frequency;
data veh_body_claims;
set veh_body_claims;
claim_frequency = veh_body_numclaims / veh_body_exposure;
format claim_frequency percent8.2;
run;

* Plot vehicle type against claims frequency;
proc sgplot data = veh_body_claims;
vbar veh_body / response = claim_frequency; 
xaxis label = "Vehicle Type";
yaxis label = "Claim Frequency";
title "Claim Frequency by Car Type";
run;

/* Buses have the highest claim frequency at 38.69 claims per 100 policy years */

* Note that buses make the 2nd smallest proportion of insured cars in this
dataset at 0.07%;
proc freq data = car_insurance;
table veh_body; 
run;


/* 5. Claim Severity Analysis */

* Calculate total severity (total claim cost / number of claims);
proc means data = car_insurance NWAY sum;
var claimcst0 numclaims;
run;

* We get total claim cost = 9314604.44, total claims = 4937.00
hence, our total severity = (9314604.44 / 4937.00) = $1886.69

* We now repeat the process in section 4 to analyze the severity by risk variable;

* Sum the claim cost and number of claims by age;
proc means data = car_insurance NWAY sum;
class agecat;
var numclaims claimcst0;
output out = age_severity
sum(numclaims) = age_claims_total
sum(claimcst0) = age_claims_cost;
run;

* Calculate the severity by age;
data age_severity;
set age_severity;
severity = age_claims_cost / age_claims_total;
format severity dollar12.2;
run;

* Plot the claim frequency against age;
proc sgplot data = age_severity;
vbar agecat / response = severity;
xaxis label = "Age Category of Policyholder";
yaxis label = "Severity";

title "Severity per Claim by Age Category";
run;

/* Age group 1 has the highest severity at $2,490.23 per claim */

* Sum the claim cost and number of claims by vehicle age;
proc means data = car_insurance NWAY sum;
class veh_age;
var numclaims claimcst0;
output out = veh_age_severity
sum(numclaims) = veh_age_claims_total
sum(claimcst0) = veh_age_cost;
run;

* Calculate the severity by vehicle age; 
data veh_age_severity;
set veh_age_severity;
severity = veh_age_cost / veh_age_claims_total;
format severity dollar12.2;
run;

* Plot the severity against vehicle age;
proc sgplot data = veh_age_severity;
vbar veh_age / response = severity;
xaxis label = "Age Category of Vehicle";
yaxis label = "Severity";

title "Severity per Claim by Vehicle Category";
run;

/* Vehicle age group 4 has the highest severity at $2,026.09 per claim */

* Sum the number of claims and claim cost by age category;
proc means data = car_insurance NWAY sum;
class area;
var numclaims claimcst0;
output out = area_severity
sum(numclaims) = area_numclaims
sum(claimcst0) = area_cost;
run;

* Calculate severity by area;
data area_severity;
set area_severity;
severity = area_cost / area_numclaims;
format severity dollar12.2;
run;

* Plot the severity against area category;
proc sgplot data = area_severity;
vbar area / response = severity;
xaxis label = "Area Category";
yaxis label = "Severity";

title "Severity per Claim by Area";
run;

/* 
Area F has the highest severity at $2,629.36 per claim
*/

* Sum the number of claims and claim cost by gender;
proc means data = car_insurance NWAY sum;
class gender;
var numclaims claimcst0;
output out = gender_severity
sum(numclaims) = gender_numclaims
sum(claimcst0) = gender_cost;
run;

* Calculate severity by gender;
data gender_severity;
set gender_severity;
severity = gender_cost / gender_numclaims;
format severity dollar12.2;
run;

* Plot severity against gender;
proc sgplot data = gender_severity;
vbar gender / response = severity;
xaxis label = "Gender";
yaxis label = "Severity";
title "Severity Per Claim by Gender";
run;

/* Men have a higher severity at $2,093.04 per claim */


* Sum the claim cost and number of claims by vehicle type;
proc means data = car_insurance NWAY sum;
class veh_body;
var numclaims claimcst0;
output out = veh_body_severity
sum(numclaims) = veh_body_numclaims
sum(claimcst0) = veh_body_cost;
run;

* Calculate severity;
data veh_body_severity;
set veh_body_severity;
severity = veh_body_cost / veh_body_numclaims;
format severity dollar12.2;
run;

* Plot vehicle type against severity;
proc sgplot data = veh_body_severity;
vbar veh_body / response = severity; 
xaxis label = "Vehicle Type";
yaxis label = "Severity";
title "Severity Per Claim by Vehicle Type";
run;

/* Minibuses have the highest severity at $2,580.11 per claim */



/* 6. Pure Premnium Calculations */

* Calculate pure premiums by risk variable using (total claim costs / total exposure);
proc means data = car_insurance NWAY sum;
class agecat;
var claimcst0 exposure;
output out = age_pure_premium
sum(claimcst0) = claim_cost_total
sum(exposure) = exposure_total;
run;

data age_pure_premium;
set age_pure_premium;
pure_premium = (claim_cost_total / exposure_total);
run;

* Repeat process for all other risk variables;
proc means data = car_insurance NWAY sum;
class area;
var claimcst0 exposure;
output out = area_pure_premium
sum(claimcst0) = claim_cost_total
sum(exposure) = exposure_total;
run;

data area_pure_premium;
set area_pure_premium;
pure_premium = (claim_cost_total / exposure_total);
run;

proc means data = car_insurance NWAY sum;
class gender;
var claimcst0 exposure;
output out = gender_pure_premium
sum(claimcst0) = claim_cost_total
sum(exposure) = exposure_total;
run;

data gender_pure_premium;
set gender_pure_premium;
pure_premium = (claim_cost_total / exposure_total);
run;

proc means data = car_insurance NWAY sum;
class veh_age;
var claimcst0 exposure;
output out = veh_age_pure_premium
sum(claimcst0) = claim_cost_total
sum(exposure) = exposure_total;
run;

data veh_age_pure_premium;
set veh_age_pure_premium;
pure_premium = (claim_cost_total / exposure_total);
run;

proc means data = car_insurance NWAY sum;
class veh_body;
var claimcst0 exposure;
output out = veh_body_pure_premium
sum(claimcst0) = claim_cost_total
sum(exposure) = exposure_total;
run;

data veh_body_pure_premium;
set veh_body_pure_premium;
pure_premium = (claim_cost_total / exposure_total);
run;

* Plot the pure premiums by group;

proc sgplot data = age_pure_premium;
vbar agecat / response = pure_premium;
format pure_premium dollar12.2;
xaxis label = "Age Category";
yaxis label = "Pure premium Costs";
title "Pure Premium Cost by Age Category";
run;
/* Age category 1 has the highest premium cost */

proc sgplot data = area_pure_premium;
vbar area / response = pure_premium;
format pure_premium dollar12.2;
xaxis label = "Area Category";
yaxis label = "Pure premium Costs";
title "Pure Premium Cost by Area Category";
run;
/* Area F has the highest premium cost */

proc sgplot data = gender_pure_premium;
vbar gender / response = pure_premium;
format pure_premium dollar12.2;
xaxis label = "Gender";
yaxis label = "Pure premium Costs";
title "Pure Premium Cost by Gender";
run;
/* Men have the highest premium cost */

proc sgplot data = veh_age_pure_premium;
vbar veh_age / response = pure_premium;
format pure_premium dollar12.2;
xaxis label = "Vehicle Age Category";
yaxis label = "Pure premium Costs";
title "Pure Premium Cost by Vehicle Age Category";
run;
/* Vehicle age category 2 has the highest premium */

proc sgplot data = veh_body_pure_premium;
vbar veh_body / response = pure_premium;
format pure_premium dollar12.2;
xaxis label = "Vehicle Type Category";
yaxis label = "Pure premium Costs";
title "Pure Premium Cost by Vehicle Type";
run;
/* Coupes have the highest premium cost */


/* 7. Risk Segmentation */

* Examine different risk combinations;

* Examine driver age and vehicle age;
proc means data = car_insurance NWAY sum;
class agecat veh_age;
var claimcst0 numclaims exposure;
where exposure > 0;
output out = age_veh_age_risk
sum(claimcst0) = cost_total
sum(exposure) = exposure_total
sum(numclaims) = claim_total;
run;

data age_veh_age_risk;
set age_veh_age_risk;
severity = cost_total / claim_total;
claim_frequency = claim_total / exposure_total;
pure_premium = cost_total / exposure_total;

format severity dollar12.2
pure_premium dollar12.2;
run;

* Sort for the top 4 highest pure premiums;
proc sort data = age_veh_age_risk
out = age_veh_age_risk_sorted;
by descending pure_premium;
run;

proc print data = age_veh_age_risk_sorted;
var agecat veh_age claim_total exposure_total severity claim_frequency pure_premium;
run;

/* 
The top 4 highest observed premiums all belong to age group 1, including all
vehicle ages. The highest observed premium is age group 1, with vehicle age 2 at
$604.56
*/

* Visualize with a grouped bar chart;
proc sgplot data = age_veh_age_risk;
vbar agecat / response = pure_premium group = veh_age groupdisplay = cluster stat = mean;
xaxis label = "Age of policyholder and Age of Vehicle";
yaxis label = "Pure premium cost";
title "Pure premium cost by policyholder age and age of vehicle";
run;

* Exposure credibility note - lower exposure totals could lead to weaker statistical accuracy;
* Sort by exposure;
proc sort data = age_veh_age_risk
out = age_veh_age_exposure_sorted;
by exposure_total;
run;

proc print data = age_veh_age_exposure_sorted;
var agecat veh_age exposure_total;
run;
* Amongst the top 6 lowest exposure totals, 5 are from age group 1 with the lowest in age group 6;
* The lowest exposure is the oldest age group with the newest vehicles;
* All of age group 1 ranks the lowest in exposure totals regardless of vehicle age;
* Due to lower exposure rates, further investigation is required to make conclusion;

*
