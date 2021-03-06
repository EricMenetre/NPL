% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LMM_check.R
\name{LMM_check}
\alias{LMM_check}
\title{A function to verify the postulates of an lmer element}
\usage{
LMM_check(model)
}
\arguments{
\item{model}{The model for which the postulates need to be checked}
}
\description{
This function allows to check if the intercepts or slopes of the effects are normally distributed, if the residuals are normally distributed and if there is an homogeneity of the variances in the residuals. All the plots that the function returns should show a globally normal distribution.
}
\keyword{homoscedasticity}
\keyword{postulates,}
\keyword{residuals,}
