/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li downloadFile.sas

**/
libname FCST_STG '/sasshared/fcst_stage/';
%global path;
proc sql;
select  path into :path from FCST_STG.ConfCargaInput where file = "&file";
quit;
%donwloadFile(path=&path);

