
/*** set_patdefaults.sas Version 2.0 ***/


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

%macro set_patdefaults;

  %if %symexist(P10)=0 %then %do;
    %global P10;
    %let P10=P10_namecomp_patterns.csv;
  %end;
  %if %symexist(P21)=0 %then %do;
    %global P21;
    %let P21=P21_spchar_namespecialcases.csv;
  %end;
  %if %symexist(P22)=0 %then %do;
    %global P22;
     %let P22=P22_spchar_remove.csv;
  %end;
  %if %symexist(P23)=0 %then %do;
    %global P23;
     %let P23=P23_spchar_rplcwithspace.csv;
  %end;
  %if %symexist(P30)=0 %then %do;
    %global P30;
     %let P30=P30_std_entity.csv;
  %end;
  %if %symexist(P40)=0 %then %do;
    %global P40;
     %let P40=P40_std_commonwrd_name.csv;
  %end;
  %if %symexist(P50)=0 %then %do;
    %global P50;
     %let P50=P50_std_commonwrd_all.csv;
  %end;
  %if %symexist(P60)=0 %then %do;
    %global P60;
     %let P60=P60_std_numbers.csv;
  %end;
  %if %symexist(P70)=0 %then %do;
    %global P70;
     %let P70=P70_std_NESW.csv;
  %end;
  %if %symexist(P81)=0 %then %do;
    %global P81;
     %let P81=P81_std_smallwords_all.csv;
  %end;
  %if %symexist(P82)=0 %then %do;
    %global P82;
     %let P82=P82_std_smallwords_address.csv;
  %end;
  %if %symexist(P90)=0 %then %do;
    %global P90;
     %let P90=P90_entity_patterns.csv;
  %end;
  %if %symexist(P110)=0 %then %do;
    %global P110;
     %let P110=P110_std_streettypes.csv;
  %end;
  %if %symexist(P120)=0 %then %do;
    %global P120;
     %let P120=P120_pobox_patterns.csv;
  %end;
  %if %symexist(P130)=0 %then %do;
    %global P130;
     %let P130=P130_secondaryadd_patterns.csv;
  %end;
  %if %symexist(P140)=0 %then %do;
    %global P140;
     %let P140=P140_std_commonwrd_city.csv;
  %end;
  %if %symexist(P150)=0 %then %do;
    %global P150;
     %let P150=P150_city_fullnames.csv;
  %end;

%mend set_patdefaults;