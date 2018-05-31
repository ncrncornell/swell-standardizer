
/*** parsing_namefield.sas Version 2.0 ***/


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

%macro parsing_namefield(nm_in,nm_out,nmdba,nmfka,nmattn);
/* syntax:

        (1) name of original variable to standardize
        (2) standardized employer name
        (3)-(5) list of output variable names:
           (3) dba name
           (4) fka name
           (5) c/o or attn name

*/
  length __nm $&lng.;
  __nm=&nm_in.;
  length __n1 __n5_dba __n5_fka __n5_attn $&lng.;
  __n5_dba=""; __n5_fka=""; __n5_attn="";

  %if &sql10. GT 0 %then %do;


    %do i=1 %to &sql10.;

      __re = prxparse(&&pcola10_&i.);
      if missing(__re) then do; putlog 'ERR0R regex is malformed'; stop; end;

      if prxmatch(__re,trim(__nm)) then do;
        if __n1="" then __n1=prxposn(__re,1,trim(__nm));
        %if &&pcolb10_&i.=DBA %then %do; if __n5_dba="" then __n5_dba=prxposn(__re,5,trim(__nm)); %end;
        %if &&pcolb10_&i.=FKA %then %do; if __n5_fka="" then __n5_fka=prxposn(__re,5,trim(__nm)); %end;
        %if &&pcolb10_&i.=ATTN %then %do; if __n5_attn="" then __n5_attn=prxposn(__re,5,trim(__nm)); %end;
      end;
    %end;
  %end;

  __n1=compbl(trim(__n1));
  if __n1~="" then &nm_out.=__n1; else &nm_out=&nm_in.;
  %if %quote(&nmdba.) ne %then &nmdba=compbl(trim(__n5_dba));;
  %if %quote(&nmfka.) ne %then &nmfka=compbl(trim(__n5_fka));;
  %if %quote(&nmattn.) ne %then &nmattn=compbl(trim(__n5_attn));;
  drop __: ;

%mend parsing_namefield;

