/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
  @li messagebe.sas

**/
%macro load2(path=);

	data datos;
		infile "&path" dlm='|' missover dsd lrecl=32767;
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

	/* these macros open the JSON, send the table back, and close the JSON */
	%MESSAGEBE(e="",outds=work.status,estado=ok);
	%webout(OPEN);
	%webout(OBJ,datos);
	%webout(OBJ,status);
	%webout(CLOSE);
%mend load2;