/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li get_ReRun.sas
**/
%webout(FETCH)
%global  dtlog id_proceso;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/getReRun&dtlog..log";
run;

%put _all_;

data _null_;
  set work.reRunTable;
call symputx('id_proceso',id_proceso);
run;
%getReRun(id_proceso=&id_proceso);