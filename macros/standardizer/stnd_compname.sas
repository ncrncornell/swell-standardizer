
/*** stnd_compname.sas Version 2.0 ***/


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

%macro stnd_compname(in_ds,out_ds,name,nm,dba,fka,attn,ent,dbaent);
/* syntax:
  (1) name of dataset with var to be standardized
  (2) name of dataset to be created with standardized fields added
  (3) name of variable to standardize
  (4)-(11) list of 8 output variable names:
    (4) standardized name with entity info removed
    (5) doing-business-as, traded-as ...name
    (6) fka=formerly known as ... (optional)
    (7) attn=mailing name (usually a person) (optional)
    (8) entity type (optional)
    (9) entity type for the DBA part of the name (optional)

*/

  %local v nv vlst;

  %set_patdefaults;

  proc contents data=&in_ds. noprint out=_contents(keep=name length where=(UPPER(name)=UPPER("&name."))); run;
  proc sql &sqlopt.; select max(length*2,256) into :lng from _contents; quit;
  
  %let calling=&SYSMACRONAME.;
  %load_patternfiles(callingMacro=&calling.);

  data __temp;
    length _emp $&lng.;
    set &in_ds.;
    _emp=upcase(compbl(trim(&name.)));


    /* needed for agg_acronym, but cannot be created there since it is called multiple times, and there does not seem to be a way to un-declare an array */
    array __w_arr[40] $&lng.;
    array __sep[39] $1.;


    /*input = infile, outfile, existing namefield, output = {name removing other components, dba_name, fka_name, attn_name},pattern file name (optional) */
    %parsing_namefield(_emp,_emp,_dba_name,_fka_name,_attn_name);

    %let vlst=emp dba_name fka_name;
    %let v=1;
    %do %until ("%scan(&vlst,&v)"="");

      %let nv=%scan(&vlst,&v);
      /*input = infile, outfile, existing namefield, output name field ,excl (not currently using but in Nada,s program)
          , type (=name or blank)  */
      %stnd_specialchar(_&nv.,_&nv.,name);

      %stnd_entitytype(_&nv.,_&nv.);

      %stnd_commonwrd_name(_&nv.,_&nv.);
      %stnd_commonwrd_all(_&nv.,_&nv.);
      %stnd_numbers(_&nv.,_&nv.);
      %stnd_NESW(_&nv.,_&nv.);
      %stnd_smallwords(_&nv.,_&nv.,81);

      %if ("&nv." = "emp") %then %do;
        /*input = infile, outfile, existing name, new namefield without entity info,entity field  */
        %parsing_entitytype(_emp,_emp,_entity);
        /* Squeeze the air out of the name */
        %agg_acronym(_entity,_entity);
      %end;

      %else %if ("&nv." = "dba_name") %then %do;
        /* parse out any entity types associated with the DBA field  */
        %parsing_entitytype(_dba_name,_dba_name,_dba_entity);
        /* Squeeze the air out of the entity names */
        %agg_acronym(_dba_entity,_dba_entity);
      %end;

      %agg_acronym(_&nv.,_&nv.);

      %let v=%eval(&v+1);
    %end;

  run;

  /* Shrink the output variable down to the minimum necessary */
  %maxlengths(libin=work, datain=__temp, vars=_emp _dba_name _fka_name _attn_name _entity _dba_entity);

  data &out_ds;
    set __temp;
    %if %quote(&nm.) ne %then %do;
      length &nm. $&max_emp;
      &nm=_emp;;
    %end;
    %if %quote(&dba.) ne %then %do;
      length &dba. $&max_dba_name;
      &dba=_dba_name;;
    %end;
    %if %quote(&fka.) ne %then %do;
      length &fka. $&max_fka_name;
      &fka=_fka_name;;
        %end;
    %if %quote(&attn.) ne %then %do;
      length &attn. $&max_attn_name;
      &attn=_attn_name;;
    %end;
    %if %quote(&ent.) ne %then %do;
      length &ent. $&max_entity;
      &ent=_entity;;
    %end;
    %if %quote(&dbaent.) ne %then %do;
      length &dbaent. $&max_dba_entity;
      &dbaent=_dba_entity;;
    %end;
    drop _: ;
  run;


  proc datasets library=work nolist; delete _:; quit;

%mend stnd_compname;

