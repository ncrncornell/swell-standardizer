
/*** agg_acronym.sas Version 2.0 ***/


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

%macro agg_acronym(nm_in,nm_out);
/* syntax:
        (1) name of variable to standardize
        (2) output variable name
*/

  length __nm  __nmout $&lng.;
  __nm=&nm_in;
  __nm=strip(compbl(__nm));

  %do i=1 %to &sql01. ;


    __re_a = prxparse("&&pcola01_&i."); if missing(__re_a) then do; putlog "ERR0R: alone regex is malformed"; stop; end;

    __sp="|";

    __start=1;
    call prxnext(__re_a,__start,-1,__nm,__position,__length);
    if __length > 0 then __w_arr1 = substr(__nm, __position, __length);

    __nmout="";
    __j=2;
    do while (__position > 0);
      call prxnext(__re_a,__start,-1,__nm,__position,__length);
      if __length > 0 then __w_arr[__j] = substr(__nm, __position, __length);

      * If this space has a single character before and after it, remove the space;
      if length(__w_arr[__j-1])=1 and length(__w_arr[__j])=1 then __sep[__j-1]=""; else __sep[__j-1]=__sp;

      * However, if the single character before or after this space is an &, then leave the space there;
      if __w_arr[__j-1]='&' or __w_arr[__j]='&' then __sep[__j-1]=__sp;
      __nmout=cat(strip(__nmout),strip(__w_arr[__j-1]),strip(__sep[__j-1]));
      __j=__j+1;
    end;

    __nm=translate(__nmout," ","|");

  %end;

  if __nm~="" then &nm_out.=__nm; else &nm_out=&nm_in.;
  drop __: ;

%mend;


