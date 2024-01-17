/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
@li messagebe.sas

**/
%macro getMonitor(tabla=,id_proceso=);
	%if %length(&id_proceso) ne 0 %then
		%do;
			libname FCST_STG '/sasshared/fcst_stage/';

			proc sql noprint;
				select count(*) into :total from FCST_STG.&tabla. where id_proceso = "&id_proceso";
			quit;

			%if &total ne 0 %then
				%do;

					proc sql ;
						create table datos as select * from FCST_STG.&tabla where id_proceso = "&id_proceso";
					quit;

					%MESSAGEBE(e="",outds=work.status,estado=ok);
					%webout(OPEN);
					%webout(OBJ,datos);
					%webout(OBJ,status);
					%webout(CLOSE);
				%end;
			%else
				%do;
					%webout(OPEN);
					%MESSAGEBE(e="No Hay datos ",outds=work.status,estado=nook);
					%webout(OBJ,status);
					%webout(CLOSE);
				%end;
		%end;
	%else
		%do;
			libname FCST_STG '/sasshared/fcst_stage/';

			proc sql noprint;
				select count(*) into :total from FCST_STG.&tabla. ;
			quit;

			%if &total ne 0 %then
				%do;

					proc sql outobs=20;
						create table datos as select * from FCST_STG.&tabla;
					quit;

					%MESSAGEBE(e="",outds=work.status,estado=ok);
					%webout(OPEN);
					%webout(OBJ,datos);
					%webout(OBJ,status);
					%webout(CLOSE);
				%end;
			%else
				%do;
					%webout(OPEN);
					%MESSAGEBE(e="No Hay datos ",outds=work.status,estado=nook);
					%webout(OBJ,status);
					%webout(CLOSE);
				%end;
		%end;
%mend;