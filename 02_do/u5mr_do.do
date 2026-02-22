
*===============================================================================
*===============================================================================
//						Component 1. Survival Rates
// 	 		 ***   0 to 4 Years Survival Rates for HCI   ***
*===============================================================================
*===============================================================================

/******************************************************************************/

// Do file to input raw data and standardize dataset and naming conventions.

/******************************************************************************/
// Purpose		    : To prepare under 5 mortality data 
// Input datasets	: UNIGME-2024-Country-Rates-Deaths-Under-five.xlsx & UNIGME-2024-Country-Sex-specific_U5MR-CMR-and-IMR.xlsx
// Data Sources     : UNIGME
// Source Used		: 

// Output dataset	: u5mr_data.dta
// Last edited	    : Oct 15, 2025
// Last run		    : Oct 15, 2025

// Notes            : Assigned China average data to Hong Kong and Macau in line with previous HCI release
//==============================================================================


*===============================================================================
// 0. Set globals
*===============================================================================

clear
cls
version 18
set more off

dir "$clone"

*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------

***************       Preparng IGME Child survival data       ******************

// UN-IGME Source:   https://childmortality.org/
// Variable: Mortality among children under 5

// Total (mf) dataset
import excel using "$clone/01_data/u5_mr/UNIGME-2024-Country-Rates-Deaths-Under-five.xlsx", ///
					cellrange(A11:CC611) sheet("Rates and Deaths U5MR") firstrow clear

rename *, lower
rename (isocode) (wbcode)

drop sd* uni* countryname

// Reshape data
reshape long u5mr, i(wbcode uncertaintybounds) j(year)
reshape wide u5mr, i(wbcode year) j(uncertaintybounds) s

drop u5mrLower u5mrUpper

rename u5mrMedian u5mr_mf

// Save temporary file
cou
tempfile mf
sa "`mf'"

// Male + Female Dataset 
import excel using "$clone/01_data/u5_mr/UNIGME-2024-Country-Sex-specific_U5MR-CMR-and-IMR.xlsx", ///
		            cellrange(A12:BW613) sheet("Sex-specific U5MR estimates") firstrow clear

rename *, lower					
rename isocode wbcode
drop sd* uni* countryname

rename male u5mr_m1990
foreach k in `c(alpha)'{
	if "`k'" >="i"{
		rename `k' u5mr_m`=`k'[1]'
	}
}

foreach k in `c(alpha)'{
	if "`k'" <="o"{
		rename a`k' u5mr_m`=a`k'[1]'
	}
}

rename female u5mr_f1990
foreach k in `c(alpha)'{
	if "`k'" >= "q"{
		rename a`k' u5mr_f`=a`k'[1]'
	}
}

foreach k in `c(alpha)'{
	if "`k'" <= "w"{
		rename b`k' u5mr_f`=b`k'[1]'
	}
}

drop if wbcode==""

// Reshape data
reshape long u5mr_m u5mr_f, i(wbcode uncertaintybounds) j(year)
reshape wide u5mr_m u5mr_f, i(wbcode year) j(uncertaintybounds) s

drop *Lower *Upper

rename *Median *

// Merge MF and gender-disaggregated data
merge 1:1 wbcode year using "`mf'"
tab year if _merge!=3
drop _merge

// Merging with master data 
merge m:1 wbcode year using "${clone}\01_data\misc\masterdata.dta"
tab wbcountryname if _merge == 1   // Okay no countries
drop if _merge == 1
drop _merge
drop if wbcode == "x"

// Relabeling and transformations to rates
foreach gender in mf m f{
	gen mort_0to4_`gender'     = u5mr_`gender'/1000
	}
	
// Creating filled seires with lagged filled obs
xtset countrynumber year
sort countrynumber year

foreach var in mort_0to4_m mort_0to4_f mort_0to4_mf {
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		
		forvalues i=1/10{
			qui gen xx_`i'=xx_`=scalar(`i'-1)'
			qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year <= 2024 
			qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year <=  2024
		}
		
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui gen `var'_source="UN Interagency Group for Child Mortality Estimates" if `var'_fill~=.
		qui drop xx*
	}	
	
*---------------------	
	
// Special cases 

// // Assign China average data to Hong Kong and Macau
foreach gen in mf m f{
	foreach suffix in rep fill year{
		gen xx = mort_0to4_`gen'_`suffix' if wbcode == "CHN"
		egen xxx = mean(xx), by(year)
		replace  mort_0to4_`gen'_`suffix' = xxx if inlist(wbcode, "HKG", "MAC")
		drop xx xxx
	}
	replace mort_0to4_`gen'_source="UN Interagency Group for Child Mortality Estimates (Using Estimates for China)" if inlist(wbcode, "HKG", "MAC") & mort_0to4_`gen'_fill~=.
}
	
// Assign Switzerland data to Liechtenstein
foreach gen in mf m f{
	foreach suffix in rep fill year{
		gen xx = mort_0to4_`gen'_`suffix' if wbcode == "CHE"
		egen xxx = mean(xx), by(year)
		replace  mort_0to4_`gen'_`suffix' = xxx if inlist(wbcode, "LIE")
		drop xx xxx
	}
	replace mort_0to4_`gen'_source="UN Interagency Group for Child Mortality Estimates (Using Estimates for Switzerland)" if inlist(wbcode, "LIE") & mort_0to4_`gen'_fill~=.
}
	
*---------------------	

// Final 2025 variables for 2010, 2015, 2018, 2020 and 2025	
foreach gen in mf m f {
	foreach var in fill year {
		qui gen mort_0to4_`gen'_`var'_2025=L1.mort_0to4_`gen'_`var' if year==2025
		qui gen mort_0to4_`gen'_`var'_2020=L6.mort_0to4_`gen'_`var' if year==2025
		qui gen mort_0to4_`gen'_`var'_2018=L8.mort_0to4_`gen'_`var' if year==2025
		qui gen mort_0to4_`gen'_`var'_2015=L11.mort_0to4_`gen'_`var' if year==2025
		qui gen mort_0to4_`gen'_`var'_2010=L16.mort_0to4_`gen'_`var' if year==2025
		}
	}

foreach gen in mf m f {
	qui gen mort_0to4_`gen'_src_2025=mort_0to4_`gen'_source[_n-1] if year==2025
	qui gen mort_0to4_`gen'_src_2020=mort_0to4_`gen'_source[_n-6] if year==2025
	qui gen mort_0to4_`gen'_src_2018=mort_0to4_`gen'_source[_n-8] if year==2025
	qui gen mort_0to4_`gen'_src_2015=mort_0to4_`gen'_source[_n-11] if year==2025
	qui gen mort_0to4_`gen'_src_2010=mort_0to4_`gen'_source[_n-16] if year==2025
	}

// Saving final under 5 mortality dataset by IGME
save "$clone/03_output/u5mr_data.dta", replace		