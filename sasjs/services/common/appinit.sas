/**
  @file appinit.sas
  @brief Initialisation service - runs on app startup
  @details  This is always the first service called when the app is opened.

  <h4> SAS Macros </h4>
  @li mf_getuser.sas
  @li get_meta_groups.sas

**/
/*cargo datos desde la web para almacenarlos en la work */
%webout(FETCH);

%global  dtlog;
%let dtlog = %sysfunc(compress(%sysfunc(putn(%sysfunc(date()),yymmdd7.))))_%sysfunc(compress(%sysfunc(tranwrd(%sysfunc(putn(%sysfunc(time()),time.)),:,))));
proc printto log="/sasdata/opt/data/sas_psd/Procesos/logs/MonitorAppInit_&dtlog..log";
run;
/*llamo a macro function desde la carpeta de macros al proceso get_meta_groups */
%get_meta_groups(_user="%mf_getuser()",outds=work.groups)

data config;
  infile datalines dsd dlm=','; 
  input ROL : $20. permision : $20.;
datalines;
MonitorAdmin,Home
MonitorAdmin,UploadInput
MonitorAdmin,Configuration
MonitorAdmin,ProcessExecutions
User,Home
;
run;
%webout(OPEN)

%webout(OBJ,groups)
%webout(OBJ,config)
%webout(CLOSE)
