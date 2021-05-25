

****************************************************
****************************************************
****************************************************
****************************************************
****************************************************
*             TAbLE 2


****************************************************
*cd "...set working directory"
use table2_data, clear

gsort study -q9date
duplicates drop study, force
file open prep using table_2.csv, write replace

file write prep ", month 1, month 1-6, month 7-12, month 13-18, total"
file write prep _n"Attendance"
count
local N=r(N) 
 foreach var in  attend_all_ attend_allt_ ret3_ attend_event exit_before_ exit_during_ {
count if `var'1==1
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if `var'6==1
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if `var'12==1
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if `var'18==1
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
count if `var'total==1
local ntot=r(N)
local ptot= string(round(100*`ntot'/`N',0.1))
if strpos("`p1'",".")==0 local p1="`p1'"+".0"
if strpos("`p6'",".")==0 local p6="`p6'"+".0"
if strpos("`p12'",".")==0 local p12="`p12'"+".0"
if strpos("`p18'",".")==0 local p18="`p18'"+".0"
if strpos("`ptot'",".")==0 local ptot="`ptot'"+".0"

file write prep _n "`: var label `var'1', `n1' (`p1'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `ntot' (`ptot'%)"
}
***********REASONS FOR EXIT
file write prep _n"Reasons for exit"


*use table2_data, clear

levelsof exit_reason, local(levels)
local varname : var label exit_reason
foreach l of local levels {
local lbe : value label exit_reason
local vlabel : label `lbe' `l'
count if exit_during_1==1 & exit_reason!=.
local N=r(N)
count if exit_during_1==1 & exit_reason ==`l'
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if exit_during_6==1 & exit_reason!=.
local N=r(N)
count if exit_during_6==1 & exit_reason ==`l'
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if exit_during_12==1 & exit_reason!=.
local N=r(N)
count if exit_during_12==1 & exit_reason ==`l'
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if exit_during_18==1 & exit_reason!=.
local N=r(N)
count if exit_during_18==1 & exit_reason ==`l'
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
count if exit_during_total==1 & exit_reason!=.
local N=r(N)
count if exit_during_tot==1 & exit_reason ==`l'
local ntot=r(N)
local ptot= string(round(100*`ntot'/`N',0.1))
if strpos("`p1'",".")==0 local p1="`p1'"+".0"
if strpos("`p6'",".")==0 local p6="`p6'"+".0"
if strpos("`p12'",".")==0 local p12="`p12'"+".0"
if strpos("`p18'",".")==0 local p18="`p18'"+".0"
if strpos("`ptot'",".")==0 local ptot="`ptot'"+".0"

file write prep _n "  `vlabel', `n1' (`p1'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `ntot' (`ptot'%)"
}


file write prep _n"  Other reasons (not mutually exclusive):"
foreach var in q9_1_2_1 q9_1_2_2 q9_1_2_3 q9_1_2_4 q9_1_2_5 q9_1_2_6 q9_1_2_7 {
local varname : var label `var'
count if exit_during_1==1 & exit_reason!=.
*& exit_reason==5
local N=r(N)
count if exit_during_1==1 & `var' ==1
*& exit_reason==5
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if exit_during_6==1 & exit_reason!=.
*& exit_reason==5
local N=r(N)
count if exit_during_6==1   & `var' ==1
*& exit_reason==5
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if exit_during_12==1 & exit_reason!=.
*& exit_reason==5
local N=r(N)
count if exit_during_12==1 & `var' ==1
*& exit_reason==5
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if exit_during_18==1  & exit_reason!=.
*& exit_reason==5
local N=r(N)
count if exit_during_18==1  & `var' ==1
*& exit_reason==5
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
count if exit_during_total==1  & exit_reason!=.
*& exit_reason==5
local N=r(N)
count if exit_during_tot==1  & `var' ==1
*& exit_reason==5
local ntot=r(N)
local ptot= string(round(100*`ntot'/`N',0.1))

if strpos("`p1'",".")==0 local p1="`p1'"+".0"
if strpos("`p6'",".")==0 local p6="`p6'"+".0"
if strpos("`p12'",".")==0 local p12="`p12'"+".0"
if strpos("`p18'",".")==0 local p18="`p18'"+".0"
if strpos("`ptot'",".")==0 local ptot="`ptot'"+".0"


file write prep _n "    `varname', `n1' (`p1'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `ntot' (`ptot'%)"
}





**********contracaption alignment
file write prep _n "Contraception alignment"
 foreach var in  at_ {
count if `var'1==1
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if `var'6==1
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if `var'12==1
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if `var'18==1
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
count if `var'total==1
local ntot=r(N)
local ptot= string(round(100*`ntot'/`N',0.1))
if strpos("`p1'",".")==0 local p1="`p1'"+".0"
if strpos("`p6'",".")==0 local p6="`p6'"+".0"
if strpos("`p12'",".")==0 local p12="`p12'"+".0"
if strpos("`p18'",".")==0 local p18="`p18'"+".0"
if strpos("`ptot'",".")==0 local ptot="`ptot'"+".0"

file write prep _n "  `: var label `var'1', `n1' ,`n6' ,`n12' ,`n18', `ntot'"
}
* 


