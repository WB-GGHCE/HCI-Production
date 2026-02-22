
*===============================================================================
*===============================================================================
//						Human Capital Index
// 	  					   ***       ***
*===============================================================================
*===============================================================================

/******************************************************************************/

// Do file to input raw data and standardize dataset and naming conventions.

/******************************************************************************/
// Purpose		    : To prepare Old methodology HCI 2025, 2020, 2015, 2010 with the latest data as in 2025  
// Input datasets	: 
// Data Sources     : 
// Source Used		: 

// Output dataset	: Old_hci.dta
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

glo years "2025 2020  2015 2010"   
di $years
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------


// Bringing in Latest under 5 mortality rate
use "$clone/03_output/u5mr_data.dta", clear  // IGME under 5 mortality dataset Okay

// Bringing in the latest data for ASR 15-60 UNPD survival rates 
merge 1:1 wbcode year using "$clone/03_output/asr_data.dta", keep(1 3) nogen  // Okay

// Bringing the latest survey-based (only) stunting data
merge 1:1 wbcode year using "$clone/03_output/stunting_svy_data.dta", keep(1 3) nogen  // Okay

// Bringing in the latest HLO Data provided by the education team 
merge 1:1 wbcode year using "$clone/03_output/hlo_data.dta", keep(3) nogen   // Okay

// Bringing in the latest EYS data provided by the education team 
merge 1:1 wbcode year using "$clone/03_output/eys_data.dta", keep(3) nogen

//cap gen cer_pp_mf_fill_2018 = .
//cap gen eys_sa_mf_fill_2018 = .
*-------------------------------------------------------------------------------
// To increase the country coverage for 2010, 2015 and 2020 by using old HCI data 

tab wbcountryname if !missing(hlo_mf_fill_2010) & year == 2025 // 136: countries for which the latest HLO is available
tab wbcountryname if !missing(hlo_mf_fill_2015) & year == 2025 // 151: countries for which the latest HLO is available
tab wbcountryname if !missing(hlo_mf_fill_2018) & year == 2025 // 166
tab wbcountryname if !missing(hlo_mf_fill_2020) & year == 2025 // 175

// Tags for countries for which HLO is available, but pre-primary enrolment is missing for 2010 and 2015 
cap drop x_2010 x_2015 x_2020
gen x_2010 = 1    if !missing(hlo_mf_fill_2010) & missing(eys_pp_mf_fill_2010) & year == 2025  // 15: tag variable for hlo  available  but pp enrol missing
gen x_2015 = 1    if !missing(hlo_mf_fill_2015) & missing(eys_pp_mf_fill_2015) & year == 2025  // 6: tag variable for hlo  available  but pp enrol missing
//gen x_2018 = 1    if !missing(hlo_mf_fill_2018) & missing(eys_pp_mf_fill_2018) & year == 2025  // 
gen x_2020 = 1    if !missing(hlo_mf_fill_2020) & missing(eys_pp_mf_fill_2020) & year == 2025  //2  

tab wbcountryname if !missing(hlo_mf_fill_2010) & missing(eys_sa_mf_fill_2010) & year == 2025 // 1: countries for which the latest HLO is available
tab wbcountryname if !missing(hlo_mf_fill_2015) & missing(eys_sa_mf_fill_2015) & year == 2025 //  2: countries for which the latest HLO is available
//tab wbcountryname if !missing(hlo_mf_fill_2018) & missing(eys_sa_mf_fill_2018) & year == 2025 // 
tab wbcountryname if !missing(hlo_mf_fill_2020) & missing(eys_sa_mf_fill_2020) & year == 2025 // 2 countries

// Tags for countries for which HLO is available, but primary through secondary EYS (enrolments) is missing for 2010 and 2015 
gen y_2010 = 1    if !missing(hlo_mf_fill_2010) & missing(eys_sa_mf_fill_2010) & year == 2025
gen y_2015 = 1    if !missing(hlo_mf_fill_2015) & missing(eys_sa_mf_fill_2015) & year == 2025
gen y_2020 = 1    if !missing(hlo_mf_fill_2020) & missing(eys_sa_mf_fill_2020) & year == 2025

preserve

