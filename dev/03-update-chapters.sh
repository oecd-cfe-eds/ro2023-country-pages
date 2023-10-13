#!/bin/bash

# for each qmd file that starts with a number:
# 1. delete from line 8
# 2. paste the contents of xx_country_template.qmd at the end of the file
# 3. replace all instances of "{r " with "{r xxx_}, with xxx = the 3 final letters of the file name

# UPDATE TL3 COUNTRIES

for file in *aut.qmd *bel.qmd *che.qmd *cze.qmd *deu.qmd *dnk.qmd *esp.qmd *est.qmd *fin.qmd *fra.qmd *gbr.qmd *grc.qmd *hun.qmd *ita.qmd *jpn.qmd *kor.qmd *ltu.qmd *lva.qmd *nld.qmd *nor.qmd *nzl.qmd *pol.qmd *prt.qmd *svn.qmd *svk.qmd *swe.qmd *tur.qmd
do
    echo $file
    sed -i '8,$d' $file
    sed -i '7r 00_country_template_tl3.qmd' $file
    sed -i 's/{r /{r '${file: -7:3}'_/g' $file

    # replace all ${file: -7:3}_${file: -7:3} with ${file: -7:3}_
    # yes, I know this is a bad trick, but it works
    sed -i 's/'${file: -7:3}'_'${file: -7:3}_'/'${file: -7:3}'_/g' $file
    sed -i 's/'${file: -7:3}'_'${file: -7:3}_'/'${file: -7:3}'_/g' $file
    sed -i 's/'${file: -7:3}'_'${file: -7:3}_'/'${file: -7:3}'_/g' $file
done

# replace all ", TL3 OECD regions" with ",\\nTL3 OECD regions"
sed -i 's/", TL3 OECD regions/",\\nTL3 OECD regions/g' *qmd