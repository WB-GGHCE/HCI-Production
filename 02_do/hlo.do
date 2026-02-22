
*===============================================================================
*===============================================================================
//						Component 4. Harmonized learning outcomes
// 	  				***   Harmonized learning outcomes for HCI    ***
*===============================================================================
*===============================================================================

/******************************************************************************/

// Do file to input raw data and standardize dataset and naming conventions.

/******************************************************************************/
// Purpose		    : To prepare HLO data  
// Input datasets	: hlo_combined_2025_2020.dta
// Data Sources     : Education analytics team
// Source Used		: 

// Output dataset	: hlo_data.dta
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

*===============================================================================
// 0. Set globals
*===============================================================================

clear
cls
version 18
set more off

dir "$clone"

*------------------------------------------------------------------------------			
// The latest HLO dataset from Education team
use "${clone}/01_data/hlo/hlo_combined_2025_2020.dta", clear

*-------------------------------------------------------------------------------
// Merge with master data file
merge m:1 wbcode year using "$clone\01_data\misc\masterdata.dta",  keep(2 3) nogen
drop if wbcode =="x"
sort wbcode year
*-------------------------------------------------------------------------------


* Drop some outliers
*drop china test that is "PISA (Shanghai Only)"
drop if wbcode=="CHN" & test=="PISA (Shanghai Only)"
drop if wbcode=="KHM" & test=="EGRA"

*===============================================================================
// 1. Identify 2025 test for each country (before collapsing)
*===============================================================================

// Get the test used for 2025 for each country (needed for deduplication)
gen str100 test_2025 = ""
replace test_2025 = test if hlo_25_dummy == 1
bysort wbcode (year): egen temp_test = mode(test_2025), maxmode
replace test_2025 = temp_test
drop temp_test

*===============================================================================
// 2. Make data unique by country-year
//    Priority: 1) Keep assessments matching test_2025
//              2) Drop EGRA/EGRANR/MICS if other assessments exist
//              3) If still duplicates, average values and concatenate sources
*===============================================================================

// Step 1: Flag observations that match the 2025 test
gen byte matches_2025_test = (test == test_2025) if test_2025 != ""

// Step 2: Flag low-priority assessments (EGRA, EGRANR, MICS)
gen byte is_low_priority = (strpos(upper(test), "EGRA") > 0 | ///
                            strpos(upper(test), "EGRANR") > 0 | ///
                            strpos(upper(test), "MICS") > 0)

// Step 3: Check for duplicates
bysort wbcode year: gen n_obs = _N
bysort wbcode year: egen has_match = max(matches_2025_test)

// Step 4: Drop non-matching assessments when matching ones exist
drop if n_obs > 1 & has_match == 1 & matches_2025_test == 0
drop n_obs has_match

// Step 5: Recheck for duplicates and drop low-priority assessments if others exist
bysort wbcode year: gen n_obs = _N
bysort wbcode year: egen has_high_priority = max(1 - is_low_priority)

// Drop low-priority assessments when high-priority ones exist
drop if n_obs > 1 & has_high_priority == 1 & is_low_priority == 1
drop n_obs has_high_priority matches_2025_test is_low_priority

// Step 6: For remaining duplicates, collapse by averaging values and concatenating sources
// First, check if there are still duplicates
bysort wbcode year: gen n_obs = _N
qui sum n_obs
local max_dups = r(max)

if `max_dups' > 1 {
	// Create concatenated test variable for duplicates
	// Sort by wbcode year test, then build concatenated string
	sort wbcode year test
	by wbcode year: gen test_order = _n
	by wbcode year: gen str200 test_concat = test if test_order == 1
	by wbcode year: replace test_concat = test_concat[_n-1] + " / " + test if test_order > 1
	
	// Carry forward the final concatenated value to all obs in group
	by wbcode year: gen str200 test_combined = test_concat[_N]
	
	// Collapse to unique country-year
	collapse (mean) hlo_mf hlo_m hlo_f os_mf os_m os_f hlo_exrt ///
			 (max) hlo_20_dummy hlo_25_dummy ///
			 (firstnm) test_year_2020 test_2025 ///
			 (firstnm) test_combined, ///
			 by(wbcode year)
	
	// Rename combined test back to test
	rename test_combined test
}
else {
	drop n_obs
}

// Verify uniqueness
isid wbcode year

*===============================================================================
// 3. Setup panel
*===============================================================================

// Create countrynumber for panel operations
cap drop countrynumber
encode wbcode, gen(countrynumber)
sort countrynumber year
xtset countrynumber year

*===============================================================================
// 4. Create 2025 variables using hlo_25_dummy
*===============================================================================

// For 2025: Use the assessment flagged by hlo_25_dummy == 1
// Window: 2014-2025 (10 years prior to 2025)

foreach gen in mf m f {
	// Initialize variables
	gen hlo_`gen'_fill_2025 = .
	gen hlo_`gen'_year_2025 = .
	gen str100 hlo_`gen'_source_2025 = ""
}

