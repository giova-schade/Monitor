/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li messagebe.sas

**/
%macro getReglas();
  libname FCST_STG '/sasshared/fcst_stage/';
  proc sql;
      create table temp as 
      select monotonic() as num_secuencial, 
             nombre_flujo 
      from (select distinct nombre_flujo 
            from FCST_STG.reglas_flujo)
      order by nombre_flujo;
  quit;
  proc sql;
      create table datos as
      select t2.num_secuencial as idFlujo ,t1.nombre_proceso, t1.nombre_flujo , case when t1.activo = 'yes' then 1 else 0 end as activo 
    
      from FCST_STG.reglas_flujo t1 
    inner join  temp t2 on (t1.nombre_flujo eq t2.nombre_flujo)
      order by t1.nombre_flujo, t1.nombre_proceso;
  quit;
  %MESSAGEBE(e="",outds=work.status,estado=ok);            
  %webout(OPEN);
  %webout(OBJ,datos);
  %webout(OBJ,status);
  %webout(CLOSE);
%mend;