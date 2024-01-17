/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
   @li messagebe.sas

**/
/*ejemplo para leer desde la web*/

%macro put11(path=);

  %let FILExlsx=%sysfunc(pathname(&_WEBIN_FILEREF));
	libname myxls xlsx "&FILExlsx.";

	proc datasets library=myxls;
		contents data=_all_ out=work.hojas(keep=memname) noprint;
	run;

	proc sql noprint;
		create table work.unique_hojas as
			select distinct memname
				from work.hojas;
	quit;

	/* Crear una lista separada por comas de los nombres de las hojas */
	proc sql noprint;
		select distinct memname into :hojas_separadas separated by ','
			from work.unique_hojas;
	quit;

	%put &hojas_separadas;

	/* Recorrer la lista de nombres de hojas */
	%let cnt = 1;
	%let total = %sysfunc(countw(%quote(&hojas_separadas), %str(,)));

	%do %while(&cnt <= &total);
		%let hoja_actual = %scan(%quote(&hojas_separadas), &cnt, %str(,));
		%put Procesando: &hoja_actual.;

		proc import datafile="&path."
			out=datos&cnt.
			dbms=xlsx
			replace;
			sheet="&hoja_actual.";
			getnames=yes;
		run;
		%let cnt = %eval(&cnt + 1);
	%end;

	/*comienzo validaciones */
	proc sql noprint;
		select count(*) into :totalDatos from datos1;
	quit;

	%let error=0;

	%if &totalDatos eq  0 %then
		%do;
			%let error=1;
			%let mssg=no hay datos en el archivo;
		%end;

	/*Termino validaciones */
	/*cuando hay algun error*/
	%if &error eq  0 %then
		%do;
			%let FILE=%sysfunc(pathname(&_WEBIN_FILEREF));
			%put muevo hacia &path desde &FILE;
			Filename filelist pipe "cp &FILE &path";

			Data _null_;
				Infile filelist truncover;
				Input filename $100.;
				Put filename=;
			Run;

			%MESSAGEBE(e="",outds=work.status,estado=ok);
			%webout(OPEN);
			%webout(OBJ,status);
			%webout(CLOSE);
		%End;
	%else
		%do;
			%let FILE=%sysfunc(pathname(&_WEBIN_FILEREF));
			%put muevo hacia &path desde &FILE;
			Filename filelist pipe "cp &FILE &path";

			Data _null_;
				Infile filelist truncover;
				Input filename $100.;
				Put filename=;
			Run;

			%MESSAGEBE(e="&mssg",outds=work.status,estado=nook);
			%webout(OPEN);
			%webout(OBJ,status);
			%webout(CLOSE);
		%end;
    %mend put11;