# NPL package

NPL package is a collection of functions I needed to create during my PhD in the NeuroPsycholinguistic lab of the UNIGE. Some of the functions aim at helping the researcher to analyse behavioral data or EEG data. The EEG functions instend mostly to fill the gap between the different softwares used in our lab (Cartool: https://sites.google.com/site/cartoolcommunity/ ; STEN: https://www.unil.ch/line/en/home/menuinst/mission/about-the-line/software--analysis-tools.html ; RAGU: http://www.thomaskoenig.ch/index.php/work/ragu), or to perform statistical analyses on the EEG data. 

## To install the package, follow these steps: 

Step 1: install the devtools package using the following command line

```r
install.packages("devtools")
```

Step 2: load the devtools package: 

```r
library("devtools")
```
Step 3: download and install the package

```r
install_github("EricMenetre/NPL")
```
Step 4: load the package like any other oackage anytime you want to use it.

```r
library(NPL)
```
The package will be improved over time, please update regularly your package version using the command line given at the third step. 
