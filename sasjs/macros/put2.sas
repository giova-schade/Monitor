/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
@li messagebe.sas

**/

/*ejemplo para leer desde la web*/
%macro put2(path=);

	data datos;
		infile &_WEBIN_FILEREF dlm='|' missover dsd lrecl=32767 firstobs=2;
		length 
			Categoria $20 
			item_subclass_cd $6 
			SUBRUBRO_SAP $30 
			Item_categoria $20 
			BLOQUE $2;
		input 
			Categoria $ 
			item_subclass_cd $ 
			SUBRUBRO_SAP $ 
			Item_categoria $ 
			BLOQUE $;
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
%mend put2;