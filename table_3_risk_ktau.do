

*cd "...set working directory"
use table_risk_data, clear

file open prep using risk_over_time.csv, write replace
local x=1
file write prep "variable, enrolment, month 1-6, month 6-12, month 12-18, N"
 foreach var in  high_risk q3_3_1 q3_3_2 q3_3_3 q3_3_4 sti q3_11_2_3_1___1 q3_11_2_3_1___2 q3_11_2_3_1___3 q3_11_2_3_1___4 q3_11_3_1 q3_11_3_2_1___1 q3_11_3_2_1___2 q3_11_3_2_1___3 q3_11_3_2_1___4 q3_11_3_3 q3_11_2_1 q3_11_2_2 q3_11_2_5 {

keep if !inlist(99, `var'_m0,`var'_6m,`var'_12m, `var'_18m) &  !inlist(., `var'_m0,`var'_6m,`var'_12m, `var'_18m)
}
 foreach var in  high_risk q3_3_1 q3_3_2 q3_3_3 q3_3_4 sti q3_11_2_3_1___1 q3_11_2_3_1___2 q3_11_2_3_1___3 q3_11_2_3_1___4 q3_11_2_1 q3_11_2_2 q3_11_2_5  q3_11_3_1 q3_11_3_2_1___1 q3_11_3_2_1___2 q3_11_3_2_1___3 q3_11_3_2_1___4 q3_11_3_3{

 
count 
local N=r(N)
count if `var'_m0==1
local n0=r(N)
local p0= string(round(100*`n0'/`N',0.1))
count if `var'_6m==1
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if `var'_12m==1
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if `var'_18m==1
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
preserve
 expand 4
 bysort study_id: gen n=_n
 replace `var'=. if n==1  
 replace `var'=`var'_m0 if n==1  & `x'<7
 replace `var'=`var'_6m if n==2
 replace `var'=`var'_12m if n==3 
 replace `var'=`var'_18m if n==4
  ktau n `var'
local p=round(r(p), 0.001)
restore
file write prep _n "`: var label `var'_m0', `n0' (`p0'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `N', `p'"
local x=`x'+1
}
drop if attend_all!=1



file write prep _n ""
file write prep _n "only those that attended all visits"
 foreach var in  high_risk q3_3_1 q3_3_2  q3_3_4 sti q3_11_2_3_1___1 q3_11_2_3_1___2 q3_11_2_3_1___3 q3_11_2_3_1___4 q3_11_2_1 q3_11_2_2 q3_11_2_5  q3_11_3_1 q3_11_3_2_1___1 q3_11_3_2_1___2 q3_11_3_2_1___3 q3_11_3_2_1___4 q3_11_3_3 {
preserve
keep if !inlist(99, `var'_m0,`var'_6m,`var'_12m, `var'_18m) &  !inlist(., `var'_m0,`var'_6m,`var'_12m, `var'_18m)
count 
local N=r(N)
count if `var'_m0==1
local n0=r(N)
local p0= string(round(100*`n0'/`N',0.1))
count if `var'_6m==1
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if `var'_12m==1
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if `var'_18m==1
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))

file write prep _n "`: var label `var'_m0', `n0' (`p0'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `N'"
restore
}
use table_risk_data, clear

file write prep _n ""
file write prep _n "all participants"
 foreach var in  high_risk q3_3_1 q3_3_2  q3_3_4 sti q3_11_2_3_1___1 q3_11_2_3_1___2 q3_11_2_3_1___3 q3_11_2_3_1___4 q3_11_2_1 q3_11_2_2 q3_11_2_5  q3_11_3_1 q3_11_3_2_1___1 q3_11_3_2_1___2 q3_11_3_2_1___3 q3_11_3_2_1___4 q3_11_3_3 {
preserve
*keep if !inlist(99, `var'_m0,`var'_6m,`var'_12m, `var'_18m) &  !inlist(., `var'_m0,`var'_6m,`var'_12m, `var'_18m)
count 
local N=r(N)
count if `var'_m0==1
local n0=r(N)
local p0= string(round(100*`n0'/`N',0.1))
count if `var'_6m==1
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if `var'_12m==1
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if `var'_18m==1
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
file write prep _n "`: var label `var'_m0', `n0' (`p0'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `N'"
restore
}



file close prep



 foreach var in  high_risk q3_3_1 q3_3_2 q3_3_3 q3_3_4  {
preserve
prtest `var'_6m==`var'_18m if !inlist(99,`var'_6m,`var'_18m) &  !inlist(.,`var'_6m, `var'_18m)

restore
}

/*


file write prep _n "STIs by time period"
file write prep _n"variable, yes, no, no visits"
foreach var in sti_screen sti_6m sti_12m  sti_18m{
count if `var'==1 &  redcap=="enrolment_arm_1"
local y=r(N)
count if `var'==0 &  redcap=="enrolment_arm_1"
local n=r(N)
count if `var'==99 &  redcap=="enrolment_arm_1"
local na=r(N)
file write prep _n"`var',`y', `n', `na'"  
}




file close prep
