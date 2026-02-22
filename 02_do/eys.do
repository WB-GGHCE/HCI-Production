
*===============================================================================
*===============================================================================
//						Component 5. Expected Years of School
// 	  				***   Expected Years of School for HCI    ***
*===============================================================================
*===============================================================================

/******************************************************************************/

// Do file to input raw data and standardize dataset and naming conventions.

/******************************************************************************/
// Purpose		    : To prepare EYS data  
// Input datasets	: eys_data_for_HCI_Team_Dec_11_2025_v2.dta
// Data Sources     : Education analytics team
// Source Used		: 

// Output dataset	: eys_data.dta
// Last edited	    : Oct 15, 2025
// Last run		    : Oct 15, 2025

// Notes            : 
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

// EYS dataset from Education team
use "${clone}/01_data/eys/eys_data_for_HCI_Team_Dec_11_2025_v2.dta", clear

//Clean up steps
ren (countrycode countryname ) (wbcode wbcountryname )
cap drop region regionname adminregion adminregionname incomelevel incomelevelname lendingtype lendingtypename

*-------------------------------------------------------------------------------		  

// Note: eys_mf_fill keeps rep-adj EYS, if rep-adj EYS not available it resorts to non-rep adj EYS
keeporder wbcode wbcountryname year                         					///
		  eys_pp_mf_fill eys_pp_mf_type eys_pp_mf_year eys_pp_mf_source eys_sa_mf_fill eys_sa_mf_type eys_sa_mf_year eys_sa_mf_source /// 2025 EYS variables
		  eys_pp_m_fill  eys_pp_m_type  eys_pp_m_year  eys_pp_m_source eys_sa_m_fill  eys_sa_m_type  eys_sa_m_year  eys_sa_m_source	///
		  eys_pp_f_fill  eys_pp_f_type  eys_pp_f_year  eys_pp_f_source eys_sa_f_fill  eys_sa_f_type  eys_sa_f_year  eys_sa_f_source	///
		  eys_pp_mf_fill_2020 eys_pp_mf_type_2020 eys_pp_mf_year_2020 eys_pp_mf_source_2020 eys_sa_mf_fill_2020 eys_sa_mf_type_2020 eys_sa_mf_year_2020 eys_sa_mf_source_2020 /// 2020 EYS variables
		  eys_pp_m_fill_2020  eys_pp_m_type_2020  eys_pp_m_year_2020  eys_pp_m_source_2020 eys_sa_m_fill_2020  eys_sa_m_type_2020  eys_sa_m_year_2020  eys_sa_m_source_2020 ///
		  eys_pp_f_fill_2020  eys_pp_f_type_2020  eys_pp_f_year_2020  eys_pp_f_source_2020  eys_sa_f_fill_2020  eys_sa_f_type_2020  eys_sa_f_year_2020  eys_sa_f_source_2020 ///
		  eys_pp_mf_fill_2015 eys_pp_mf_type_2015 eys_pp_mf_year_2015 eys_pp_mf_source_2015 eys_sa_mf_fill_2015 eys_sa_mf_type_2015 eys_sa_mf_year_2015 eys_sa_mf_source_2015 /// 2015 EYS variables
		  eys_pp_m_fill_2015  eys_pp_m_type_2015  eys_pp_m_year_2015  eys_pp_m_source_2015 eys_sa_m_fill_2015  eys_sa_m_type_2015  eys_sa_m_year_2015  eys_sa_m_source_2015 ///
		  eys_pp_f_fill_2015  eys_pp_f_type_2015  eys_pp_f_year_2015  eys_pp_f_source_2015 eys_sa_f_fill_2015  eys_sa_f_type_2015  eys_sa_f_year_2015  eys_sa_f_source_2015  ///
		  eys_pp_mf_fill_2010 eys_pp_mf_type_2010 eys_pp_mf_year_2010 eys_pp_mf_source_2010 eys_sa_mf_fill_2010 eys_sa_mf_type_2010 eys_sa_mf_year_2010 eys_sa_mf_source_2010 /// 2010 EYS variables
		  eys_pp_m_fill_2010  eys_pp_m_type_2010  eys_pp_m_year_2010  eys_pp_m_source_2010 eys_sa_m_fill_2010  eys_sa_m_type_2010  eys_sa_m_year_2010  eys_sa_m_source_2010 ///
		  eys_pp_f_fill_2010  eys_pp_f_type_2010  eys_pp_f_year_2010  eys_pp_f_source_2010 eys_sa_f_fill_2010  eys_sa_f_type_2010  eys_sa_f_year_2010  eys_sa_f_source_2010  ///
		  cer_pp_mf_fill   cer_pp_mf_fill_repadj cer_pp_mf_type cer_pp_mf_year cer_pp_mf_source   							/// 2025 preprimary
		  cer_pp_m_fill   cer_pp_m_fill_repadj cer_pp_m_type cer_pp_m_year cer_pp_m_source   	 							 /// 
		  cer_pp_f_fill   cer_pp_f_fill_repadj cer_pp_f_type cer_pp_f_year cer_pp_f_source        							/// 
		  cer_pp_mf_fill_2020   cer_pp_mf_fill_repadj_2020 cer_pp_mf_type_2020 cer_pp_mf_year_2020 cer_pp_mf_source_2020   /// 2020 preprimary
		  cer_pp_m_fill_2020   cer_pp_m_fill_repadj_2020 cer_pp_m_type_2020 cer_pp_m_year_2020 cer_pp_m_source_2020   	  /// 
		  cer_pp_f_fill_2020   cer_pp_f_fill_repadj_2020 cer_pp_f_type_2020 cer_pp_f_year_2020 cer_pp_f_source_2020        /// 
		  cer_pp_mf_fill_2015   cer_pp_mf_fill_repadj_2015 cer_pp_mf_type_2015 cer_pp_mf_year_2015 cer_pp_mf_source_2015   /// 2015 preprimary
		  cer_pp_m_fill_2015   cer_pp_m_fill_repadj_2015 cer_pp_m_type_2015 cer_pp_m_year_2015 cer_pp_m_source_2015   	  /// 
		  cer_pp_f_fill_2015   cer_pp_f_fill_repadj_2015 cer_pp_f_type_2015 cer_pp_f_year_2015 cer_pp_f_source_2015        /// 
		  cer_pp_mf_fill_2010   cer_pp_mf_fill_repadj_2010 cer_pp_mf_type_2010 cer_pp_mf_year_2010 cer_pp_mf_source_2010   /// 2010 preprimary
		  cer_pp_m_fill_2010   cer_pp_m_fill_repadj_2010 cer_pp_m_type_2010 cer_pp_m_year_2015 cer_pp_m_source_2010   	  /// 
		  cer_pp_f_fill_2010   cer_pp_f_fill_repadj_2010 cer_pp_f_type_2010 cer_pp_f_year_2015 cer_pp_f_source_2010        /// 
		  cer_p_mf_fill   cer_p_mf_fill_repadj cer_p_mf_type cer_p_mf_year cer_p_mf_source rep_p_mf_fill rep_p_mf_fill_year	source_rep_p_mf	/// 2025 primary
		  cer_p_m_fill   cer_p_m_fill_repadj cer_p_m_type cer_p_m_year cer_p_m_source  rep_p_m_fill rep_p_m_fill_year	source_rep_p_m	 /// 
		  cer_p_f_fill   cer_p_f_fill_repadj cer_p_f_type cer_p_f_year cer_p_f_source  rep_p_f_fill rep_p_f_fill_year	source_rep_p_f	/// 
		  cer_p_mf_fill_2020   cer_p_mf_fill_repadj_2020 cer_p_mf_type_2020 cer_p_mf_year_2020 cer_p_mf_source_2020 rep_p_mf_fill_2020 rep_p_mf_fill_year_2020	   /// 2020 primary
		  cer_p_m_fill_2020   cer_p_m_fill_repadj_2020 cer_p_m_type_2020 cer_p_m_year_2020 cer_p_m_source_2020 rep_p_m_fill_2020 rep_p_m_fill_year_2020	  	/// 
		  cer_p_f_fill_2020   cer_p_f_fill_repadj_2020 cer_p_f_type_2020 cer_p_f_year_2020 cer_p_f_source_2020 rep_p_f_fill_2020 rep_p_f_fill_year_2020	        /// 
		  cer_p_mf_fill_2015   cer_p_mf_fill_repadj_2015 cer_p_mf_type_2015 cer_p_mf_year_2015 cer_p_mf_source_2015 rep_p_mf_fill_2015 rep_p_mf_fill_year_2015	  /// 2015 primary
		  cer_p_m_fill_2015   cer_p_m_fill_repadj_2015 cer_p_m_type_2015 cer_p_m_year_2015 cer_pp_m_source_2015 rep_p_m_fill_2015 rep_p_m_fill_year_2015	  	  /// 
		  cer_p_f_fill_2015   cer_p_f_fill_repadj_2015 cer_p_f_type_2015 cer_p_f_year_2015 cer_pp_f_source_2015 rep_p_f_fill_2015 rep_p_f_fill_year_2015	       /// 
		  cer_p_mf_fill_2010   cer_p_mf_fill_repadj_2010 cer_p_mf_type_2010 cer_p_mf_year_2010 cer_p_mf_source_2010 rep_p_mf_fill_2010 rep_p_mf_fill_year_2010	  /// 2010 primary
		  cer_p_m_fill_2010   cer_p_m_fill_repadj_2010 cer_p_m_type_2010 cer_p_m_year_2015 cer_p_m_source_2010 rep_p_m_fill_2010 rep_p_m_fill_year_2010	   	  /// 
		  cer_p_f_fill_2010   cer_p_f_fill_repadj_2010 cer_p_f_type_2010 cer_p_f_year_2015 cer_p_f_source_2010  rep_p_f_fill_2010 rep_p_f_fill_year_2010 ///
		  cer_ls_mf_fill   cer_ls_mf_fill_repadj cer_ls_mf_type cer_ls_mf_year cer_ls_mf_source rep_ls_mf_fill rep_ls_mf_fill_year	source_rep_ls_mf	/// 2025 ls
		  cer_ls_m_fill   cer_ls_m_fill_repadj cer_ls_m_type cer_ls_m_year cer_ls_m_source  rep_ls_m_fill rep_ls_m_fill_year	source_rep_ls_m	 /// 
		  cer_ls_f_fill   cer_ls_f_fill_repadj cer_ls_f_type cer_ls_f_year cer_ls_f_source  rep_ls_f_fill rep_ls_f_fill_year	source_rep_ls_f	/// 
		  cer_ls_mf_fill_2020   cer_ls_mf_fill_repadj_2020 cer_ls_mf_type_2020 cer_ls_mf_year_2020 cer_ls_mf_source_2020 rep_ls_mf_fill_2020 rep_ls_mf_fill_year_2020	   /// 2020 ls
		  cer_ls_m_fill_2020   cer_ls_m_fill_repadj_2020 cer_ls_m_type_2020 cer_ls_m_year_2020 cer_ls_m_source_2020 rep_ls_m_fill_2020 rep_ls_m_fill_year_2020	  	/// 
		  cer_ls_f_fill_2020   cer_ls_f_fill_repadj_2020 cer_ls_f_type_2020 cer_ls_f_year_2020 cer_ls_f_source_2020 rep_ls_f_fill_2020 rep_ls_f_fill_year_2020	        /// 
		  cer_ls_mf_fill_2015   cer_ls_mf_fill_repadj_2015 cer_ls_mf_type_2015 cer_ls_mf_year_2015 cer_ls_mf_source_2015 rep_ls_mf_fill_2015 rep_ls_mf_fill_year_2015	  /// 2015 ls
		  cer_ls_m_fill_2015   cer_ls_m_fill_repadj_2015 cer_ls_m_type_2015 cer_ls_m_year_2015 cer_pp_m_source_2015 rep_ls_m_fill_2015 rep_ls_m_fill_year_2015	  	  /// 
		  cer_ls_f_fill_2015   cer_ls_f_fill_repadj_2015 cer_ls_f_type_2015 cer_ls_f_year_2015 cer_pp_f_source_2015 rep_ls_f_fill_2015 rep_ls_f_fill_year_2015	       /// 
		  cer_ls_mf_fill_2010   cer_ls_mf_fill_repadj_2010 cer_ls_mf_type_2010 cer_ls_mf_year_2010 cer_ls_mf_source_2010 rep_ls_mf_fill_2010 rep_ls_mf_fill_year_2010	  /// 2010 ls
		  cer_ls_m_fill_2010   cer_ls_m_fill_repadj_2010 cer_ls_m_type_2010 cer_ls_m_year_2015 cer_ls_m_source_2010 rep_ls_m_fill_2010 rep_ls_m_fill_year_2010	   	  /// 
		  cer_ls_f_fill_2010   cer_ls_f_fill_repadj_2010 cer_ls_f_type_2010 cer_ls_f_year_2015 cer_ls_f_source_2010  rep_ls_f_fill_2010 rep_ls_f_fill_year_2010 ///		  
		  cer_us_mf_fill   cer_us_mf_fill_repadj cer_us_mf_type cer_us_mf_year cer_us_mf_source rep_us_mf_fill rep_us_mf_fill_year	source_rep_us_mf	/// 2025 US
		  cer_us_m_fill   cer_us_m_fill_repadj cer_us_m_type cer_us_m_year cer_us_m_source  rep_us_m_fill rep_us_m_fill_year	source_rep_us_m	 /// 
		  cer_us_f_fill   cer_us_f_fill_repadj cer_us_f_type cer_us_f_year cer_us_f_source  rep_us_f_fill rep_us_f_fill_year	source_rep_us_f	/// 
		  cer_us_mf_fill_2020   cer_us_mf_fill_repadj_2020 cer_us_mf_type_2020 cer_us_mf_year_2020 cer_us_mf_source_2020 rep_us_mf_fill_2020 rep_us_mf_fill_year_2020	   /// 2020 US
		  cer_us_m_fill_2020   cer_us_m_fill_repadj_2020 cer_us_m_type_2020 cer_us_m_year_2020 cer_us_m_source_2020 rep_us_m_fill_2020 rep_us_m_fill_year_2020	  	/// 
		  cer_us_f_fill_2020   cer_us_f_fill_repadj_2020 cer_us_f_type_2020 cer_us_f_year_2020 cer_us_f_source_2020 rep_us_f_fill_2020 rep_us_f_fill_year_2020	        /// 
		  cer_us_mf_fill_2015   cer_us_mf_fill_repadj_2015 cer_us_mf_type_2015 cer_us_mf_year_2015 cer_us_mf_source_2015 rep_us_mf_fill_2015 rep_us_mf_fill_year_2015	  /// 2015 US
		  cer_us_m_fill_2015   cer_us_m_fill_repadj_2015 cer_us_m_type_2015 cer_us_m_year_2015 cer_pp_m_source_2015 rep_us_m_fill_2015 rep_us_m_fill_year_2015	  	  /// 
		  cer_us_f_fill_2015   cer_us_f_fill_repadj_2015 cer_us_f_type_2015 cer_us_f_year_2015 cer_pp_f_source_2015 rep_us_f_fill_2015 rep_us_f_fill_year_2015	       /// 
		  cer_us_mf_fill_2010   cer_us_mf_fill_repadj_2010 cer_us_mf_type_2010 cer_us_mf_year_2010 cer_us_mf_source_2010 rep_us_mf_fill_2010 rep_us_mf_fill_year_2010	  /// 2010 US
		  cer_us_m_fill_2010   cer_us_m_fill_repadj_2010 cer_us_m_type_2010 cer_us_m_year_2015 cer_us_m_source_2010 rep_us_m_fill_2010 rep_us_m_fill_year_2010	   	  /// 
		  cer_us_f_fill_2010   cer_us_f_fill_repadj_2010 cer_us_f_type_2010 cer_us_f_year_2015 cer_us_f_source_2010  rep_us_f_fill_2010 rep_us_f_fill_year_2010
		  
