/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li config.sas
**/
/* this macro converts the JS input to a WORK table - work.areas */
%global  dtlog;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/getConfig&dtlog..log";
run;
%webout(FETCH)
%getConfig();
/* these macros open the JSON, send the table back, and close the JSON */
%webout(OPEN);
%webout(OBJ,datos);
%webout(OBJ,status);
%webout(CLOSE);