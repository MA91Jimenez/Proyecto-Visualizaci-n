global project_in="E:\EcoApli\Research\Project\INGPP"
global project_out="E:\EcoApli\Research\Project\Out"

//Realizemos la base agregada 05
import delimited "$project_in\gini05.csv", clear 
gen clave1=clave
tostring clave,replace
gen cero="0"
egen clave2=concat(cero clave) if clave1<10000
replace clave2=clave if clave1>=10000
drop clave clave1 cero
rename clave2 clave
order clave 
save "$project_out\data05.dta",replace

import delimited "$project_in\gob05.csv", clear 
gen clave1=clave
tostring clave,replace
gen cero="0"
egen clave2=concat(cero clave) if clave1<10000
replace clave2=clave if clave1>=10000
drop clave clave1 cero
rename clave2 clave
order clave 
gen inv_gub=inversinpblica
gen trans_gub=transferenciasasignacionessubsid
gen deuda_gub=deudapblica
keep clave inv_gub trans_gub deuda_gub total
merge 1:1 clave using "$project_out\data05.dta"
drop _merge
save "$project_out\data05.dta",replace


import delimited "$project_in\ing_per05.csv", clear 
gen cero="0"
tostring ent1 mun1,replace
egen ent2=concat(cero ent1) if ent<10
replace ent2= ent1 if ent>=10

egen mun2=concat(cero cero mun1) if mun<10
replace mun2=cero+mun1 if mun>=10 & mun<100
replace mun2=mun1 if mun>=100

drop ent1 mun1 ent mun cero
rename mun2 mun
rename ent2 ent
egen clave=concat(ent mun)
order clave ent mun
merge 1:1 clave using "$project_out\data05.dta"
drop _merge
merge 1:1 clave using "E:\Proyecto Mapas\Definitivo\Munpers2005.dta"
drop _merge
gen gap_edu=mediaH_low-mediaH_high
save "$project_out\data05.dta",replace
export delimited clave pin_perusd pib_totusd total inv_gub trans_gub deuda_gub gini05 gap_edu Media using "$project_out\data05.csv", replace

//Realizemos la base agregada 10
import delimited "$project_in\cone_divyear.csv", clear 
gen clave1=clave_mun
tostring clave_mun,replace
gen cero="0"
egen clave2=concat(cero clave_mun) if clave1<10000
replace clave2=clave_mun if clave1>=10000
drop clave_mun clave1 cero
rename clave2 clave
keep clave gini_10 gini_00 gini_90
order clave 
save "$project_out\data10.dta",replace

import delimited "$project_in\gob10.csv", clear 
gen clave1=clave
tostring clave,replace
gen cero="0"
egen clave2=concat(cero clave) if clave1<10000
replace clave2=clave if clave1>=10000
drop clave clave1 cero
rename clave2 clave
order clave 
gen inv_gub=inversinpblica
gen trans_gub=transferenciasasignacionessubsid
gen deuda_gub=deudapblica
keep clave inv_gub trans_gub deuda_gub total
merge 1:1 clave using "$project_out\data10.dta"
drop _merge
save "$project_out\data10.dta",replace


import delimited "$project_in\ing_per10.csv", clear 
gen cero="0"
tostring ent1 mun1,replace
egen ent2=concat(cero ent1) if ent<10
replace ent2= ent1 if ent>=10

egen mun2=concat(cero cero mun1) if mun<10
replace mun2=cero+mun1 if mun>=10 & mun<100
replace mun2=mun1 if mun>=100

drop ent1 mun1 ent mun cero
rename mun2 mun
rename ent2 ent
egen clave=concat(ent mun)
order clave ent mun
merge 1:1 clave using "$project_out\data10.dta"
drop _merge
merge 1:1 clave using "E:\Proyecto Mapas\Definitivo\Munpers2010.dta"
drop _merge
gen gap_edu=mediaH_low-mediaH_high
save "$project_out\data10.dta",replace
export delimited clave ing_perusd gini_10  total inv_gub trans_gub deuda_gub gap_edu using "$project_out\data10.csv", replace

//Datos agrupados
use "$project_out\data05.dta", clear
foreach var of varlist _all{
rename `var' `var'05
}
rename clave05 clave
save "$project_out\data_f.dta",replace

use "$project_out\data10.dta", clear
foreach var of varlist _all{
rename `var' `var'10
}
rename clave10 clave
merge 1:1 clave using "$project_out\data_f.dta"
drop _merge
drop if ing_perusd10==. | pin_perusd05==.
save "$project_out\data_f.dta",replace

//Para la regresión
//
use "$project_out\data_f.dta",clear
gen crec_Y= (ing_perusd10-pin_perusd05)/pin_perusd05
gen l_gin00=log(gini0505)
gen l_diffnat00=log(mediaH_high05)-log(mediaH_low05)
gen edu_mean00=Media05
gen rat_invpub=inv_gub05/pib_totusd05
gen rat_debpub=deuda_gub05/pib_totusd05
gen rat_trapub=trans_gub05/pib_totusd05
gen gubgas=total05/pib_totusd05
gen l_ing00=log(pin_perusd05)
gen l2_ing00=l_ing00^2
sort ent10
by ent10: egen ing_perMEAN00=mean(pin_perusd05)
//Dummies estatales
foreach i in 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32{
gen R`i'=1 if ent10=="`i'"
replace R`i'=0 if R`i'==.
}
save "$project_out\data_reg.dta",replace
global EDOS= "R02 R03 R04 R05 R06 R07 R08 R09 R10 R11 R12 R13 R14 R15 R16 R17 R18 R19 R20 R21 R22 R23 R24 R25 R26 R27 R28 R29 R30 R31 R32" 
ivregress 2sls crec_Y edu_mean00 rat_trapub l_ing00 l2_ing00 $EDOS ( l_diffnat00 = gini0505 ),vce(robust)

