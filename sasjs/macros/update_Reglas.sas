/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
@li messagebe.sas

**/
%macro updateReglas(NombreProceso=,NombreRegla=,NuevoEstado=);
	libname FCST_STG '/sasshared/fcst_stage/';

	proc sql;
		update FCST_STG.reglas_flujo
			set ACTIVO = 
				case 
					when 0 = 1 then 'yes' 
					else 'no' 
				end
			where nombre_flujo = "&NombreProceso" and nombre_proceso = "&NombreRegla";
	quit;

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
			select t2.num_secuencial as idFlujo ,t1.nombre_proceso, t1.nombre_flujo , 
				case 
					when t1.activo = 'yes' then 1 
					else 0 
				end 
			as activo 
				from FCST_STG.reglas_flujo t1 
					inner join  temp t2 on (t1.nombre_flujo eq t2.nombre_flujo)
						order by t1.nombre_flujo, t1.nombre_proceso;
	quit;

	%MESSAGEBE(e="",outds=work.status,estado=ok);
	%webout(OPEN);
	%webout(OBJ,status);
	%webout(OBJ,datos);
	%webout(CLOSE);
%mend;