foreach var in  r_ rd_ nocx_ {
local varname : var label `var'1
count if at_1==1 
 local N=r(N)
count if at_1==1  & `var'1 ==1
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if at_6==1  
*& exit_reason==5
local N=r(N)
count if at_6==1   & `var'6 ==1
*& exit_reason==5
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if at_12==1 
*& exit_reason==5
local N=r(N)
count if at_12==1 & `var'12 ==1
*& exit_reason==5
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if at_18==1   
*& exit_reason==5
local N=r(N)
count if at_18==1  & `var'18 ==1
*& exit_reason==5
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
count if at_total==1  
*& exit_reason==5
local N=r(N)
count if at_tot==1  & `var'tot ==1
*& exit_reason==5
local ntot=r(N)
local ptot= string(round(100*`ntot'/`N',0.1))

if strpos("`p1'",".")==0 local p1="`p1'"+".0"
if strpos("`p6'",".")==0 local p6="`p6'"+".0"
if strpos("`p12'",".")==0 local p12="`p12'"+".0"
if strpos("`p18'",".")==0 local p18="`p18'"+".0"
if strpos("`ptot'",".")==0 local ptot="`ptot'"+".0"

file write prep _n "    `varname', `n1' (`p1'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), `ntot' (`ptot'%)"
}


file write prep _n "TDF-DP adherence measures"
****ADHERNECE DENOMINATOR
use table2_data, clear
gsort study -q9date
duplicates drop study, force
count
local N=r(N) 
**use adherence data separately
clear
use TDF_merged_visits
** N

count if month==1
local N1=r(N)
count if month==4
local N4=r(N)
count if month==12
local N12=r(N)
count if month==18
local N18=r(N)
file write prep _n "  N with results, `N1',`N4',`N12',`N18', N/A"

** new categories:
count if tdf_catD==2 & month==1
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if tdf_catD==2 & month==4
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if tdf_catD==2 & month==12
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if tdf_catD==2 & month==18
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
file write prep _n "  High adherence levels (% of total), `n1' (`p1'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), N/A"
count if month==1
local N=r(N)
count if tdf_catD==2 & month==1
local n1=r(N)
local p1= string(round(100*`n1'/`N',0.1))
count if month==4
local N=r(N)
count if tdf_catD==2 & month==4
local n6=r(N)
local p6= string(round(100*`n6'/`N',0.1))
count if month==12
local N=r(N)
count if tdf_catD==2 & month==12
local n12=r(N)
local p12= string(round(100*`n12'/`N',0.1))
count if month==18
local N=r(N)
count if tdf_catD==2 & month==18
local n18=r(N)
local p18= string(round(100*`n18'/`N',0.1))
file write prep _n "  High adherence levels (% of tested), `n1' (`p1'%),`n6' (`p6'%),`n12' (`p12'%),`n18' (`p18'%), N/A"

* to add .0 to numbers with no decimals for consistent style
if strpos("`p1'",".")==0 local p1="`p1'"+".0"
if strpos("`p6'",".")==0 local p6="`p6'"+".0"
if strpos("`p12'",".")==0 local p12="`p12'"+".0"
if strpos("`p18'",".")==0 local p18="`p18'"+".0"
if strpos("`ptot'",".")==0 local ptot="`ptot'"+".0"
replace tdf_quant=0 if tdf_quant==.
summ tdf_quant if month==1, d
local med=r(p50)
local lb=r(p25)
local ub=r(p75)
file write prep _n "  Median TFV-DP levels (IQR), `med' (`lb'-`ub'),"
summ tdf_quant if month==4, d
local med=r(p50)
local lb=r(p25)
local ub=r(p75)
file write prep "`med' (`lb'-`ub'),"
summ tdf_quant if month==12, d
local med=r(p50)
local lb=r(p25)
local ub=r(p75)
file write prep "`med' (`lb'-`ub'),"
summ tdf_quant if month==18, d
local med=r(p50)
local lb=r(p25)
local ub=r(p75)
file write prep "`med' (`lb'-`ub'),"
summ tdf_quant, d
local med=r(p50)
local lb=r(p25)
local ub=r(p75)
file write prep "`med' (`lb'-`ub'),"


file close prep




