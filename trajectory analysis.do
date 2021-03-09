 *net from http://www.andrew.cmu.edu/user/bjones/traj
 *net install traj, replace 
*ssc install grstyle, replace
*ssc install palettes, replace
** graph styles 
grstyle clear
set scheme s2color
grstyle init
grstyle set plain, box
grstyle color background white
grstyle set color Set1
grstyle yesno draw_major_hgrid yes
grstyle yesno draw_major_ygrid yes
grstyle color major_grid gs8
grstyle linepattern major_grid dot
*grstyle set legend 4, box inside
grstyle color ci_area gs12%50


*cd "...set working directory"
use table2_data, clear
keep study
duplicates drop 
merge 1:m study using TDF_merged_visits, keepusing(q3month tdf_quant tdf_catDT tdf_catL)


foreach x in 1 4 12 18  {
**either set to missing or zero, depending on whether you want to count missings as zero adherence
gen tdf_m`x'1=0
replace tdf_m`x'1= tdf_quant if q3month==`x'
gen tdf_cat_m`x'1=0
replace tdf_cat_m`x'1=tdf_catD if q3month==`x'
bysort study: egen tdf_m`x'=max(tdf_m`x'1)
bysort study: egen tdf_cat_m`x'=max(tdf_cat_m`x'1)
drop tdf_cat_m`x'1 tdf_m`x'1
gen t`x'=`x'
}

duplicates drop study, force
** order is where you specify type of line and number of groups. 0=intercept, 1 linear, 2 quadratic...
** model is censored norms - lots of 0s, maximum specified

file open prep using trajectory_models.csv, write replace

	file write prep  "Shape parameters, K, BIC (N=656),BIC (N=164),AIC,log likelihood,smallest group size, average posterior probability per group"

