The Human Capital Index
================

The Human Capital Index (HCI) measures **the human capital that a child
born today can expect to attain by her 18th birthday**, given the risks
of poor health and poor education prevailing in her country. The index
incorporates measures of different dimensions of human capital: health
(child survival, stunting, and adult survival rates) and the quantity
and quality of schooling (expected years of school and international
test scores). The HCI uses global estimates of the economic returns to
education and health to create an integrated index that captures the
expected productivity of a child born today as a future worker, relative
to a benchmark of complete education and full health. 

The HCI was launched in 2018 as part of the Human Capital Project, a
global effort to accelerate progress toward a world where all children
can achieve their full potential. The HCI highlights how current health
and education outcomes shape the productivity of the next generation of
workers. It underscores the importance for governments and societies of
investing in the human capital of their citizens. 

For more details, please visit:
<https://www.worldbank.org/en/publication/human-capital>

## Directory Structure

1. **01_data** contains the raw data for the project for each indicator.

2. **02_do** contains the main replication files for the project. All the code is written in Stata. The entire project can be run by running the file `run_HCI.do`.

3. **03_output**. This folder contains a number of final output files in Stata .dta format. The final dataset is `03_output/hci_data.dta`.

## Instructions to Replicators

* Clone the repository to your local machine.
* Please run `run_HCI.do` to generate the data. This file will run all of the code to generate the data. The replicator should expect the code to run for around **1-2** minutes.
* There should be no need to change the working directory. The code should provide a prompt to change the working directory if necessary.

## The HCI Methodology

The HCI is designed to highlight how improvements in current health and
education outcomes shape the productivity of the next generation of
workers, assuming that children born today experience over the next 18
years the same educational opportunities and health risks as children
currently in this age range.

Several criteria have guided the design of the HCI. First, the HCI is
outcome- rather than inputs-based, focusing the conversation on what
matters—results. Second, the likelihood that a cross-country
benchmarking exercise can spur policy action is strongly influenced by
the over-time and cross-country coverage of the metric. The HCI aims
for good coverage and limits the choice of components to data that are
systematically collected for a large number of economies over time.
Third, for the index to promote change, the components of the HCI
should be responsive to policy action in the short to medium term. The
need to produce such a metric has oriented the index toward measuring
the human capital of the next generation. 



## The components of the HCI

The HCI captures key stages of a child’s trajectory from birth to
adulthood. It quantitatively illustrates the key stages in a child’s
human capital trajectory and their consequences for the productivity
of the next generation of workers, with three components:


## 1. Survival:

Survival from birth to school age, measured using under-5 mortality rates.


## 2. School:

Expected years of learning-adjusted school, combining information on
the quantity and quality of education. The quantity of education is
measured as the number of years of school a child can expect to obtain
by age 18 given the prevailing pattern of enrollment rates across grades.
The quality of education reflects work undertaken at the World Bank to
harmonize test scores from major international student achievement
testing programs. These two measures are combined into a measure of
learning-adjusted years of schooling


## 3. Health:

In the absence of a single broadly accepted, directly measured, and
widely available metric, the overall health environment is captured
by two proxies: (1) adult survival rates, defined as the fraction of
15-year-olds who survive until age 60, and (2) the rate of stunting
for children under age 5. Adult survival rates can be interpreted as
a proxy for the range of fatal and nonfatal health outcomes that a
child born today would experience as an adult, if current conditions
prevail into the future. Stunting is broadly accepted as a proxy for
the prenatal, infant, and early childhood health environments, and so
summarizes the risks to good health that children born today are likely
to experience in their early years—with important consequences for
health and well-being in adulthood. 
