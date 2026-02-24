* ***************************************************************************  *
*			Reproducibility Package for Human Capital Index                    * 
*																			   *
*  PROJECT TITLE: 		Human Capital Index 						           *
*																 			   *
*  PURPOSE:  			Run complete project for HCI                           *
*  AUTHOR: 				Brian Stacy, Zeeshan Haider  						   *
*  DATE:  				01/08/2026											   *
*  LATEST UPDATE: 		01/08/2026                                             *
*  Modified by:         Zeeshan Haider										   *
*		  																	   *
********************************************************************************

* Check that project profile was loaded, otherwise stops code
cap assert ${profile_is_loaded} == 1
if _rc {
  noi disp as error "Please execute the profile initialization do in the root of this project and try again."
  exit 601
}

*-------------------------------------------------------------------------------
* Run all tasks in this project
*-------------------------------------------------------------------------------

* TASK: create indicators for under 5 mortality component
do "${clone}/02_do/u5mr.do"

* TASK: create indicators for stunting component
do "${clone}/02_do/stunt.do"

* TASK: create indicators for adult survival component
do "${clone}/02_do/asr.do"

* TASK: create indicators for expected years of school component
do "${clone}/02_do/eys.do"

* TASK: create indicators for harmonized learning outcomes component
do "${clone}/02_do/hlo.do"

*** TASK: Calculate Human Capital Index for 2025, 2020, 2015 & 2010
do "${clone}/02_do/hci_calc.do"

*-------------------------------------------------------------------------------