// Fill 2025 values from the flagged assessment
foreach gen in mf m f {
	replace hlo_`gen'_fill_2025 = hlo_`gen' if hlo_25_dummy == 1
	replace hlo_`gen'_year_2025 = year if hlo_25_dummy == 1
	replace hlo_`gen'_source_2025 = test if hlo_25_dummy == 1
}

// Propagate to all observations within each country (so each country has one 2025 value)
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2025)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2025)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2025), maxmode
	
	replace hlo_`gen'_fill_2025 = temp_fill
	replace hlo_`gen'_year_2025 = temp_year
	replace hlo_`gen'_source_2025 = temp_src
	
	drop temp_fill temp_year temp_src
}

// Enforce 10-year window for 2025 (2014-2025)
foreach gen in mf m f {
	replace hlo_`gen'_fill_2025 = . if hlo_`gen'_year_2025 < 2014 | hlo_`gen'_year_2025 > 2025
	replace hlo_`gen'_source_2025 = "" if hlo_`gen'_year_2025 < 2014 | hlo_`gen'_year_2025 > 2025
	replace hlo_`gen'_year_2025 = . if hlo_`gen'_year_2025 < 2014 | hlo_`gen'_year_2025 > 2025
}

*===============================================================================
// 5. Create 2020 variables using hlo_20_dummy
*===============================================================================

// For 2020: Use the assessment flagged by hlo_20_dummy == 1
// Window: 2010-2020 (10 years prior to 2020)

foreach gen in mf m f {
	gen hlo_`gen'_fill_2020 = .
	gen hlo_`gen'_year_2020 = .
	gen str100 hlo_`gen'_source_2020 = ""
}

// Fill 2020 values from the flagged assessment
foreach gen in mf m f {
	replace hlo_`gen'_fill_2020 = hlo_`gen' if hlo_20_dummy == 1
	replace hlo_`gen'_year_2020 = year if hlo_20_dummy == 1
	replace hlo_`gen'_source_2020 = test if hlo_20_dummy == 1
}

// Propagate to all observations within each country
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2020)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2020)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2020), maxmode
	
	replace hlo_`gen'_fill_2020 = temp_fill
	replace hlo_`gen'_year_2020 = temp_year
	replace hlo_`gen'_source_2020 = temp_src
	
	drop temp_fill temp_year temp_src
}

// Enforce 10-year window for 2020 (2010-2020)
foreach gen in mf m f {
	replace hlo_`gen'_fill_2020 = . if hlo_`gen'_year_2020 < 2010 | hlo_`gen'_year_2020 > 2020
	replace hlo_`gen'_source_2020 = "" if hlo_`gen'_year_2020 < 2010 | hlo_`gen'_year_2020 > 2020
	replace hlo_`gen'_year_2020 = . if hlo_`gen'_year_2020 < 2010 | hlo_`gen'_year_2020 > 2020
}

*===============================================================================
// 5.5. Create 2018 variables (window: 2007-2017)
//    Hierarchy: 1) Match 2025 test, 2) Most recent in window
*===============================================================================
foreach gen in mf m f {
	gen hlo_`gen'_fill_2018 = .
	gen hlo_`gen'_year_2018 = .
	gen str100 hlo_`gen'_source_2018 = ""
}

