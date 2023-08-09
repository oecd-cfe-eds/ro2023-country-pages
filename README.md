# countryprofiles4

instructions

1. install the oecdcountryprofiles pkg

from rstudio
1.1. open project -> build -> install
1.2. open project -> devtools::install()
you do this once

2. build the site

2.1. open index.qmd -> click render

3. updating

3.1. update all at once
3.1.1 update 00_country_template_tlX.qmd (X =2 or 3)
3.1.2. run dev/03-update-chapters.sh (i.e., go to terminal and run bash dev/03-update-chapters.sh)

3.2. update one profile
3.2.1. open cri.qmd (or another) and modify

4. debugging

4.1. open any file
4.1.1. run chunks manually
