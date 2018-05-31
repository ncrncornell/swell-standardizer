SAS program to standardize business names
============

AUTHORS
=======
Nada Wasi,
  Survey Research Center,
  Institute for Social Research,
  University of Michigan

Ann Rodgers,
  Survey Research Center,
  Institute for Social Research,
  University of Michigan

Kristin McCue,
  US Census Bureau



SUPPORT:    <anrodger@umich.edu>

DESCRIPTION
===========
This code, for SAS, provides an open-source method to standardize business names. It is the equivalent to the Stata code described in


  Wasi, Nada and Flaaen, Aaron, (2015), [Record linkage using Stata: Preprocessing, linking, and reviewing utilities](http://www.stata-journal.com/article.html?article=dm0082), <i>Stata Journal</i>, <b>15</b>, issue 3, p. 672-697.


MAIN FILES
==========

stnd_compname.sas
-----------------

stnd_compname.sas requires the following SAS macro files and pattern files installed.
The pattern files are in the subfolder "PatternFiles".

MACRO FILES
===========
-  agg_acronym.sas
-  load_patternfiles.sas
-  maxlengths.sas
-  parsing_entitytype.sas
-  parsing_namefield.sas
-  set_patdefaults.sas
-  set_patfile.sas
-  stnd_commonwrd_all.sas
-  stnd_commonwrd_name.sas
-  stnd_entitytype.sas
-  stnd_nesw.sas
-  stnd_numbers.sas
-  stnd_search_replace.sas
-  stnd_smallwords.sas
-  stnd_specialchar.sas


PATTERN FILES
-------------
-  P10_namecomp_patterns.csv
-  P21_spchar_namespecialcases.csv
-  P22_spchar_remove.csv
-  P23_spchar_rplcwithspace.csv
-  P30_std_entity.csv
-  P40_std_commonwrd_name.csv
-  P50_std_commonwrd_all.csv
-  P60_std_numbers.csv
-  P70_std_nesw.csv
-  P81_std_smallwords_all.csv
-  P90_entity_patterns.csv


SAS PROGRAM AND DATA FILES TO REPLICATE EXAMPLE IN THE PAPER
------------------------------------------------------------
-  example.sas
-  fileA.sas7bdat
-  fileB.sas7bdat