*-------------------------------------------------------------------------------		  
// Merge with master data file
merge m:1 wbcode year using "$clone\01_data\misc\masterdata.dta",  keep(2 3) nogen
drop if wbcode =="x"
sort wbcode year

*-------------------------------------------------------------------------------
								
 // Saving intermediate EYS file
 keep if inrange(year, 1999, 2025)  // to keep file size small
 
/******************************************************************************/
// Fill in gaps by using up to 10 lags   (for 2025)
/******************************************************************************/
// For each `var' loop generates:
// `var'_rep:  Variable as reported
// `var'_fill:  Variable filled in with lags
// `var'_year: Year of actual data where filled-in data comes from
// `var'_source: Text describing source, suitable for notes
// Extra variables with year_mod and fill_mod suffix, which we are going to use in creating gender estimates for modeled data 
/******************************************************************************/

// Renaming so we end up with the nomenclature we have been using in this project
ren (eys_pp_mf_fill eys_pp_m_fill eys_pp_f_fill eys_sa_mf_fill eys_sa_m_fill eys_sa_f_fill ) (eys_pp_mf eys_pp_m eys_pp_f eys_sa_mf eys_sa_m eys_sa_f)
cap drop eys_pp_mf_year eys_pp_m_year eys_pp_f_year eys_sa_mf_year eys_sa_m_year eys_sa_f_year // dropping year fill to make proper year fill instead of replicating year variable 

