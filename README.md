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
install.packages("car")
install.packages("emmeans")
install.packages("cAIC4")
install.packages("nlme")
install.packages("DescTools")
```
If you encounter problem to install these packages, please update your R and Rstudio versions.

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
If you encounter problem to install these packages, please update your R and Rstudio versions. If the problem persists, be sure that the path where the package is saved does not contains accents. To find out where the packages downloaded from GitHub are saved use the `?install_github()` command (after loading the package devtools). If the path contains accents, for PC owners, create a temporary folder on the root directory of your C disk, and use the `.libPaths("C:/your_new_folder")` command and repeat the installation process. When the process is done, copy the NPL folder from the temporary folder to your library. You will find the path in the `?install_github()` command. For mac user, the problem did not occured yet. If so, please contact Eric Ménétré.

If you notice a bug or you have trouble using a function, please contact me at: Eric.Menetre@unige.ch

Please visit: https://www.unige.ch/fapse/psycholinguistique/equipes/npl/membres/eric-menetre/


### To cite this package, please use: 

```r
citation("NPL")
```

### Functions included in the package (V0.0.1.8):

#### For behavioral analyses:
* **clean.sd**: This function aims at cleaning the data from the extreme latencies (according to a certain number of SD). It creates an array of values without the values above and under the mean of each group.
* **clean.subj.group**: This function is very similar to the previous one but aims at detecting if the average latencies of a subject are extreme compared to the rest of the group without this subject.
* **date.banner**: This simple function based on the bannerCommenter package creates a banner including the date and the day to keep track of the code.
* **exp_plots_LMM**: The function creates useful plots to investigate the data before undergoing linear mixed models analyses.
* **LMM_check**: Once a linear mixed model is fitted, this function checks if the postulates of the model are respected.
* **ICC_ranef**: This function estimates the intra-class correlation (ICC) of every random effects of an lmer or glmer model. The ICC is an index of how much a given random effect explains the total variance. In other words, it gives an estimate of the variance inside a class. If the ICC is high, it means that the differences inside the class are important. When the ICC is low, the measures are fairly similar inside the class.
* **mod_fitting**: This function takes as input a list (using the `list()` function) of lmer or glmer models and returns a table containing all the fitting information available (AIC; BIC; log likelihood; deviance; number of residual DF). The models are then ordered according to the smallest AIC.
* **cross_anova_models**: This function, as the previous one, takes as input a list of models (using the `list()` function) and returns a cross table matrix (N models from the list times N models from the list) and gives the `anova()` of the models two by two. This helps chosing the model with the best fitting. The user should check the simpler model compared to the same model with one more parameter. If the p-value is significant, then take this model as reference and continue so until reaching the most complex model with a significantly better fitting than the previous one. 
* **std_error**: Function to calculate the standard error of an array. 


#### For EEG analyses:
* **concatenate.EEG**: The function allows to concatenate two epochs, usually used in the microstates analyses to include the stimulus and response aligned epochs.
* **convert.eph.ep**: Since all EEG functions use the .ep format (Cartool format), this function converts the files from the usual .eph format to the .ep format. The .eph format contains a header that needs to be removed to be treated as a data frame or a matrix.
* **convert.eph.ep.folder**: Same function as the previous one but for an entire directory.
* **create.tva.files**: To allow the analyses of response-aligned EEG, Cartool requests a file (.tva) containing the RT of each trial, the accuracy of the response as well as the triggers' information. This function creates all the TVA files for each subject based on the behavioral data frame.
* **delete.spaces.STEN**: STEN requires the name of the .eph files to be written without spaces. This function simply renames all the .eph files of a given folder.
* **import.epochs.ep**: The function reads the different EEG files and brings them together in a data frame under the tidy format. 
* **subtract.eeg**: This function aims at subtracting two EEG files of the same size (same number of time frames and electrodes).
* **tanova.ragu.to.cartool**: To visualize the tanova results given by the Ragu software into the Cartool software. Be careful, the function dichotomizes the p-values. All p-values equal to or under 0.05 will be equal to 1 and p-values above 0.05 will be equal to 0.
* **find_max_amp_diff**: A function to find the maximum amplitude difference between two conditions among all electrodes. The point is to help the user to select the electrode showing the maximum differences when performing peak analysis. Before using this function, import your data with import.epochs.ep().

#### Writing and reporting results

* **number_to_word**: Function to transform integer (1,2,3,...) to words ("one", "two", "three",...). When writing results in RMarkdown, one might want to avoid writing small number when calling outputs from the analyses in the text. For exemple: "`r my_number`  patients outperformed the controls" might get printed as "2 patients outperformed the controls". The function allows to write it as "`r number_to_word(my_number, cap = TRUE)` patients outperformed the controls", which might get now printed as "Two patients outperformed the controls".
* **report_results**: This function helps the user to report easily statistical results in the text of a publication, limitating report mistakes and number rounding mistakes. The function takes as argument the statistical model to report and the model used. The supported methods are the `anova()` of a model, the `Anova()` (from the car package), the result from a `chisq.test()`model, a post-hoc `emmeans()` model and the `summary()` of a model. See `help(report_results)` for more details. To avoid format problem, when copying results in Word, paste only the values instead of using a simple paste.

If you need a specific tool to analyse your data do not hesitate to come to me and we can surely figure something out ;-)


## Cheat Sheets from the NPL group:

* [Cheat Sheet Linear Mixed Models](https://github.com/EricMenetre/R-codes/blob/master/CheatSheet%20Linear%20Mixed%20Models.pdf)
