*cd "...set working directory"

use latest_export_baseline_by_study_id_clean, clear

*checks
foreach var in q1_3_4 sti_screening  q1_1_5 not_enrolled q1_1_8   q1_1_6  q1_1_5 q1_1_7{
local varname : var label `var'
display("`varname'")
display("`var'")
tab study_ if `var'==.
}
** 
tab study_ if not_enrolled==1 & q1_3_17_4_1 ==., m
tab study_ if not_enrolled==0 & time_to_enrol ==., m

*****

file open prep using table_1.csv, write replace

file write prep ",Screened and not enrolled,Enrolled,Total"

file write prep _n "N"

forvalues x=0/2 {
count if not_enrolled!=`x'
local n=r(N)
file write prep " ,`n'"
}


levelsof q1_3_17_4_1, local(levels)
file write prep _n "Reasons for not enrolling n (%)"
local lbe : value label q1_3_17_4_1

foreach l of local levels {
local vlabel : label `lbe' `l'
file write prep _n "  `vlabel'"
count if  not_enrolled==1
local N=r(N)
count if q1_3_17_4_1  ==`l'
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write prep ",`n' (`p'%), - , -"
}
file write prep _n "median days between screening and enrolment (IQR)"

sum time_to_enrol, d
local med=round(r(p50), 0.1)
local p25=round(r(p25), 0.1)
local p75=round(r(p75), 0.1)
file write prep " ,,`med' (`p25'-`p75')"


levelsof q1_1_8, local(levels)
local varname : var label q1_1_8
file write prep _n "`varname' n (%)"
foreach l of local levels {
local lbe : value label q1_1_8
local vlabel : label `lbe' `l'
file write prep _n "  `vlabel'"
forvalues x=0/2 {
count if not_enrolled!=`x' 
local N=r(N)
count if  not_enrolled!=`x'  & q1_1_8 ==`l'
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write prep ",`n' (`p'%)" 
}
}

file write prep _n "Baseline characteristics at screening"

file write prep _n "median age (IQR)"

forvalues x=0/2 {
sum age if not_enrolled!=`x', d
local med=round(r(p50), 0.1)
local p25=round(r(p25), 0.1)
local p75=round(r(p75), 0.1)
file write prep " ,`med' (`p25'-`p75')"
}

foreach var in   q1_1_6  q1_1_5 q1_1_7{
levelsof `var', local(levels)
local varname : var label `var'
file write prep _n "`varname' n (%)"
foreach l of local levels {
local lbe : value label `var'
local vlabel : label `lbe' `l'
file write prep _n "  `vlabel'"
forvalues x=0/2 {
count if not_enrolled!=`x' 
local N=r(N)
count if  not_enrolled!=`x'  & `var' ==`l'
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write prep ",`n' (`p'%)"
}
}
}



*

foreach var in q1_3_4 sti_screening q1_3_9_1 {
local varname : var label `var'
file write prep _n "`varname' n (%)"
forvalues x=0/2 {
count if not_enrolled!=`x' 
local N=r(N)
count if  not_enrolled!=`x'  & `var' ==1
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write prep ",`n' (`p'%)"
}
}


file close prep 


/*Could add just for enrollment:
contraception type
q2_3_1 

Risk perception and behaviours
q2_5_1 q2_6_1 q2_6_2 q2_6_3 q2_6_4 q2_6_5