foreach p in "1" "2" {
traj , model(cnorm) var(tdf_m1 tdf_m4 tdf_m12 tdf_m18) indep(t1 t4 t12 t18 ) order(`p')  min(0) max(2519) 
local n= e(numGroups1) //     number of groups 1 (through 6 when generated)
local BIC_data= e(BIC_N_data)  //    BIC based on the number of data points
local BIC_s= e(BIC_n_subjects)  //BIC based on the number of subjects
  local AIC=    e(AIC)          //   AIC
    local ll=  e(ll)             // log likelihood
	matrix g1=  e(groupSize1) // group size
	local g1=g1[1,1]
	summ _traj_ProbG1 if _traj_Group ==1
	local g1p= round(100*r(mean))

	file write prep _n "params: `p', `n', `BIC_data',`BIC_s',`AIC',`ll',`g1'%,`g1p'%"
}

foreach p in "0 0 " "1 0" "1 1" "1 2"  "2 2"  {
traj , model(cnorm) var(tdf_m1 tdf_m4 tdf_m12 tdf_m18) indep(t1 t4 t12 t18 ) order(`p')  min(0) max(2519) 
local n= e(numGroups1) //     number of groups 1 (through 6 when generated)
local BIC_data= e(BIC_N_data)  //    BIC based on the number of data points
local BIC_s= e(BIC_n_subjects)  //BIC based on the number of subjects
  local AIC=    e(AIC)          //   AIC
    local ll=  e(ll)             // log likelihood
	matrix g1=  e(groupSize1) // group size
	local g1=round(min(g1[1,1], g1[1,2]))
	summ _traj_ProbG1 if _traj_Group ==1
	local g1p= round(100*r(mean))
		summ _traj_ProbG2 if _traj_Group ==2
	local g2p= round(100*r(mean))
	file write prep _n "params: `p', `n', `BIC_data',`BIC_s',`AIC',`ll',`g1'%,`g1p'%,`g2p'%"
}


foreach p in "0 0 1" "1 0 1" "1 1 1" "1 2 1" "2 2 1" "2 2 2" {
traj , model(cnorm) var(tdf_m1 tdf_m4 tdf_m12 tdf_m18) indep(t1 t4 t12 t18 ) order(`p')  min(0) max(2519) 
local n= e(numGroups1) //     number of groups 1 (through 6 when generated)
local BIC_data= e(BIC_N_data)  //    BIC based on the number of data points
local BIC_s= e(BIC_n_subjects)  //BIC based on the number of subjects
  local AIC=    e(AIC)          //   AIC
    local ll=  e(ll)             // log likelihood
	matrix g1=  e(groupSize1) // group size
	local g1=round(min(g1[1,1], g1[1,2], g1[1,3]))
	summ _traj_ProbG1 if _traj_Group ==1
	local g1p= round(100*r(mean))
		summ _traj_ProbG2 if _traj_Group ==2
	local g2p= round(100*r(mean))
			summ _traj_ProbG3 if _traj_Group ==3
	local g3p= round(100*r(mean))
	file write prep _n "params: `p', `n', `BIC_data',`BIC_s',`AIC',`ll',`g1'%,`g1p'%,`g2p'%,`g3p'%"
}



file close prep	
 
 traj , model(cnorm) var(tdf_m1 tdf_m4 tdf_m12 tdf_m18) indep(t1 t4 t12 t18 ) order(2 2)  min(0) max(2519) 
** entropy
*i think this is  formula 171 shown on page 34  http://www.statmodel.com/download/techappen.pdf
gen Ent = 0
foreach i of varlist _traj_ProbG* {
replace Ent = Ent + `i'*log(`i')
}
replace Ent = -1*Ent
count 
local n= r(N)
display(1-(sum(Ent)/`n'*log(2)))
*/


 grstyle init
 
 
/*
 grstyle color background white

 grstyle color major_grid gs8
 grstyle linewidth major_grid thin

 grstyle linepattern major_grid dot

 grstyle yesno draw_major_hgrid yes

 grstyle yesno grid_draw_min yes

 grstyle yesno grid_draw_max yes

 grstyle anglestyle vertical_tick horizontal

 grstyle gsize axis_title_gap tiny
 
 */
 label define group 1 "Low adherence group" 2 "High adherence group"
label values _traj_Group group
label var _traj_Group "adherence trajectory group"
* grstyle set nogrid
*. grstyle set imesh, horizontal compact minor
*. grstyle set ci burd, select(11 13) opacity(60)

 trajplot, ci  xtitle("visit month") ytitle("group mean TFV-DP (missing=0)")   
*** separate plots

 reshape long tdf_m tdf_cat_m t, i(study_i) j(month)
 graph twoway scatter tdf_m month, c(L) by(_traj_Group) msize(tiny) mcolor(gray) lwidth(vthin) lcolor(gray)  ytitle("group mean TFV-DP (missing=0)")  graphregion(color(white))  plotregion(fcolor(white)) bgcolor(white) xlabel(1 "1" 4 "3/4" 12 "12" 18 "18")

 
 
 
 *** from visual inspection it looks like two quad models are the best fit
 
use table2_data, clear
keep study
duplicates drop 
merge 1:m study using TDF_merged_visits, keepusing(q3month tdf_quant tdf_catDT tdf_catL)


foreach x in 1 4 12 18  {
**either set to missing or zero, depending on whether you want to count missings as zero adherence
gen tdf_m`x'1=0
replace tdf_m`x'1= tdf_quant if q3month==`x'
gen tdf_cat_m`x'1=0
replace tdf_cat_m`x'1=tdf_catD if q3month==`x'
bysort study: egen tdf_m`x'=max(tdf_m`x'1)
bysort study: egen tdf_cat_m`x'=max(tdf_cat_m`x'1)
drop tdf_cat_m`x'1 tdf_m`x'1
gen t`x'=`x'
}

duplicates drop study, force
  traj , model(cnorm) var(tdf_m1 tdf_m4 tdf_m12 tdf_m18) indep(t1 t4 t12 t18 ) order(2 2)  min(0) max(2519) 
 trajplot, ci  xtitle("visit month") ytitle("group mean TFV-DP (missing=0)")   

label define group 1 "group 1" 2 "group 2"
label values _traj_G group 
 tabstat tdf_m1 tdf_m4 tdf_m12 tdf_m18, by(_traj_Group) statistics(N mean median p25 p75)

 gen good1=tdf_m1> 500
 gen good4=tdf_m4> 700
 gen good12=tdf_m12> 700
 gen good18=tdf_m18> 700
 
 tab good1 _traj_G, col
  tab good4 _traj_G, col
 tab good12 _traj_G, col
 tab good18 _traj_G, col
 
 keep study_id _traj_G
 
 rename _traj_G traj_group
 save traj_groups, replace