// Step 1: Try to match the 2025 test within 2018 window (2007-2017)
foreach gen in mf m f {
	// Mark observations in window that match 2025 test
	gen byte in_window_2018 = (year >= 2007 & year <= 2017 & test == test_2025 & hlo_`gen' != .)
	
	// Get the maximum year among matching observations
	bysort wbcode (year): egen max_match_year = max(year * in_window_2018)
	
	// Fill values from the matching observation
	replace hlo_`gen'_fill_2018 = hlo_`gen' if year == max_match_year & in_window_2018 == 1
	replace hlo_`gen'_year_2018 = year if year == max_match_year & in_window_2018 == 1
	replace hlo_`gen'_source_2018 = test if year == max_match_year & in_window_2018 == 1
	
	drop in_window_2018 max_match_year
}

// Propagate matched values to all observations
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2018)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2018)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2018), maxmode
	
	replace hlo_`gen'_fill_2018 = temp_fill
	replace hlo_`gen'_year_2018 = temp_year
	replace hlo_`gen'_source_2018 = temp_src
	
	drop temp_fill temp_year temp_src
}

// Step 2: If no match found, use most recent in window (2007-2017)
foreach gen in mf m f {
	// Mark observations in window (only if we haven't already filled)
	gen byte in_window = (year >= 2007 & year <= 2017 & hlo_`gen' != .)
	
	// For countries without a matched value, find most recent
	bysort wbcode (year): egen max_year_in_window = max(year * in_window)
	
	// Fill only if 2018 values are still missing
	replace hlo_`gen'_fill_2018 = hlo_`gen' if year == max_year_in_window & hlo_`gen'_fill_2018 == . & in_window == 1
	replace hlo_`gen'_year_2018 = year if year == max_year_in_window & hlo_`gen'_year_2018 == . & in_window == 1
	replace hlo_`gen'_source_2018 = test if year == max_year_in_window & hlo_`gen'_source_2018 == "" & in_window == 1
	
	drop in_window max_year_in_window
}

// Re-propagate to ensure all observations have the value
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2018)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2018)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2018), maxmode
	
	replace hlo_`gen'_fill_2018 = temp_fill
	replace hlo_`gen'_year_2018 = temp_year
	replace hlo_`gen'_source_2018 = temp_src
	
	drop temp_fill temp_year temp_src
}



*===============================================================================
// 6. Create 2015 variables (window: 2004-2014)
//    Hierarchy: 1) Match 2025 test, 2) Most recent in window
*===============================================================================

foreach gen in mf m f {
	gen hlo_`gen'_fill_2015 = .
	gen hlo_`gen'_year_2015 = .
	gen str100 hlo_`gen'_source_2015 = ""
}

// test_2025 already created in section 1

// Step 1: Try to match the 2025 test within 2015 window (2004-2014)
// Find the most recent observation matching 2025 test in window
foreach gen in mf m f {
	// Mark observations in window that match 2025 test
	gen byte in_window_2015 = (year >= 2004 & year <= 2014 & test == test_2025 & hlo_`gen' != .)
	
	// Get the maximum year among matching observations
	bysort wbcode (year): egen max_match_year = max(year * in_window_2015)
	
	// Fill values from the matching observation
	replace hlo_`gen'_fill_2015 = hlo_`gen' if year == max_match_year & in_window_2015 == 1
	replace hlo_`gen'_year_2015 = year if year == max_match_year & in_window_2015 == 1
	replace hlo_`gen'_source_2015 = test if year == max_match_year & in_window_2015 == 1
	
	drop in_window_2015 max_match_year
}

// Propagate matched values to all observations
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2015)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2015)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2015), maxmode
	
	replace hlo_`gen'_fill_2015 = temp_fill
	replace hlo_`gen'_year_2015 = temp_year
	replace hlo_`gen'_source_2015 = temp_src
	
	drop temp_fill temp_year temp_src
}

// Step 2: If no match found, use most recent in window (2004-2014)
foreach gen in mf m f {
	// Mark observations in window (only if we haven't already filled)
	gen byte in_window = (year >= 2004 & year <= 2014 & hlo_`gen' != .)
	
	// For countries without a matched value, find most recent
	bysort wbcode (year): egen max_year_in_window = max(year * in_window)
	
	// Fill only if 2015 values are still missing
	replace hlo_`gen'_fill_2015 = hlo_`gen' if year == max_year_in_window & hlo_`gen'_fill_2015 == . & in_window == 1
	replace hlo_`gen'_year_2015 = year if year == max_year_in_window & hlo_`gen'_year_2015 == . & in_window == 1
	replace hlo_`gen'_source_2015 = test if year == max_year_in_window & hlo_`gen'_source_2015 == "" & in_window == 1
	
	drop in_window max_year_in_window
}

// Re-propagate to ensure all observations have the value
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2015)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2015)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2015), maxmode
	
	replace hlo_`gen'_fill_2015 = temp_fill
	replace hlo_`gen'_year_2015 = temp_year
	replace hlo_`gen'_source_2015 = temp_src
	
	drop temp_fill temp_year temp_src
}

*===============================================================================
// 7. Create 2010 variables (window: 1999-2009)
//    Hierarchy: 1) Match 2025 test, 2) Most recent in window
*===============================================================================

foreach gen in mf m f {
	gen hlo_`gen'_fill_2010 = .
	gen hlo_`gen'_year_2010 = .
	gen str100 hlo_`gen'_source_2010 = ""
}

