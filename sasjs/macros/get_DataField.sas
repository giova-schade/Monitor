/**
@file
@brief <Your brief here>
<h4> SAS Macros </h4>
@li messagebe.sas
@li load1.sas
@li load2.sas
@li load3.sas
@li load4.sas
@li load5.sas
@li load6.sas
@li load7.sas
@li load8.sas
@li load9.sas
@li load10.sas
@li load11.sas
@li load12.sas
@li load13.sas
@li load14.sas
**/
%macro getDataField(name=);
	%put &name;
	libname FCST_STG '/sasshared/fcst_stage/';
	%local file name extencion urlDownload path;

	proc sql noprint;
		select file , name, extencion, urlDownload, path , funcionload into :file , :name, :extencion, :urlDownload, :path , :funcionload
			from FCST_STG.ConfCargaInput where name = &name;
	quit;

	data _null_;
		funcionload="&funcionload";
		path ="&path";
		call symput('execute', cats(funcionload,'(path=',path,')'));
	run;

	%put &file [&name] &extencion &urlDownload &path --> [&execute];

	%if %sysfunc(fileexist(&path)) %then
		%do;
			%&execute.;
		%end;
	%else
		%do;
        %MESSAGEBE(e="El archivo &path no existe ",outds=work.status,estado=nook);
        %webout(OPEN);
        %webout(OBJ,status);
        %webout(CLOSE);
		%end;
%mend;