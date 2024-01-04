/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li update_Reglas.sas
**/
%webout(FETCH)
%global  dtlog NombreProceso NombreRegla NuevoEstado;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/updateReglas&dtlog.log";
run;

%put _all_;


data _null_;
  set work.reglaTable;
  call symputx('NombreProceso',NombreProceso);
  call symputx('NombreRegla',NombreRegla);
  call symputx('NuevoEstado',NuevoEstado);
run;

%updateReglas(NombreProceso=&NombreProceso,NombreRegla=&NombreRegla,NuevoEstado=&NuevoEstado);