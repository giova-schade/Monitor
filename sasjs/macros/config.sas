/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
    @li messagebe.sas

**/


%macro getConfig();
    libname FCST_STG '/sasshared/fcst_stage/';
    proc sql;
        create table datos as select * from FCST_STG.ConfCargaInput;
    quit;
    %MESSAGEBE(e="",outds=work.status,estado=ok);

%mend getConfig;