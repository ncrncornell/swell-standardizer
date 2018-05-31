
/*** maxlengths.sas Version 2.0 ***/


/*********************************************************************************

Copyright 2016 Nada Wasi, Ann Rodgers, Kristin McCue

This file is part of %stnd_compname.

    %stnd_compname is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    %stnd_compname is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with %stnd_compname.  If not, see <http://www.gnu.org/licenses/>.

Contact information

Ann Rodgers
anrodger@umich.edu
University of Michigan
Institute for Social Research
426 Thompson Street
Ann Arbor, MI  48104-1248

*********************************************************************************/

%macro maxlengths(libin=SASHELP
                    ,datain=CLASS
                    ,vars=
                    );


    proc sql noprint;
      select name into :charvar1 - :charvar9999
        from   dictionary.columns
        where  libname=upcase("&LIBIN")
        and    memname=upcase("&DATAIN")
        and    type='char'
        and    findw(UPPER("&vars."), STRIP(UPPER(name))) ne 0
  ;
    quit;
    %let numvars=&SQLOBS;

    %if &NUMVARS > 0 %then %do;
      proc sql noprint;
        create table maxlengths as
        select
          max(length(&CHARVAR1)) as max&CHARVAR1
            %if &NUMVARS > 1 %then %do;
              %do i=2 %to &NUMVARS;
          , max(length(&&CHARVAR&i)) as max&&CHARVAR&i
              %end;
            %end;
        from &LIBIN..&DATAIN
        ;
      quit;


      data _NULL_;
      set maxlengths;
        %do  i=1 %to &NUMVARS;
          %global max&&CHARVAR&i;
          call symput("max&&CHARVAR&i",max&&CHARVAR&i);
        %end;
      run;

    %end;

  %mend maxlengths;