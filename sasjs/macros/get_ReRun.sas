/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li messagebe.sas

**/
%macro getReRun(id_proceso=);
    libname FCST_STG '/sasshared/fcst_stage/';
    proc sql noprint;
        
        select id_proceso , Nombre_proceso , label , execute into :id_proceso , :Nombre_proceso , :label , :execute   
        from FCST_STG.reprocesoConfig where id_proceso = "&id_proceso";
        quit;
    quit;
    %put id_proceso:&id_proceso Nombre_proceso:&Nombre_proceso label:&label execute:&execute;
    Filename filelist pipe "&execute"; 
                                                                                   
   Data _null_;                                        
     Infile filelist truncover;
     Input filename $100.;
     Put filename=;
   Run; 
    %MESSAGEBE(e="Proceso enviado a ejecutar",outds=work.status,estado=ok);            
    %webout(OPEN);
    %webout(OBJ,status);
    %webout(CLOSE);
%mend;