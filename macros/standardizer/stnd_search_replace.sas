
*** stnd_search_replace.sas Version 2.0 ***;


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

%macro stnd_search_replace(nm_in,nm_out,srchtype,callingMacro,patnum);
/* syntax:
        (1) name of variable to standardize
        (2) output variable name
        (3) type of search - fullstring (entire string matches) or fullword(anywhere in string, full words only)
        (4) call macro name. This is used to find the correct pattern file macro variables
        (5) patternfile number (optional). Allows user to specify a certain patternfile number that may
            differ from the default for this calling macro
*/

  %if "&patnum." EQ "" %then %do;
    %if &callingMacro=STND_ENTITYTYPE %then %let patnum=30;
    %else %if &callingMacro=STND_COMMONWRD_NAME %then %let patnum=40;
    %else %if &callingMacro=STND_COMMONWRD_ALL %then %let patnum=50;
    %else %if &callingMacro=STND_NUMBERS %then %let patnum=60;
    %else %if &callingMacro=STND_NESW %then %let patnum=70;
    %else %if &callingMacro=STND_SMALLWORDS %then %let patnum=81;
    %else %if &callingMacro=STND_STREETTYPE %then %let patnum=110;
    %else %if &callingMacro=STND_COMMONWRD_CITY %then %let patnum=140;
   %end;


  length __nm $&lng.;
  __nm=strip(compbl(&nm_in.));

  %if &&sql&patnum. NE 0 %then %do;
    %do i=1 %to &&sql&patnum. ;
      %if (%upcase("&srchtype.") EQ "FULLWORD") %then %do;
        %if %symexist(stn_fw_ex&patnum._1) %then __re_a = prxparse(&&stn_fw_ex&patnum._&i.);
        %else  __re_a = prxparse(&&stn_fw&patnum._&i.);
      ;
      %end;
      %else %if (%upcase("&srchtype.") EQ "FULLSTRING") %then __re_a = prxparse(&&stn_fs&patnum._&i.);
      ;

      if missing(__re_a) then do; putlog "ERR0R: regex is malformed"; stop; end;

      if prxmatch(__re_a,trim(__nm)) then do;
         __nm=strip(compbl(prxchange(__re_a,-1,trim(__nm))));
      end;

    %end;
  %end;

  if __nm~="" then &nm_out.=__nm; else &nm_out=&nm_in.;
  drop __: ;

%mend stnd_search_replace;


