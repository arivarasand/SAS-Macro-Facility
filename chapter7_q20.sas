/*
The National Oceanic and Atmospheric Administration (NOAA) tracks oceanographic data at
stations across the United States. The SAS data set called VIRGINIAKEY contains meteorological
data for one year for the Virginia Key station located near Miami, Florida.
a. Examine this SAS data set including the variable labels and attributes. Create a frequency report
for month and another report that lists basic descriptive statistics (N, mean, standard deviation,
minimum, and maximum) for air temperature.
b. Convert the code from part a) into a macro that will produce either the frequency report or the
56
descriptive statistics report based on a value of a parameter that is passed to the macro.
c. Add a parameter to the macro that can control which variable is used for the report.
d. Add a title that reflects the type of report (frequency or descriptive statistics) with a short
description of the variable. Specify the description of the variable as a parameter for the macro.
*/
libname practice "/folders/myfolders/sasuser.v94";

proc contents data=practice.virginiakey varnum;
run;

proc freq data=practice.virginiakey;
tables Month;
run;

proc means data=practice.virginiakey;
var AirTemp ;
run;

%macro virginiakey(v1,v2);

proc freq data=practice.virginiakey;
tables &v1.;
title" frequency by  &v1."; 
run;

proc means data=practice.virginiakey;
var &v2. ;
title" basic descriptive statistics for &v2.";
run;

%mend virginiakey;
%virginiakey(Month,AirTemp)