// OLD HCI Data for pre-primary enrolment rate for 2010 & 2015
use "$clone/01_data/misc/previous_hci_data", clear	
drop if wbcode == "x"

keeporder countrynumber wbcode wbcountryname year ///
	 cer_pp_mf_fill cer_pp_mf_repadj_fill cer_pp_mf_year cer_pp_mf_repadj_year cer_pp_mf_type cer_pp_mf_repadj_type cer_pp_mf_source  /// pre-primary mf
	 cer_pp_m_fill cer_pp_m_repadj_fill cer_pp_m_year cer_pp_m_repadj_year cer_pp_m_type cer_pp_m_repadj_type cer_pp_m_source         /// pre-primary m
	 cer_pp_f_fill cer_pp_f_repadj_fill cer_pp_f_year cer_pp_f_repadj_year cer_pp_f_type cer_pp_f_repadj_type cer_pp_f_source         /// pre-primary mf
	 cer_p_mf_fill cer_p_mf_repadj_fill cer_p_mf_year cer_p_mf_repadj_year cer_p_mf_type cer_p_mf_repadj_type cer_p_mf_source         ///  primary mf
	 cer_p_m_fill cer_p_m_repadj_fill cer_p_m_year cer_p_m_repadj_year cer_p_m_type cer_p_m_repadj_type cer_p_m_source                ///  primary m
	 cer_p_f_fill cer_p_f_repadj_fill cer_p_f_year cer_p_f_repadj_year cer_p_f_type cer_p_f_repadj_type cer_p_f_source                ///  primary f
	 cer_ls_mf_fill cer_ls_mf_repadj_fill cer_ls_mf_year cer_ls_mf_repadj_year cer_ls_mf_type cer_ls_mf_repadj_type cer_ls_mf_source   /// ls mf
	 cer_ls_m_fill cer_ls_m_repadj_fill cer_ls_m_year cer_ls_m_repadj_year cer_ls_m_type cer_ls_m_repadj_type cer_ls_m_source          /// ls m
	 cer_ls_f_fill cer_ls_f_repadj_fill cer_ls_f_year cer_ls_f_repadj_year cer_ls_f_type cer_ls_f_repadj_type cer_ls_f_source          /// ls f
	 cer_us_mf_fill cer_us_mf_repadj_fill cer_us_mf_year cer_us_mf_repadj_year cer_us_mf_type cer_us_mf_repadj_type cer_us_mf_source   /// us mf
	 cer_us_m_fill cer_us_m_repadj_fill cer_us_m_year cer_us_m_repadj_year cer_us_m_type cer_us_m_repadj_type cer_us_m_source          /// us m
	 cer_us_f_fill cer_us_f_repadj_fill cer_us_f_year cer_us_f_repadj_year cer_us_f_type cer_us_f_repadj_type cer_us_f_source          // us f
 
// Rename with _old suffix	 
//pp
rename (cer_pp_*_*) (cer_pp_*_*_old)
//p 
rename (cer_p_*_*) (cer_p_*_*_old)
//ls
rename (cer_ls_*_*) (cer_ls_*_*_old)
//us 
rename (cer_us_*_*) (cer_us_*_*_old)

// Converting into rates
foreach gen in mf m f{
	foreach lev in pp p ls us{
		replace cer_`lev'_`gen'_fill_old        = cer_`lev'_`gen'_fill_old/100
		replace cer_`lev'_`gen'_repadj_fill_old = cer_`lev'_`gen'_repadj_fill_old/100
	}
}

// Genrating final  old variables for 2010, 2015 and 2020 (fill, year, type, source)

