
*** stnd_numbers.sas Version 2.0 ***;


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

%macro stnd_numbers(nm_in,nm_out);
/* syntax:
        (1) name of variable to standardize
        (2) output variable name
*/
  %let calling=&SYSMACRONAME.;
  %stnd_search_replace(&nm_in.,&nm_out.,fullword,&calling.);

%mend stnd_numbers;


