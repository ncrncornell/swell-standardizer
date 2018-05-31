
/*** parsing_entitytype.sas Version 2.0 ***/


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

%macro parsing_entitytype(nm_in,nm_out,ent_out);
/* syntax:
        (1) existing name field
        (2) new field for non-entity part of name
        (3) new entity field
*/

/*
  In patternfile 90,
  the first column (&&pcola90) is the search column
  the secon column (&&pcolb90) is the exclusion column
*/
  __nm=&nm_in.;

  length __name __ent __n1 __n3 $&lng.;

  __name=''; __ent ='';
  __n1=''; __n3='';

  %if &sql90. GT 0 %then %do;



    %do i=1 %to &sql90.;
      __re = prxparse(&&pcola90_&i.);
      if missing(__re) then do; putlog 'ERR0R regex pattern is malformed'; putlog &&pcola90_&i.; stop; end;
      %if &&pcolb90_&i. NE  %then %do;
        __ex = prxparse(&&pcolb90_&i.);
        if missing(__ex) then do; putlog 'ERR0R regex exclude pattern is malformed'; putlog &&pcolb90_&i.; stop; end;
      %end;
      %else %do;
        __ex=0;
      %end;

      if prxmatch(__re,trim(__nm))
        %if &&pcolb90_&i. NE  %then %do;
           and not prxmatch(__ex,trim(__nm))
        %end;
      then do;
        __n1=prxposn(__re,1,trim(__nm)); __n3=prxposn(__re,3,trim(__nm));
      end;
      if __n1~="" & __name="" then __name=__n1;
      if __n3~="" & __ent="" then __ent=__n3;
    %end;
  %end;

  if __name~="" then &nm_out.=__name; else &nm_out=&nm_in.;
  if __ent~="" then &ent_out.=__ent;
  drop __: ;

%mend parsing_entitytype;

