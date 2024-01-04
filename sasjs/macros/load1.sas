/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
  @li messagebe.sas

**/
%macro load1(path=);

	data datos;
		infile "&path" dlm='|' missover dsd lrecl=32767;
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

	/* these macros open the JSON, send the table back, and close the JSON */
	%MESSAGEBE(e="",outds=work.status,estado=ok);
	%webout(OPEN);
	%webout(OBJ,datos);
	%webout(OBJ,status);
	%webout(CLOSE);
%mend;