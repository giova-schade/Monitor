/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li messagebe.sas

**/
%macro getReprocess();
    libname FCST_STG '/sasshared/fcst_stage/';
    proc sql;
        create table datos as 
        select id_proceso , Nombre_proceso , label  from FCST_STG.reprocesoConfig;
        quit;
    quit;
    %MESSAGEBE(e="",outds=work.status,estado=ok);            
    %webout(OPEN);
    %webout(OBJ,datos);
    %webout(OBJ,status);
    %webout(CLOSE);
%mend;