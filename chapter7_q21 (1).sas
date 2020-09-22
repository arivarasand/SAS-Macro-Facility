/******************************************************************************************
The United States Department of Transportation publishes statistics on many modes of
transportation. The SAS data set called AIRTRAFFIC contains data on the number of flights and
passengers leaving 12 major airports in the United States. The data set contains data from each
airline, for each quarter, for 20 years. In addition to the variables for year, quarter, and airline,
there are two variables representing number of flights and passengers for each of the 12 airports.
The variable names for the flights and passengers all start with the three-letter airport code: ATL
(Atlanta), BOS (Boston), DEN (Denver), DFW (Dallas Fort Worth), EWR (Newark), HNL
(Honolulu), LAX (Los Angeles), MIA (Miami), ORD (Chicago), SAN (San Diego), SEA (Seattle), and
SFO (San Francisco). The data are sorted by year, airline, and quarter.
a. Examine this SAS data set including the variable labels and attributes. For BOS (Boston), create
a data set that contains variables for the sum of the flights and for the sum of the passengers
over all quarters, for each airline for one selected year of your choice. Use a macro variable to
specify the value of the selected year.
b. Use the data set from part a) to create another data set with one observation for the airline
with the most passengers for the selected year. Create a variable that represents the number of
passengers per flight for that one year and airline. Round this value to a whole number.
c. Convert your code for parts a) and b) into a macro so that it can be run for any airport. Call the
macro once for each of the 12 airports.
d. Combine the 12 data sets containing the airline with the most passengers generated in part c)
into a data set with one observation for each airport.
e. Print the data set from part d) including variables for the airport code, airline name, total
flights, total passengers, and the number of passengers per flight. Include the selected year in
the title for the report.
f. Run the program again selecting a different year.

******************************************************************************************/


libname practice "/folders/myfolders/sasuser.v94";

proc contents data=practice.AIRTRAFFIC varnum;
run;

%MACRO mostPassengersPerYear(yearVal, airportAbbr);
	PROC MEANS data=practice.AIRTRAFFIC(KEEP=Year Airline Quarter &airportAbbr.:) 
			MAXDEC=2 NOPRINT;
		BY Airline Year;
		VAR &airportAbbr.Flights &airportAbbr.Passengers;
		OUTPUT OUT=&airportAbbr._summary(DROP=_FREQ_ _TYPE_) 
			SUM(&airportAbbr.Flights &airportAbbr.Passengers)=FlightsSum PassengerSum;
		WHERE Year=&yearVal;

	PROC SORT data=&airportAbbr._summary;
		BY DESCENDING PassengerSum;
	RUN;

	DATA _NULL_;
		SET &airportAbbr._summary;

		IF _N_=1 THEN
			CALL SYMPUT("mostpassengers", Airline);
		ELSE
			STOP;
	RUN;

	
	DATA &airportAbbr._&yearVal._summary;
		SET &airportAbbr._summary;
		AirportCode="&airportAbbr";
		WHERE Airline="&mostpassengers";
	RUN;

%MEND mostPassengersPerYear;

/
%LET yearVal = 2010;
%mostPassengersPerYear(&yearVal, ATL) %mostPassengersPerYear(&yearVal, BOS) 
	%mostPassengersPerYear(&yearVal, DEN) %mostPassengersPerYear(&yearVal, DFW) 
	%mostPassengersPerYear(&yearVal, EWR) %mostPassengersPerYear(&yearVal, HNL) 
	%mostPassengersPerYear(&yearVal, LAX) %mostPassengersPerYear(&yearVal, MIA) 
	%mostPassengersPerYear(&yearVal, ORD) %mostPassengersPerYear(&yearVal, SAN) 
	%mostPassengersPerYear(&yearVal, SEA) %mostPassengersPerYear(&yearVal, SFO) 
	DATA airport_summary;
SET atl_&yearVal._summary bos_&yearVal._summary den_&yearVal._summary 
	dfw_&yearVal._summary ewr_&yearVal._summary hnl_&yearVal._summary 
	lax_&yearVal._summary mia_&yearVal._summary ord_&yearVal._summary 
	san_&yearVal._summary sea_&yearVal._summary sfo_&yearVal._summary;
RUN;