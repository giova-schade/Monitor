/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
  @li messagebe.sas

**/
%macro load3(path=);

    libname myxls xlsx "&path.";

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

	/* Iniciar el bucle para procesar cada hoja */
	/* these macros open the JSON, send the table back, and close the JSON */
	%MESSAGEBE(e="",outds=work.status,estado=ok);
	%webout(OPEN);

	%do %while(&cnt <= &total);
		%let hoja_actual = %scan(%quote(&hojas_separadas), &cnt, %str(,));
		%put Procesando: &hoja_actual.;

		proc import datafile="&path."
			out=datos&cnt.
			dbms=xlsx
			replace;
			sheet="&hoja_actual."; /* Asegúrate de que el nombre de la hoja sea exactamente el mismo que en el archivo Excel. */
			getnames=yes; /* Suponiendo que la primera fila contiene los nombres de las columnas */
		run;

		%webout(OBJ,datos&cnt.);

		/* Aquí va el código que deseas ejecutar para cada elemento de la lista */
		%let cnt = %eval(&cnt + 1);
	%end;

	%webout(OBJ,status);
	%webout(CLOSE);
%mend load3;