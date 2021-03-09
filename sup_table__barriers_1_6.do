

*cd "...set working directory"
use table_risk_data1_6, clear
file open prep using risk_over_time0_1_6.csv, write replace

file write prep "variable, enrolment, month 1, month 6, N"
 foreach var in  high_risk q3_3_1 q3_3_2 q3_3_3 q3_3_4 sti q3_11_2_3_1___1 q3_11_2_3_1___2 q3_11_2_3_1___3 q3_11_2_3_1___4 q3_11_3_1 q3_11_3_2_1___1 q3_11_3_2_1___2 q3_11_3_2_1___3 q3_11_3_2_1___4 q3_11_3_3 q3_11_2_1 q3_11_2_2 q3_11_2_5 {

keep if !inlist(99, `var'_m0,`var'_1m,`var'_6m) &  !inlist(., `var'_m0,`var'_1m,`var'_6m)
}
 foreach var in  high_risk q3_3_1 q3_3_2 q3_3_3 q3_3_4 sti q3_11_2_3_1___1 q3_11_2_3_1___2 q3_11_2_3_1___3 q3_11_2_3_1___4 q3_11_2_1 q3_11_2_2 q3_11_2_5  q3_11_3_1 q3_11_3_2_1___1 q3_11_3_2_1___2 q3_11_3_2_1___3 q3_11_3_2_1___4 q3_11_3_3{

count 
local N=r(N)
count if `var'_m0==1
local n=r(N)
local p0= round(100*`n'/`N',0.1)
count if `var'_1m==1
local n=r(N)
local p1= round(100*`n'/`N',0.1)
count if `var'_6m==1
local n=r(N)
local p6= round(100*`n'/`N',0.1)

file write prep _n "`: var label `var'_m0',`p0'%,`p1'%,`p6'%, `N'"
}


file close prep