foreach gen in mf m f{
	foreach lev in pp p ls us{
		gen cer_`lev'_`gen'_fill_2010_old = L16.cer_`lev'_`gen'_fill_old if year == 2025
		gen cer_`lev'_`gen'_fill_2015_old = L11.cer_`lev'_`gen'_fill_old if year == 2025
		//gen cer_`lev'_`gen'_fill_2018_old = L8.cer_`lev'_`gen'_fill_old  if year == 2025
		gen cer_`lev'_`gen'_fill_2020_old = L6.cer_`lev'_`gen'_fill_old  if year == 2025
		
		gen cer_`lev'_`gen'_repadj_fill_2010_old = L16.cer_`lev'_`gen'_repadj_fill_old if year == 2025
		gen cer_`lev'_`gen'_repadj_fill_2015_old = L11.cer_`lev'_`gen'_repadj_fill_old if year == 2025
		//gen cer_`lev'_`gen'_repadj_fill_2018_old = L8.cer_`lev'_`gen'_repadj_fill_old  if year == 2025
		gen cer_`lev'_`gen'_repadj_fill_2020_old = L6.cer_`lev'_`gen'_repadj_fill_old  if year == 2025

		gen cer_`lev'_`gen'_year_2010_old = L16.cer_`lev'_`gen'_year_old if year == 2025
		gen cer_`lev'_`gen'_year_2015_old = L11.cer_`lev'_`gen'_year_old if year == 2025
		//gen cer_`lev'_`gen'_year_2018_old = L8.cer_`lev'_`gen'_year_old  if year == 2025
		gen cer_`lev'_`gen'_year_2020_old = L6.cer_`lev'_`gen'_year_old  if year == 2025

		gen cer_`lev'_`gen'_type_2010_old = L16.cer_`lev'_`gen'_type_old if year == 2025
		gen cer_`lev'_`gen'_type_2015_old = L11.cer_`lev'_`gen'_type_old if year == 2025
		//gen cer_`lev'_`gen'_type_2018_old = L8.cer_`lev'_`gen'_type_old  if year == 2025
		gen cer_`lev'_`gen'_type_2020_old = L6.cer_`lev'_`gen'_type_old  if year == 2025

		// Year and type for no-repadj and rep-adjusted are the same so we aren't including those line segments
		
		gen cer_`lev'_`gen'_fill_src_2010_old = cer_`lev'_`gen'_source_old[_n-16] if year == 2025
		gen cer_`lev'_`gen'_fill_src_2015_old = cer_`lev'_`gen'_source_old[_n-11] if year == 2025
		//gen cer_`lev'_`gen'_fill_src_2018_old = cer_`lev'_`gen'_source_old[_n-8]  if year == 2025
		gen cer_`lev'_`gen'_fill_src_2020_old = cer_`lev'_`gen'_source_old[_n-6]  if year == 2025

	}
}

// Generating Primary through Secodary EYS for missing data from old primary, lower secondary and upper secondary data. Since education team provided us with ready made primary through secondary EYS in the latest dataset (final: eys_sa_`gen'_fill_`yr')

foreach gen in mf m f{
	foreach yr in 2010 2015  2020 { // 2018
		gen eys_`gen'_fill_`yr'_old        = (cer_p_`gen'_fill_`yr'_old*6) + (cer_ls_`gen'_fill_`yr'_old*3) + (cer_us_`gen'_fill_`yr'_old*3)
		gen eys_`gen'_repadj_fill_`yr'_old = (cer_p_`gen'_repadj_fill_`yr'_old*6) + (cer_ls_`gen'_repadj_fill_`yr'_old*3) + (cer_us_`gen'_repadj_fill_`yr'_old*3)
 	}
}

// Prioritizing rep adjusted EYS and then substituting non-rep adjusted EYS if rep adjusted missing
foreach gen in mf m f{
	foreach yr in 2010 2015  2020 { // 2018
		    gen eys_sa_`gen'_fill_`yr'_old     = eys_`gen'_repadj_fill_`yr'_old if year == 2025
		replace eys_sa_`gen'_fill_`yr'_old     = eys_`gen'_fill_`yr'_old        if year == 2025 & missing(eys_`gen'_repadj_fill_`yr'_old)
	
	}
}

tempfile enrol_old
save `enrol_old', replace

restore

merge 1:1 wbcode year using `enrol_old', keep(3) nogen

// replacing missing values with old values from old hci calculations
foreach gen in mf m f{
	foreach yr in 2010 2015  2020 { // 2018
		// for missing pre-primary in the new data 
		cap gen eys_pp_`gen'_fill_`yr'     = .
		replace eys_pp_`gen'_fill_`yr'     = cer_pp_`gen'_fill_`yr'_old         if x_`yr' == 1 & year == 2025
		cap gen eys_pp_`gen'_year_`yr'     = .
		replace eys_pp_`gen'_year_`yr'     = cer_pp_`gen'_year_`yr'_old 	    if x_`yr' == 1 & year == 2025
		cap gen eys_pp_`gen'_fill_src_`yr' = ""
		replace eys_pp_`gen'_fill_src_`yr' = cer_pp_`gen'_fill_src_`yr'_old     if x_`yr' == 1 & year == 2025
		
		// For missing primary through secondary EYS data
		cap gen eys_sa_`gen'_fill_`yr'     = .
		replace eys_sa_`gen'_fill_`yr'     = eys_sa_`gen'_fill_`yr'_old         if y_`yr' == 1 & year == 2025
		cap gen eys_sa_`gen'_year_`yr'     = .
		replace eys_sa_`gen'_year_`yr'     = cer_p_`gen'_year_`yr'_old          if y_`yr' == 1 & year == 2025
		cap gen eys_sa_`gen'_fill_src_`yr' = ""
		replace eys_sa_`gen'_fill_src_`yr' = cer_p_`gen'_fill_src_`yr'_old      if y_`yr' == 1 & year == 2025 // Unsure, seems like type not source
	}
}


*-------------------------------------------------------------------------------

//2.Education
// Assumed returns to school
	gen phi = 0.08

//3. Heatlh	
	// Assumed returns to health
	// Note how these are written out as product of two ingredients
	// Relation between height-asr (19.2) times assumed return to height
	// Relation between height-stunting (10.2) times assumed return to height

	// Returns to asr
	gen gam_asr 	= 0.034 * 19.2    // Returns to height times asr-to-height
	// Returns to stunting
    gen gam_stunt   = 0.034 * 10.2	  // Returns to height times stunting-to-height

foreach yr in $years{	
	foreach gen in mf m f{
		
	cap gen eys_pp_`gen'_fill_`yr' = . 
	cap gen eys_sa_`gen'_fill_`yr' = . 
		
	gen psurv_`gen'_`yr'     =  1 -	mort_0to4_`gen'_fill_`yr'        // IGME mortality complement
	gen nostu_`gen'_`yr'     =  1 - stunt_`gen'_fill_`yr'            // Stunting
	gen asr_`gen'_`yr'       =      surv_15to60_`gen'_fill_`yr'      // Adult survival rates
	gen eys_pp_`gen'_`yr'    =      eys_pp_`gen'_fill_`yr'*2         // Pre-Primary EYS (weight of 2 as discussed with the team)
	gen lays_`gen'_`yr'      =      ((eys_pp_`gen'_`yr' + eys_sa_`gen'_fill_`yr') * (hlo_`gen'_fill_`yr'/625))  // 5-17 years LAYS
	}
}

/******************************************************************************/
// Contribution of components of index to relative productivity differences
/******************************************************************************/
// 1. Survival
// Productivity relative to benchmark of 100 percent survival
	foreach yr in $years {
		foreach gen in m f mf{
				gen rph_sur_`gen'_`yr' = psurv_`gen'_`yr'
		}
	}
	
// 2. Education
// Productivity relative to benchmark of complete education
	foreach yr in $years {  
		foreach gen in mf m f{
				gen rph_edu_`gen'_`yr' = exp(phi*(lays_`gen'_`yr'-14))
			}
		}	
		

// 3. Health
// Productivity relative to benchmark of good health
// Baseline
	foreach yr in $years {   
		foreach gen in m f mf{
				gen rph_asr_`gen'_`yr' = exp(gam_asr*(asr_`gen'_`yr'-1))
				gen rph_stu_`gen'_`yr' = exp(gam_stunt*(nostu_`gen'_`yr'-1))
		}
	}	
	

// Overall returns to health that averages measures based on asr and stunting if both available, otherwise the one or the other
// Baseline weights
	foreach yr in $years { 
		foreach gen in m f mf{
			gen 	rph_hlth_`gen'_`yr' = rph_asr_`gen'_`yr' if rph_asr_`gen'_`yr'~=. & rph_stu_`gen'_`yr'==.
			replace rph_hlth_`gen'_`yr' = rph_stu_`gen'_`yr' if rph_stu_`gen'_`yr'~=. & rph_asr_`gen'_`yr'==.
			replace rph_hlth_`gen'_`yr' = sqrt(rph_stu_`gen'_`yr'*rph_asr_`gen'_`yr') if rph_stu_`gen'_`yr'~=. & rph_asr_`gen'_`yr'~=.
		}
	}	
		

/******************************************************************************/
// Overall Human Capital Index
/******************************************************************************/
		
// With baseline weights
	foreach yr in  $years {  
		foreach gen in mf m f{
				gen hci_`gen'_`yr' = rph_sur_`gen'_`yr'*rph_edu_`gen'_`yr'*rph_hlth_`gen'_`yr'
		}
	}		
	
/******************************************************************************/
// Label variables created here
/******************************************************************************/
	foreach yr in  $years {	
		foreach gen in m f mf{
			label var hci_`gen'_`yr' 	"Human Capital Index `yr', gender=`gen'"
			label var psurv_`gen'_`yr' "Prob Survival to Age 5, gender=`gen', as used in HCI `yr'"
			label var lays_`gen'_`yr' "Learning-adjusted Expected Years of School, gender=`gen',as used in HCI `yr'"
			label var nostu_`gen'_`yr' "Fraction of Children Under 5 Not Stunted, gender=`gen', as used in HCI `yr'"
			label var asr_`gen'_`yr' "Adult Survival Rate, gender=`gen', as used in HCI `yr'"
			label var rph_edu_`gen'_`yr' "Contribution of Education to Productivity, gender=`gen', as used in HCI `yr'"
			label var rph_hlth_`gen'_`yr' "Contribution of Health to Productivity, gender=`gen', as used in HCI `yr'"
			label var rph_sur_`gen'_`yr' "Contribution of Survival to Productivity, gender=`gen', as used in HCI `yr'"
		}
	}		
	
*-------------------------------------------------------------------------------
// Save dataset
sort wbcode year
// Condensing for GitHub
keeporder wbcode wbcountryname year new_wbregion new_wbincomegroup old_wbregion old_wbincomegroup ///
          hci_*_2010 hci_*_2015  hci_*_2020 hci_*_2025 /// hci_*_2018
		  psurv_*_2010 psurv_*_2015  psurv_*_2020 psurv_*_2025 mort_0to4_*_year_* mort_0to4_*_src_* mort_0to4_*_fill /// psurv_*_2018
		  eys_pp_*_2010 eys_pp_*_2015 eys_pp_*_2020 eys_pp_*_2025  cer_pp_*_year_* cer_pp_*_fill_src_* cer_pp_*_fill /// eys_pp_*_2018
		  eys_sa_*_fill_2010 eys_sa_*_fill_2015  eys_sa_*_fill_2020  eys_sa_*_fill_2025 eys_sa_*_year_* eys_sa_*_fill_src_* eys_sa_*_fill /// eys_sa_*_fill_2018
		  hlo_*_fill_2010 hlo_*_fill_2015  hlo_*_fill_2020 hlo_*_fill_2025 hlo_*_year_* hlo_*_source_*  /// hlo_*_fill_2018
		  lays_*_2010 lays_*_2015  lays_*_2020 lays_*_2025  /// lays_*_2018
		  nostu_*_2010 nostu_*_2015  nostu_*_2020 nostu_*_2025 stunt_*_year_* stunt_*_fill_src_* stunt_svy_*_fill /// nostu_*_2018
		  asr_*_2010 asr_*_2015  asr_*_2020 asr_*_2025 surv_15to60_*_year_* surv_15to60_*_src_* surv_15to60_*_fill ///   asr_*_2018
		  rph_edu_*_2010 rph_edu_*_2015  rph_edu_*_2020 rph_edu_*_2025 /// rph_edu_*_2018
		  rph_hlth_*_2010 rph_hlth_*_2015  rph_hlth_*_2020 rph_hlth_*_2025 /// rph_hlth_*_2018
		  rph_sur_*_2010 rph_sur_*_2015  rph_sur_*_2020 rph_sur_*_2025     //rph_sur_*_2018
		  
		 
compress		
sa "$clone/03_output/Old_hci.dta", replace

*-------------------------------------------------------------------------------
// Checks
// Survival and Health has universal coverage. Only sample limiting factor is Education (Lays)
su hci*
su 	rph_edu_*_*
sum psurv_*_2025  // available for less countries (195) as opposed to UNPD survival data (217)
*-------------------------------------------------------------------------------