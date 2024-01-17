/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li messagebe.sas

**/
/*ejemplo para leer desde la web*/

%macro put6(path=);

	data datos;
		infile "&path" dlm='|' missover dsd lrecl=32767;
		length Local $10;
		input Local $;
	run;
 /*comienzo validaciones */
	proc sql noprint;
		select count(*) into :totalDatos from datos;
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
    %mend put6;