
/*** stnd_specialchar.sas Version 2.0 ***/


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

%macro stnd_specialchar(nm_in,nm_out,typ);
/* syntax:
        (1) name of variable needing special chars removed
        (2) output variable name without special chars
        (3) if typ is 'name', then use pattern file 21, otherwise, don't
*/

  length __nm $&lng.;

  %if &sql21.=0 and &sql22.=0 and &sql23.=0 %then %do;
     __nm='';
  %end;
  %else %do;
     __nm=strip(compbl(&nm_in.));
     __nm=compress(__nm,"%str(%")");    *** remove double quote ***;
     %if %upcase("&typ")="NAME" %then %do; *** handle special firm name cases ***;
       %if &sql21. ne 0 %then %do j=1 %to &sql21.; __nm=transtrn(__nm,"&&pcola21_&j.","&&pcolb21_&j."); %end;
     %end;
     __nm=tranwrd(__nm,"&"," & ");      *** surround & with spaces ***;

     %if &sql22. ne 0 %then %do k=1 %to &sql22.; __nm=compress(__nm,"&&pcola22_&k."); %end;
     %if &sql23. ne 0 %then %do m=1 %to &sql23.; __nm=translate(__nm," ","%str(&&pcola23_&m.)"); %end;

     *** SAS doesn,t read period correctly from parameter file so handle here ***;
     __nm=translate(__nm," ","%str(.)");
     __nm=strip(compbl(__nm));

  %end;

  if __nm~="" then &nm_out.=__nm; else &nm_out=&nm_in.;
  drop __: ;

%mend;


