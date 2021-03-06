% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/report_results.R
\name{report_results}
\alias{report_results}
\title{A function to create automatically output to report stats results in publications}
\usage{
report_results(model_data, method)
}
\arguments{
\item{model_data}{For "mainef_anova", "chisq", "mainef_Anova" and "summary" methods, put the statistical model. For the "emmeans" method, create an object as: your_model$pairwise..., and in a second step, convert this model in data frame using the as.data.frame() function and use this transformed model as argument.}

\item{method}{Statistical method employed: either "mainef_anova", in this case an anova(model_data) will be performed, "chisq", then the results of the model will be used, "mainef_Anova" the Anova(model_data) from the car package will be performed. The "summary" method uses the summary(model_data).
Some methods are implemented only for certain models. *mainef_anova* is implemented only for lm() and lmer() models. *chisq* only supports models from the chisq.test() function. *emmeans* supports only emmeans() models after transformation as described above. *mainef_Anova* supports only glmer() models. *summary* supports lm(), lmer(), and glmer() models.}
}
\description{
This function returns a data frame, in which, for each effect, a text output containing the results to export in the publications are produced.
}
