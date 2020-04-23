![alt text](https://alumniunige.ch/wp-content/uploads/2017/12/UNIGE-logo-site-ALUMNI-unige-4.jpg "Logo Title Text 1")
# The NPL package  

The NPL package, standing for **N**euro**P**sycho**L**inguistic group package, is a collection of functions I needed to write during my PhD in the NeuroPsycholinguistic lab of the UNIGE. Some of the functions aim at helping the researcher to analyse behavioral or EEG data. The EEG functions intend mostly to fill the gap between the different softwares used in our lab (Cartool: https://sites.google.com/site/cartoolcommunity/ ; STEN: https://www.unil.ch/line/en/home/menuinst/mission/about-the-line/software--analysis-tools.html ; Ragu: http://www.thomaskoenig.ch/index.php/work/ragu), or to perform statistical analyses on the EEG data. 


## Before installing the package

The NPL package uses some other packages. Please be sure that all the following packages are installed and up to date: 

```r
install.packages("ggplot2")
install.packages("dplyr")
install.packages("tidyr")
install.packages("tibble")
install.packages("ggpubr")
install.packages("bannerCommenter")
install.packages("lme4")
install.packages("lmerTest")

```

## To install the NPL package, follow these steps: 

Step 1: install the devtools package using the following command line

```r
install.packages("devtools")
```

Step 2: load the devtools package

```r
library("devtools")
```
Step 3: download and install the NPL package

```r
install_github("EricMenetre/NPL")
```
Step 4: load the package like any other package anytime you want to use it

```r
library(NPL)
```
The package will be improved over time, please update regularly your package version using the command line given at the third step. 

If you notice a bug or you have trouble using a function, please contact me at: Eric.Menetre@unige.ch

Please visit: https://www.unige.ch/fapse/psycholinguistique/equipes/npl/membres/eric-menetre/


### To cite this package, please use: 

```r
citation("NPL")
```

### Functions included in the package:

#### For behavioral analyses:
* **clean.sd**: This function aims at cleaning the data from the extreme latencies (according to a certain number of SD). It creates an array of values without the values above and under the mean of each group.
* **clean.subj.group**: This function is very similar to the previous one but aims at detecting if the average latencies of a subject are extreme compared to the rest of the group without this subject.
* **date.banner**: This simple function based on the bannerCommenter package creates a banner including the date and the day to keep track of the code.
* **exp_plots_LMM**: The function creates useful plots to investigate the data before undergoing linear mixed models analyses.
* **LMM_check**: Once a linear mixed model is fitted, this function checks if the postulates of the model are respected.
* **ICC_ranef**: This function estimates the intra-class correlation (ICC) of every random effects of an lmer or glmer model. The ICC is an index of how much a given random effect explains the total variance. In other words, it gives an estimate of the variance inside a class. If the ICC is high, it means that the differences inside the class are important. When the ICC is low, the measures are fairly similar inside the class.
* **mod_fitting**: This function takes as input a list of lmer or glmer models and returns a table containing all the fitting information available (AIC; BIC; log likelihood; deviance; number of residual DF). The models are then ordered according to the smallest AIC.
* **cross_anova_models**: This function, as the previous one, takes as input a list of models and returns a cross table matrix (N models from the list times N models from the list) and gives the anova() of the models two by two. This helps chosing the model with the best fitting. The user should check the simpler model compared to the same model with one more parameter. If the p-value is significant, then take this model as reference and continue so until reaching the most complex model. 


#### For EEG analyses:
* **concatenate.EEG**: The function allows to concatenate two epochs, usually used in the microstates analyses to include the stimulus and response aligned epochs.
* **convert.eph.ep**: Since all EEG functions use the .ep format (Cartool format), this function converts the files from the usual .eph format to the .ep format. The .eph format contains a header that needs to be removed to be treated as a data frame or a matrix.
* **convert.eph.ep.folder**: Same function as the previous one but for an entire directory.
* **create.tva.files**: To allow the analyses of response-aligned EEG, Cartool requests a file (.tva) containing the RT of each trial, the accuracy of the response as well as the triggers' information. This function creates all the TVA files for each subject based on the behavioral data frame.
* **delete.spaces.STEN**: STEN requires the name of the .eph files to be written without spaces. This function simply renames all the .eph files of a given folder.
* **import.epochs.ep**: The function reads the different EEG files and brings them together in a data frame under the tidy format. 
* **subtract.eeg**: This function aims at subtracting two EEG files of the same size (same number of time frames and electrodes).
* **tanova.ragu.to.cartool**: To visualize the tanova results given by the Ragu software into the Cartool software. Be careful, the function dichotomizes the p-values. All p-values equal to or under 0.05 will be equal to 1 and p-values above 0.05 will be equal to 0.

If you need a specific tool to analyse your data do not hesitate to come to me and we can surely figure something out ;-)


## Cheat Sheets from the NPL group:

* [Cheat Sheet Linear Mixed Models](https://github.com/EricMenetre/R-codes/blob/master/CheatSheet%20Linear%20Mixed%20Models.pdf)
