
 *** from visual inspection it looks like two quad models are the best fit
 * (see traj_groups do file)
 
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
