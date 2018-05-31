
/*** set_patfile.sas Version 2.0 ***/


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

%macro set_patfile(patfile);
  %global fullfile;

  /* Set some defaults */
  %if %symexist(theme)=0 %then %let theme=public;
  %else %if &theme.= %then  %let theme=public;

  /* Create the fully-qualified file name for the pattern file */
  %if &sysscp eq WIN %then %let slash = \;  /* get the appropriate slash */
  %else %let slash = /;
  %let fullfile=%sysfunc(catx(&slash,&pattern_path.,theme,&theme.,&patfile));

  /* Make sure the file existis. If it does, then just return the fully-qualified
    file name. If not, print some war ning messages in the
    log, and return a string indicating that to the calling macro.
    The calling macro should check the returned filename. If it is equal
    to NOFILE, then the macro should return. */
  %if %sysfunc(fileexist(&fullfile.)) %then %do; "&fullfile" %end;
  %else %do;
    %put %sysfunc(cats(WAR,NING: FILE "&fullfile." does not exist));
    NOFILE
  %end;
%mend set_patfile;