foreach gen in mf m f{
	foreach lev in pp sa{
replace eys_`lev'_`gen'_type = "" if missing(eys_`lev'_`gen')
replace eys_`lev'_`gen'_source = "" if missing(eys_`lev'_`gen')
	}
}

sort countrynumber year
xtset countrynumber year

local myvar eys_pp_mf eys_pp_m eys_pp_f ///
            eys_sa_mf eys_sa_m eys_sa_f  
		
	foreach var of local myvar {	
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		
	forvalues i=1/10{
		qui gen xx_`i'=xx_`=scalar(`i'-1)'
		qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year<= 2024
		qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year<= 2024
		}
		
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui drop xx*
	}	
	
// One loop to generate filled-in lags for string variables containing source
foreach var in eys_pp_mf eys_pp_m eys_pp_f ///
               eys_sa_mf eys_sa_m eys_sa_f  {		
			   
	qui gen `var'_fill_src =`var'_source //if `var'~=.
	qui gen `var'_fill_type=`var'_type   //if `var'~=.

forvalues i=1/10{
	qui replace `var'_fill_src=`var'_source[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2024
	qui replace `var'_fill_type=`var'_type[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2024
	}
}

// Label Data	
foreach gen in mf m f{
	foreach lev in pp sa{
	lab var eys_`lev'_`gen'_fill     "Expected years of schooling `lev' (2025): filled series, `gen'"
	lab var eys_`lev'_`gen'_year     "Expected years of schooling `lev' (2025): filled year, `gen'"
	lab var eys_`lev'_`gen'_rep      "Expected years of schooling `lev' (2025): reported series, `gen'"
	lab var eys_`lev'_`gen'_fill_src "Expected years of schooling `lev' (2025): source, `gen'"
	lab var eys_`lev'_`gen'_fill_type "Expected years of schooling `lev' (2025): type, `gen'"
	}	
}
	
******************************************************************************/
// Generate final variables for 2025
/******************************************************************************/

sort countrynumber year
xtset countrynumber year

foreach gen in mf m f {
	foreach lev in pp sa{
		foreach var in fill year  {
			qui gen eys_`lev'_`gen'_`var'_2025=L1.eys_`lev'_`gen'_`var'  if year==2025
		}
	}
}

foreach gen in mf m f {
	foreach lev in pp sa{
		qui gen eys_`lev'_`gen'_fill_src_2025  = eys_`lev'_`gen'_fill_src[_n-1]    if year==2025
		qui gen eys_`lev'_`gen'_fill_type_2025 = eys_`lev'_`gen'_fill_type[_n-1]   if year==2025
		}
}
		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		

/******************************************************************************/
// Fill in gaps by using up to 10 lags   (for 2020)
/******************************************************************************/
// For each `var' loop generates:
// `var'_rep:  Variable as reported
// `var'_fill:  Variable filled in with lags
// `var'_year: Year of actual data where filled-in data comes from
// `var'_source: Text describing source, suitable for notes
// Extra variables with year_mod and fill_mod suffix, which we are going to use in creating gender estimates for modeled data 
/******************************************************************************/

// Renaming so we end up with the nomenclature we have been using in this project

ren (eys_pp_mf_fill_2020 eys_pp_m_fill_2020 eys_pp_f_fill_2020) (eys_pp_2020_mf eys_pp_2020_m eys_pp_2020_f)
ren (eys_sa_mf_fill_2020 eys_sa_m_fill_2020 eys_sa_f_fill_2020) (eys_sa_2020_mf eys_sa_2020_m eys_sa_2020_f)

ren (eys_pp_mf_source_2020 eys_pp_m_source_2020 eys_pp_f_source_2020) (eys_pp_2020_mf_source eys_pp_2020_m_source eys_pp_2020_f_source)
ren (eys_sa_mf_source_2020 eys_sa_m_source_2020 eys_sa_f_source_2020) (eys_sa_2020_mf_source eys_sa_2020_m_source eys_sa_2020_f_source)

ren (eys_pp_mf_type_2020 eys_pp_m_type_2020 eys_pp_f_type_2020) (eys_pp_2020_mf_type eys_pp_2020_m_type eys_pp_2020_f_type)
ren (eys_sa_mf_type_2020 eys_sa_m_type_2020 eys_sa_f_type_2020) (eys_sa_2020_mf_type eys_sa_2020_m_type eys_sa_2020_f_type)

cap drop eys_pp_mf_year_2020 eys_pp_m_year_2020 eys_pp_f_year_2020 
cap drop eys_sa_mf_year_2020 eys_sa_m_year_2020 eys_sa_f_year_2020 

foreach gen in mf m f{
	foreach lev in pp sa{
		replace eys_`lev'_2020_`gen'_type   = "" if missing(eys_`lev'_2020_`gen')
		replace eys_`lev'_2020_`gen'_source = "" if missing(eys_`lev'_2020_`gen')
	}
}

sort countrynumber year
xtset countrynumber year

local myvar eys_pp_2020_mf  ///
			eys_pp_2020_m  ///
			eys_pp_2020_f  ///
			eys_sa_2020_mf  ///
			eys_sa_2020_m  ///
			eys_sa_2020_f
		
	foreach var of local myvar {	
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		
	forvalues i=1/10{
		qui gen xx_`i'=xx_`=scalar(`i'-1)'
		qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year<= 2019
		qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year<= 2019
		}
		
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui drop xx*
	}	
	
// One loop to generate filled-in lags for string variables containing source
foreach var in eys_pp_2020_mf 	 ///
			   eys_pp_2020_m 		///
			   eys_pp_2020_f   ///
			   eys_sa_2020_mf 	 ///
			   eys_sa_2020_m 		///
			   eys_sa_2020_f {		
			   
	qui gen `var'_fill_src =`var'_source //if `var'~=.
	qui gen `var'_fill_type=`var'_type   // if `var'~=.

forvalues i=1/10{
	qui replace `var'_fill_src=`var'_source[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2019
	qui replace `var'_fill_type=`var'_type[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2019
	}
}

// Label Data	
foreach gen in mf m f{
	foreach lev in pp sa {
	lab var eys_`lev'_2020_`gen'_fill     "Expected years of schooling `lev' (2020) : filled series, `gen'"
	lab var eys_`lev'_2020_`gen'_year     "Expected years of schooling `lev' (2020): filled year, `gen'"
	lab var eys_`lev'_2020_`gen'_rep      "Expected years of schooling `lev' (2020): reported series, `gen'"
	lab var eys_`lev'_2020_`gen'_fill_src "Expected years of schooling `lev' (2020): source, `gen'"
	lab var eys_`lev'_2020_`gen'_fill_type "Expected years of schooling `lev' (2020): type, `gen'"
	}
}	
	

******************************************************************************/
// Generate final variables for 2020
/******************************************************************************/

sort countrynumber year
xtset countrynumber year

foreach gen in mf m f {
	foreach lev in pp sa{
		foreach var in fill year  {
			qui gen eys_`lev'_`gen'_`var'_2020=L6.eys_`lev'_2020_`gen'_`var'  if year==2025
		}
	}
}

foreach gen in mf m f {
	foreach lev in pp sa{
		qui gen eys_`lev'_`gen'_fill_src_2020  = eys_`lev'_2020_`gen'_fill_src[_n-6]    if year==2025
		qui gen eys_`lev'_`gen'_fill_type_2020 = eys_`lev'_2020_`gen'_fill_type[_n-6]   if year==2025
	}
		}
		

*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		

/******************************************************************************/
// Fill in gaps by using up to 10 lags   (for 2015)
/******************************************************************************/
// For each `var' loop generates:
// `var'_rep:  Variable as reported
// `var'_fill:  Variable filled in with lags
// `var'_year: Year of actual data where filled-in data comes from
// `var'_source: Text describing source, suitable for notes
// Extra variables with year_mod and fill_mod suffix, which we are going to use in creating gender estimates for modeled data 
/******************************************************************************/

// Renaming so we end up with the nomenclature we have been using in this project

ren (eys_pp_mf_fill_2015 eys_pp_m_fill_2015 eys_pp_f_fill_2015) (eys_pp_2015_mf eys_pp_2015_m eys_pp_2015_f)
ren (eys_sa_mf_fill_2015 eys_sa_m_fill_2015 eys_sa_f_fill_2015) (eys_sa_2015_mf eys_sa_2015_m eys_sa_2015_f)

ren (eys_pp_mf_source_2015 eys_pp_m_source_2015 eys_pp_f_source_2015) (eys_pp_2015_mf_source eys_pp_2015_m_source eys_pp_2015_f_source)
ren (eys_sa_mf_source_2015 eys_sa_m_source_2015 eys_sa_f_source_2015) (eys_sa_2015_mf_source eys_sa_2015_m_source eys_sa_2015_f_source)

ren (eys_pp_mf_type_2015 eys_pp_m_type_2015 eys_pp_f_type_2015) (eys_pp_2015_mf_type eys_pp_2015_m_type eys_pp_2015_f_type)
ren (eys_sa_mf_type_2015 eys_sa_m_type_2015 eys_sa_f_type_2015) (eys_sa_2015_mf_type eys_sa_2015_m_type eys_sa_2015_f_type)

cap drop eys_pp_mf_year_2015 eys_pp_m_year_2015 eys_pp_f_year_2015 
cap drop eys_sa_mf_year_2015 eys_sa_m_year_2015 eys_sa_f_year_2015 

foreach gen in mf m f{
	foreach lev in pp sa{
		replace eys_`lev'_2015_`gen'_type   = "" if missing(eys_`lev'_2015_`gen')
		replace eys_`lev'_2015_`gen'_source = "" if missing(eys_`lev'_2015_`gen')
	}
}

sort countrynumber year
xtset countrynumber year

local myvar eys_pp_2015_mf  ///
			eys_pp_2015_m  ///
			eys_pp_2015_f  ///
			eys_sa_2015_mf  ///
			eys_sa_2015_m  ///
			eys_sa_2015_f
		
	foreach var of local myvar {	
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		
	forvalues i=1/10{
		qui gen xx_`i'=xx_`=scalar(`i'-1)'
		qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year<= 2014
		qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year<= 2014
		}
		
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui drop xx*
	}	
	
// One loop to generate filled-in lags for string variables containing source
foreach var in eys_pp_2015_mf 	 ///
			   eys_pp_2015_m 		///
			   eys_pp_2015_f   ///
			   eys_sa_2015_mf 	 ///
			   eys_sa_2015_m 		///
			   eys_sa_2015_f{		
			   
	qui gen `var'_fill_src =`var'_source //if `var'~=.
	qui gen `var'_fill_type=`var'_type   //if `var'~=.

forvalues i=1/10{
	qui replace `var'_fill_src=`var'_source[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2014
	qui replace `var'_fill_type=`var'_type[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2014
	}
}

// Label Data	
foreach gen in mf m f{
	foreach lev in pp sa{
		lab var eys_`lev'_2015_`gen'_fill     "Expected years of schooling `lev' (2015) : filled series, `gen'"
		lab var eys_`lev'_2015_`gen'_year     "Expected years of schooling `lev' (2015): filled year, `gen'"
		lab var eys_`lev'_2015_`gen'_rep      "Expected years of schooling `lev' (2015): reported series, `gen'"
		lab var eys_`lev'_2015_`gen'_fill_src "Expected years of schooling `lev' (2015): source, `gen'"
		lab var eys_`lev'_2015_`gen'_fill_type "Expected years of schooling `lev' (2015): type, `gen'"
	}
}	
	

******************************************************************************/
// Generate final variables for 2015
/******************************************************************************/

sort countrynumber year
xtset countrynumber year

foreach gen in mf m f {
	foreach lev in pp sa{
		foreach var in fill year  {
			qui gen eys_`lev'_`gen'_`var'_2015=L11.eys_`lev'_2015_`gen'_`var'  if year==2025
		}
	}
}

foreach gen in mf m f {
	foreach lev in pp sa{
			qui gen eys_`lev'_`gen'_fill_src_2015  = eys_`lev'_2015_`gen'_fill_src[_n-11]    if year==2025
			qui gen eys_`lev'_`gen'_fill_type_2015 = eys_`lev'_2015_`gen'_fill_type[_n-11]   if year==2025
	}
		}
		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		

/******************************************************************************/
// Fill in gaps by using up to 10 lags   (for 2010)
/******************************************************************************/
// For each `var' loop generates:
// `var'_rep:  Variable as reported
// `var'_fill:  Variable filled in with lags
// `var'_year: Year of actual data where filled-in data comes from
// `var'_source: Text describing source, suitable for notes
// Extra variables with year_mod and fill_mod suffix, which we are going to use in creating gender estimates for modeled data 
/******************************************************************************/

ren (eys_pp_mf_fill_2010 eys_pp_m_fill_2010 eys_pp_f_fill_2010) (eys_pp_2010_mf eys_pp_2010_m eys_pp_2010_f)
ren (eys_sa_mf_fill_2010 eys_sa_m_fill_2010 eys_sa_f_fill_2010) (eys_sa_2010_mf eys_sa_2010_m eys_sa_2010_f)

ren (eys_pp_mf_source_2010 eys_pp_m_source_2010 eys_pp_f_source_2010) (eys_pp_2010_mf_source eys_pp_2010_m_source eys_pp_2010_f_source)
ren (eys_sa_mf_source_2010 eys_sa_m_source_2010 eys_sa_f_source_2010) (eys_sa_2010_mf_source eys_sa_2010_m_source eys_sa_2010_f_source)

ren (eys_pp_mf_type_2010 eys_pp_m_type_2010 eys_pp_f_type_2010) (eys_pp_2010_mf_type eys_pp_2010_m_type eys_pp_2010_f_type)
ren (eys_sa_mf_type_2010 eys_sa_m_type_2010 eys_sa_f_type_2010) (eys_sa_2010_mf_type eys_sa_2010_m_type eys_sa_2010_f_type)

cap drop eys_pp_mf_year_2010 eys_pp_m_year_2010 eys_pp_f_year_2010 
cap drop eys_sa_mf_year_2010 eys_sa_m_year_2010 eys_sa_f_year_2010 

foreach gen in mf m f{
	foreach lev in pp sa{
		replace eys_`lev'_2010_`gen'_type   = "" if missing(eys_`lev'_2010_`gen')
		replace eys_`lev'_2010_`gen'_source = "" if missing(eys_`lev'_2010_`gen')
	}
}

sort countrynumber year
xtset countrynumber year

local myvar eys_pp_2010_mf  ///
			eys_pp_2010_m  ///
			eys_pp_2010_f  ///
			eys_sa_2010_mf  ///
			eys_sa_2010_m  ///
			eys_sa_2010_f
		
	foreach var of local myvar {	
		qui gen xx_0=`var'
		qui gen `var'_year=year if `var'~=.
		qui gen `var'_fill=`var' if `var'~=.
		
	forvalues i=1/10{
		qui gen xx_`i'=xx_`=scalar(`i'-1)'
		qui replace xx_`i'=L`i'.`var' if xx_`i'==. & year<= 2009
		qui replace `var'_year=L`i'.year if xx_`i'~=. & xx_`=scalar(`i'-1)'==. & year<= 2009
		}
		
		qui replace `var'_fill=xx_10 if `var'==.
		qui gen `var'_rep=`var'
		qui drop xx*
	}	
	
// One loop to generate filled-in lags for string variables containing source
foreach var in eys_pp_2010_mf 	  ///
			   eys_pp_2010_m 	  ///
			   eys_pp_2010_f      ///
			   eys_sa_2010_mf 	  ///
			   eys_sa_2010_m 	  ///
			   eys_sa_2010_f{		
			   
	qui gen `var'_fill_src =`var'_source //if `var'~=.
	qui gen `var'_fill_type=`var'_type  //if `var'~=.

forvalues i=1/10{
	qui replace `var'_fill_src=`var'_source[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2009
	qui replace `var'_fill_type=`var'_type[_n-`i'] if `var'_year==L`i'.`var'_year & `var'_fill~=. & year <= 2009
	}
}

// Label Data	
foreach gen in mf m f{
	foreach lev in pp sa{
		lab var eys_`lev'_2010_`gen'_fill     "Expected years of schooling `lev' (2010) : filled series, `gen'"
		lab var eys_`lev'_2010_`gen'_year     "Expected years of schooling `lev' (2010): filled year, `gen'"
		lab var eys_`lev'_2010_`gen'_rep      "Expected years of schooling `lev' (2010): reported series, `gen'"
		lab var eys_`lev'_2010_`gen'_fill_src "Expected years of schooling `lev' (2010): source, `gen'"
		lab var eys_`lev'_2010_`gen'_fill_type "Expected years of schooling `lev' (2010): type, `gen'"
	}
}	
	

******************************************************************************/
// Generate final variables for 2010
/******************************************************************************/

sort countrynumber year
xtset countrynumber year

foreach gen in mf m f {
	foreach lev in pp sa{
		foreach var in fill year  {
			qui gen eys_`lev'_`gen'_`var'_2010=L16.eys_`lev'_2010_`gen'_`var'  if year==2025
		}
	}
}

foreach gen in mf m f {
	foreach lev in pp sa{
		qui gen eys_`lev'_`gen'_fill_src_2010  = eys_`lev'_2010_`gen'_fill_src[_n-16]    if year==2025
		qui gen eys_`lev'_`gen'_fill_type_2010 = eys_`lev'_2010_`gen'_fill_type[_n-16]   if year==2025
			}
		}
		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		
*-------------------------------------------------------------------------------		

// School age EYS 6-17 final dataset
keep if inrange(year, 2001, 2025)  // to keep file size small
compress
save "$clone\03_output\eys_data", replace

*-------------------------------------------------------------------------------		
