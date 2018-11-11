global project_in="E:\EcoApli\Research\Project\INGPP"
global project_out="E:\EcoApli\Research\Project\Out"

use "$project_out\data_f.dta",clear
gen crec_Y= (ing_perusd10-pin_perusd05)/pin_perusd05
export delimited clave ing_perusd10 gini_1010 gini0505 gap_edu05 crec_Y using "$project_out\agregada.csv",replace
save "$project_out\agregada.dta",replace
