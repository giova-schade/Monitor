/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li put_DataField.sas
**/

/* this macro converts the JS input to a WORK table - work.areas */

%global  dtlog;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/putFile&dtlog..log";
run;
%put _all_;
%putDataField(name="&TABINFO");
