
*cd "...set working directory"
use latest_export_baseline_by_study_id_clean, clear
foreach var in q1_1_8  q1_1_6  q1_1_5 q1_1_7 {
levelsof `var', local(levels)
foreach l of local levels {
local varname : var label `var'
local lbe : value label `var'
local vlabel : label `lbe' `l'
gen `var'`l' = `var'==`l'
label var `var'`l' "`vlabel' "
}
}
foreach var in  q1_3_4 sti_screening q1_3_9_1  {
replace `var'=0 if `var'==.
}

gen high_risk_perception =q2_5_1==3
label var high_risk_perception "high self-reported risk perception"
replace q1_3_9_1=1 if q2_7_1==2
label var q1_3_9_1 "PEP started at screening"
label var q1_2_1 "current/prior chronic disease"
label var  q2_6_1 "sex with more than one partner in past six months"
label var q2_6_2 "sex without a condom in past six months"
label var q2_6_3 "sex without person of unknown status in past six months"
gen hormonal_cxt= inlist(q2_3_1,1,2,5)
label var hormonal_cxt "on injectable contraception/pill"
*** enroleled
merge 1:m study using TDF_merged_visits, gen(merge_tdf)
replace tdf_catD=0 if tdf_catD==.
*drop m1 m6 m12 m18

foreach var in 1 4 12 18 {
gen m`var'= month==`var' & tdf_catD==2
bysort study: egen ever`var'=max(m`var')
replace ever`var'=. if not_enrol==1
}
duplicates drop study_, force
 
gen fail= ltfu
gen fail2=complete!=1
gen time=last_attend - q2date
replace time= 1 if time==0
stset time, fail(fail2)

****merge trajectory groups
merge 1:1 study using traj_groups , gen(merge_traj)
replace traj_group= traj_group-1
 
gen enrol=1-not_enrol
label var age "age"
file open prep using table_1_associations.csv, write replace
file write prep "characteristic, risk difference(95% CI)"
file write prep _n", enrolment, month 1 adherent, month 3/4 adherent, month 12 adherent, month 18 adherent, adherence group 2 in trajectory analysis, HR (failure=LTFU), HR (failure=incomplete)"


foreach var in q1_1_81 q1_1_82 q1_1_83 q1_1_84 q1_1_85 q1_1_86 q1_1_87 q1_1_61 q1_1_62 q1_1_63 q1_1_51 q1_1_52 q1_1_53 q1_1_54 q1_1_71 q1_1_72 q1_1_73 age  q1_3_4 sti_screening q1_3_9_1 {
local varname : var label `var'
glm enrol `var' , family(binomial) link(id)
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round(100*((b[1,1])),0.1))
local lb=string(round(100*(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(100*(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep _n"`varname',`rd' (`lb'-`ub')"
foreach depvar in ever1 ever4 ever12 ever18 traj_group {
glm `depvar' `var' , family(binomial) link(id)
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round(100*((b[1,1])),0.1))
local lb=string(round(100*(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(100*(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep ",`rd' (`lb'-`ub')"
}
stset time, fail(fail)
stcox `var'
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round((exp(b[1,1])),0.1))
local lb=string(round(exp(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(exp(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep ",`rd' (`lb'-`ub')"
stset time, fail(fail2)
stcox `var'
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round((exp(b[1,1])),0.1))
local lb=string(round(exp(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(exp(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep ",`rd' (`lb'-`ub')"
}
foreach var in high_risk_perception q2_6_1 q2_6_2 q2_6_3  hormonal_cxt {
local varname : var label `var'
file write prep _n"`varname',"
foreach depvar in ever1 ever4 ever12 ever18 traj_group {
glm `depvar' `var' , family(binomial) link(id)
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round(100*((b[1,1])),0.1))
local lb=string(round(100*(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(100*(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep ",`rd' (`lb'-`ub')"

}
stset time, fail(fail)
stcox `var'
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round((exp(b[1,1])),0.1))
local lb=string(round(exp(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(exp(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep ",`rd' (`lb'-`ub')"
stset time, fail(fail2)
stcox `var'
quietly matrix b = e(b)
quietly matrix d = e(V)
local rd= string(round((exp(b[1,1])),0.1))
local lb=string(round(exp(b[1,1]-1.96*d[1,1]^0.5),0.1))
local ub=string(round(exp(b[1,1]+1.96*d[1,1]^0.5),0.1))
file write prep ",`rd' (`lb'-`ub')"
}
file close prep

stcox  q1_1_82



