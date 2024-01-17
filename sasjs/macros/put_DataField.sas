/**
  @file
  @brief <Your brief here>
  <h4> SAS Macros </h4>
  @li messagebe.sas
  @li put1.sas
  @li put2.sas
  @li put3.sas
  @li put4.sas
  @li put5.sas
  @li put6.sas
  @li put7.sas
  @li put8.sas
  @li put9.sas
  @li put10.sas
  @li put11.sas
  @li put12.sas
  @li put13.sas
  @li put14.sas
**/
%macro putDataField(name=);
    %put &name;
    libname FCST_STG '/sasshared/fcst_stage/';
    %local file name extencion urlDownload path;
    proc sql noprint ;
     select file , name, extencion, urlDownload, path , funcionput into :file , :name, :extencion, :urlDownload, :path , :funcionput
    from FCST_STG.ConfCargaInput where name = &name;
    quit;
    data _null_;
        funcionput="&funcionput";
        path ="&path";
        call symput('execute', cats(funcionput,'(path=',path,')'));
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