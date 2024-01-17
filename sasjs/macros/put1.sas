/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
@li messagebe.sas
**/

/*ejemplo para leer desde la web*/
%macro put1(path=);

	data datos;
		infile &_WEBIN_FILEREF dlm='|' missover dsd lrecl=32767 firstobs=2;
		length
			Item_Id $20
			CATEGORIA1_ID $20
			CATEGORIA1_NIVEL_1 $50
			CATEGORIA1_NIVEL_2 $50
			CATEGORIA1_NIVEL_3 $50
			CATEGORIA1_NIVEL_4 $50
			CATEGORIA1_NIVEL_5 $50;
		input
			Item_Id
			CATEGORIA1_ID
			CATEGORIA1_NIVEL_1
			CATEGORIA1_NIVEL_2
			CATEGORIA1_NIVEL_3
			CATEGORIA1_NIVEL_4
			CATEGORIA1_NIVEL_5;
	run;
 /*comienzo validaciones */
	proc sql noprint;
		select count(*) into :totalDatos from datos;
	quit;

	%let error=0;

	%if &totalDatos eq  0 %then
		%do;
			%let error=1;
      %let mssg=Revisar errores:1;
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
%mend put1;