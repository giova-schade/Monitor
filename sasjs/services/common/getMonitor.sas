/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li get_Monitor.sas
**/
%global  dtlog;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/getMonitor&dtlog.log";
run;

%getMonitor(tabla=TABLON_STATUS_PROCESOS);