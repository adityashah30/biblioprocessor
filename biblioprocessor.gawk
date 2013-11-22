#!/usr/bin/awk -f

#   Copyright (c) 2012 Ramprasad Joshi

#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.

#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.

#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

#
#
# ************ Instructions: ***********
# Generate a report of all accession records, say "report.txt"

# To generate this, you need to run the lib software and choose the appropriate report that has entries listed as follows:

#                B/                        025.431 MIT/Dew-I
# Title    : Dewey Decimal Classification and relative index.
#            Vol 1.
# Author   : Mitchell, J.S., Ed.
# Edition  : 22
# Publ.Plc : Ohio
# Publ.    : Online Computer Library Center
# Publ Dt  : 2003
# Pages    : lxxvii, 731
# ISBN     : 0-910608-70-9
# Class No : 025.431 MIT/Dew-I
# Keywords : Library Classification
# Accn Nos : 1

# Then run this program as follows: First made it executable: In a shell, working directory where this is located, issue: $ chmod a+x first.gawk
# Then run it: $ ./first.gawk report.txt > tabreport.txt
# Your tab-separated column-wise organized catalogue database is in tabreport.txt now. Its columns (fields) are in the following order:
# title,  subtitle,  series, author,  edition,  place,  publisher,  pubdate,  pages,  isbn,  callno,  accno;

BEGIN       {
            recno = 0;
            title= "Title"; subtitle = "Subtitle"; series="Series"; author= "Authors"; edition= "Edition";
            place= "Place"; publisher= "Publisher"; pubdate= "Publ.Date"; pages= "Pages";
            isbn= "ISBN"; callno= "CallNo"; accno = "AccessionNos"; category = "Category";
            recnotprinted = 0;
            }
/-----------------------/   { }
/TITLES BY ACCESSION NO./   { }
/Title/     { title = ""; for(fn = 3; fn <= NF; fn++) title = title " " $fn; currfield = "title"; recnotprinted = 1; }
/Subtitle/  { subtitle = ""; for(fn = 3; fn <= NF; fn++) subtitle = subtitle " " $fn; currfield = "subtitle"; }
/Class No/  { callno = ""; for(fn = 4; fn <= NF; fn++) callno = callno " " $fn; currfield = "callno"; }
/Accn Nos/  { accno = ""; for(fn = 4; fn <= NF; fn++) accno = accno " " $fn; currfield = "accno"; }
/Publ.Plc/  { place = ""; for(fn = 3; fn <= NF; fn++) place = place " " $fn; currfield = "place"; }
/Publ.  / { publisher = ""; for(fn = 3; fn <= NF; fn++) publisher = publisher " " $fn; currfield = "publisher"; }
/Publ Dt/ { pubdate = ""; pubdate = $4; currfield = "pubdate"; } 
/Pages/ { pages = ""; pages = $3; currfield = "pages"; }
/ISBN/ { isbn = ""; isbn = $3; currfield = "isbn"; }
/Author/ { author = ""; for( fn = 3; fn <= NF; fn++) author = author " " $fn; currfield = "author"; }
/Edition/ { edition = ""; edition = $3; currfield = "edition"; }
/Ser Note/ { series = ""; for(fn = 3; fn <= NF; fn++) series = series " " $fn; currfield = "series"; }
/^$/        { currfield = ""; }
/^[ \t]/    {
            if(currfield == "")
                {
                if(recnotprinted == 1)
                    {
                    print recno "\t" category "\t" title "\t" subtitle "\t" series "\t" author "\t" edition "\t" place "\t" publisher "\t" pubdate "\t" pages "\t" isbn "\t" callno "\t" accno;
                    recnotprinted = 0;
                    if(topcallno != callno) print FNR " : " recno " Error: mismatched callnos: " topcallno " <--> " callno > "/dev/stderr";
                    recno++;
                    }
                category = $1; topcallno = ""; for (fn = 2; fn <= NF; fn++) topcallno = topcallno " " $fn;
                subtitle = "-"; series="-"; author= "-"; edition= "-";
                place= "-"; publisher= "-"; pubdate= "-"; pages= "-";
                isbn= "-"; callno= "-"; accno = "-";
                }
            else if(currfield == "title") { for(fn = 1; fn <= NF; fn++) title = title " " $fn; }
            else if(currfield == "subtitle") { for(fn = 1; fn <= NF; fn++) subtitle = subtitle " " $fn; }
            else if(currfield == "callno") { for(fn = 1; fn <= NF; fn++) callno = callno " " $fn; }
            else if(currfield == "accno") { for(fn = 1; fn <= NF; fn++) accno = accno " " $fn; }
            else if(currfield == "place") { for(fn = 1; fn <= NF; fn++) place = place " " $fn; }
            else if(currfield == "publisher") { for(fn = 1; fn <= NF; fn++) publisher = publisher " " $fn; }
            else if(currfield == "pubdate") { for(fn = 1; fn <= NF; fn++) pubdate = pubdate " " $fn; }
            else if(currfield == "pages") { for(fn = 1; fn <= NF; fn++) pages = pages " " $fn; }
            else if(currfield == "isbn") { for(fn = 1; fn <= NF; fn++) isbn = isbn " " $fn; }
            else if(currfield == "author") { for(fn = 1; fn <= NF; fn++) author = author " " $fn; }
            else if(currfield == "edition") { for(fn = 1; fn <= NF; fn++) edition = edition " " $fn; }
            else if(currfield == "series") { for(fn = 1; fn <= NF; fn++) series = series " " $fn; }
            else print "ERROR! BLANK Line! " $0;
            }
