/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li get_Monitor.sas
**/
%webout(FETCH);
%global  dtlog;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/getMonitor&dtlog..log";
run;
%let id_proceso=;
data _null_; 
set work.paramlog; 
    call symputx('id_proceso',field);
run; 

%put [&id_proceso];
%getMonitor(tabla=TABLON_STATUS_PROCESOS,id_proceso=&id_proceso);