// Step 1: Try to match the 2025 test within 2010 window (1999-2009)
foreach gen in mf m f {
	// Mark observations in window that match 2025 test
	gen byte in_window_2010 = (year >= 1999 & year <= 2009 & test == test_2025 & hlo_`gen' != .)
	
	// Get the maximum year among matching observations
	bysort wbcode (year): egen max_match_year = max(year * in_window_2010)
	
	// Fill values from the matching observation
	replace hlo_`gen'_fill_2010 = hlo_`gen' if year == max_match_year & in_window_2010 == 1
	replace hlo_`gen'_year_2010 = year if year == max_match_year & in_window_2010 == 1
	replace hlo_`gen'_source_2010 = test if year == max_match_year & in_window_2010 == 1
	
	drop in_window_2010 max_match_year
}

// Propagate matched values to all observations
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2010)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2010)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2010), maxmode
	
	replace hlo_`gen'_fill_2010 = temp_fill
	replace hlo_`gen'_year_2010 = temp_year
	replace hlo_`gen'_source_2010 = temp_src
	
	drop temp_fill temp_year temp_src
}

// Step 2: If no match found, use most recent in window (1999-2009)
foreach gen in mf m f {
	// Mark observations in window (only if we haven't already filled)
	gen byte in_window = (year >= 1999 & year <= 2009 & hlo_`gen' != .)
	
	// For countries without a matched value, find most recent
	bysort wbcode (year): egen max_year_in_window = max(year * in_window)
	
	// Fill only if 2010 values are still missing
	replace hlo_`gen'_fill_2010 = hlo_`gen' if year == max_year_in_window & hlo_`gen'_fill_2010 == . & in_window == 1
	replace hlo_`gen'_year_2010 = year if year == max_year_in_window & hlo_`gen'_year_2010 == . & in_window == 1
	replace hlo_`gen'_source_2010 = test if year == max_year_in_window & hlo_`gen'_source_2010 == "" & in_window == 1
	
	drop in_window max_year_in_window
}

// Re-propagate to ensure all observations have the value
foreach gen in mf m f {
	bysort wbcode (year): egen temp_fill = max(hlo_`gen'_fill_2010)
	bysort wbcode (year): egen temp_year = max(hlo_`gen'_year_2010)
	bysort wbcode (year): egen temp_src = mode(hlo_`gen'_source_2010), maxmode
	
	replace hlo_`gen'_fill_2010 = temp_fill
	replace hlo_`gen'_year_2010 = temp_year
	replace hlo_`gen'_source_2010 = temp_src
	
	drop temp_fill temp_year temp_src
}

// Clean up temporary variable
drop test_2025

*===============================================================================
// 8. Label variables
*===============================================================================

foreach gen in mf m f {
	label var hlo_`gen'_fill_2025   "HLO `gen': filled value for 2025"
	label var hlo_`gen'_year_2025   "HLO `gen': source year for 2025"
	label var hlo_`gen'_source_2025 "HLO `gen': assessment source for 2025"
	
	label var hlo_`gen'_fill_2020   "HLO `gen': filled value for 2020"
	label var hlo_`gen'_year_2020   "HLO `gen': source year for 2020"
	label var hlo_`gen'_source_2020 "HLO `gen': assessment source for 2020"

	label var hlo_`gen'_fill_2018   "HLO `gen': filled value for 2018"
	label var hlo_`gen'_year_2018   "HLO `gen': source year for 2018"
	label var hlo_`gen'_source_2018 "HLO `gen': assessment source for 2018"
	
	label var hlo_`gen'_fill_2015   "HLO `gen': filled value for 2015"
	label var hlo_`gen'_year_2015   "HLO `gen': source year for 2015"
	label var hlo_`gen'_source_2015 "HLO `gen': assessment source for 2015"
	
	label var hlo_`gen'_fill_2010   "HLO `gen': filled value for 2010"
	label var hlo_`gen'_year_2010   "HLO `gen': source year for 2010"
	label var hlo_`gen'_source_2010 "HLO `gen': assessment source for 2010"
}

*-------------------------------------------------------------------------------	
// Saving HLO Final data
save "$clone/03_output/hlo_data.dta", replace  
   
*-------------------------------------------------------------------------------