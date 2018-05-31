
/*** load_patternfiles.sas Version 2.0 ***/


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

%macro load_patternfiles(callingMacro=);

  /* Macro to globalize macro variables we create in this macro */
  %macro globuild(pref,start,finish);
    %do i = &start. %to &finish.;
      &pref._&i
    %end;
  %mend;

*************************PATTERNS FOR PHRASES WITH PUNCTUATION THAT IS NEEDED TO IDENTIFY THEM **************************************;
%macro loadpat(patnum=,numvars=,delim=%str(,));
  %global sql&patnum.;
  %let mypattern=%set_patfile(&&p&patnum.);

  %if &mypattern=NOFILE %then %do;
    %let sql&patnum.=0;
  %end;
  %else %do;
    proc import datafile=&mypattern.
        out=ptrn_ds replace dbms=dlm;
        getnames=no; delimiter="&delim."; guessingrows=10000;
    run;

    /* Special search and replace strings for stnd_search_replace macro:
        stn_fw_ex=full word with exclusions; stn_fw=full word without exclusions; stn_fs=full string */
    data ptrn_ds;
      set ptrn_ds;
      length patcola $100.;
      patcola=strip(compbl(translate(var1,'','0D'x)));

      %if (&patnum. EQ 10) %then patcola='"/(.*)([ ])('||compbl(trim(transtrn(patcola,"/","\/")))||')([ ])(.*)/"';;
      %if (&patnum. EQ 90) %then patcola=compbl(trim(cats("'/",compbl(trim(translate(patcola,'','0D'x))),"$/'")));;
      %if (&patnum. EQ 120) or (&patnum. EQ 130) %then patcola="'/(.*)\b("||strip(compbl(patcola))||")\b(.*)/'";;

      %if %eval(&numvars.) GE 2 %then %do;
        length patcolb stn_fw stn_fs $100.;
        patcolb=strip(compbl(translate(var2,'','0D'x)));
        %if (&patnum. EQ 90) %then if not missing(patcolb) then patcolb=compbl(trim(cats("'/",compbl(trim(patcolb)),"\b/'")));;
        stn_fw=compbl(trim(cats("'s/\b",patcola,"\b/",patcolb,"/'")));
        stn_fs=compbl(trim(cats("'s/^",patcola,"$/",patcolb,"/'")));
      %end;
      %if %eval(&numvars.) GE 3 %then %do;
        length patcolc stn_fw_ex $100.;
        patcolc=strip(compbl(translate(var3,'','0D'x)));
        stn_fw_ex=compbl(trim(cats("'s/(?!",patcolc,")\b",patcola,"\b/",patcolb,"/'")));
        %if (&patnum. EQ 150) %then stn_fs=compbl(trim(cats("'s/^",patcola,"$/",patcolc,"/'")));;
      %end;

      if patcola NE "" then output;
    run;

    %global %globuild(pcola&patnum.,1,999);
    /* Put those perl regular expressions into macro variables for use in individual macro calls */
    proc sql &sqlopt.;
      select patcola into :pcola&patnum._1 - :pcola&patnum._999 from ptrn_ds;
    quit;
    %let sql&patnum.=&sqlobs.;


    %if %eval(&numvars.) GE 2 %then %do;
      %global %globuild(pcolb&patnum.,1,999);
      %global %globuild(stn_fw&patnum.,1,999);
      %global %globuild(stn_fs&patnum.,1,999);
      proc sql &sqlopt.;
        select patcolb into :pcolb&patnum._1 - :pcolb&patnum._999 from ptrn_ds;
        select stn_fw into :stn_fw&patnum._1 - :stn_fw&patnum._999 NOTRIM from ptrn_ds;
        select stn_fs into :stn_fs&patnum._1 - :stn_fs&patnum._999 NOTRIM from ptrn_ds;
      quit;
    %end;

    %if %eval(&numvars.) GE 3 %then %do;
      %global %globuild(pcolc&patnum.,1,999);
      %global %globuild(stn_fw_ex&patnum.,1,999);
      proc sql &sqlopt.;
        select patcolc into :pcolc&patnum._1 - :pcolc&patnum._999 from ptrn_ds;
        select stn_fw_ex into :stn_fw_ex&patnum._1 - :stn_fw_ex&patnum._999 NOTRIM from ptrn_ds;
      quit;

    %end;

  %end;
%mend;


/* All three main macros (stnd_compname, stnd_address, and stnd_cityname) need these patternfiles */
%loadpat(patnum=21,numvars=2);
%loadpat(patnum=22,numvars=1);
%loadpat(patnum=23,numvars=1,delim=%str(!));
%loadpat(patnum=50,numvars=2);
%loadpat(patnum=70,numvars=2);

%if &callingMacro.=STND_COMPNAME %then %do;
  %loadpat(patnum=10,numvars=2);
  %loadpat(patnum=30,numvars=2);
  %loadpat(patnum=40,numvars=2);
  %loadpat(patnum=60,numvars=2);
  %loadpat(patnum=81,numvars=2);
  %loadpat(patnum=90,numvars=2);

  /*
  There is no pattern file for agg_acronym. Here we create the
  macro variables that are the search patterns for agg_acronym.
  */

  %let patnum=01;
  %global sql&patnum.;
  data ptrn_ds;
    length patcola $120;
    patcola=strip(compbl("'(([\S]+)([\s])*)'"));
  run;

  %global %globuild(pcola&patnum.,1,999);
  proc sql &sqlopt.;
    select patcola into :pcola&patnum._1 - :pcola&patnum._999 from ptrn_ds;
  quit;
  %let sql&patnum.=&sqlobs.;

%end;

%else %if &callingMacro.=STND_ADDRESS %then %do;
  %loadpat(patnum=60,numvars=2);
  %loadpat(patnum=81,numvars=2);
  %loadpat(patnum=82,numvars=2);
  %loadpat(patnum=110,numvars=2);
  %loadpat(patnum=120,numvars=1);
  %loadpat(patnum=130,numvars=3);
%end;

%else %if &callingMacro.=STND_CITYNAME %then %do;
  %loadpat(patnum=140,numvars=2);
  %loadpat(patnum=150,numvars=3);
%end;

%mend load_patternfiles;

