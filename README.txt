#################################################################
################### FUNCTION portfosort #########################
## Author: Ehsan Fazel (Concordia University)                  ##
## This version: November 2019                                 ##
## I used the package "portsort" in R as a reference:          ##
## https://cran.r-project.org/web/packages/portsort/index.html ##
##                                                             ##
## portfosort computes univariate sorting portfolios sorted    ##
## on the factor beta for only 2 factors.                      ##
##                                                             ##
## Input 1 (exrtn): a panel of N excess common stock return    ##
## (T by N).                                                   ##
## Input 2 (factors): a panel of 2 factors (T by 2)            ##
## Input 3 (w): window length                                  ##
## Input 4 (fnum): select the factor to sort on. Either 1 or 2 ##
##                                                             ##
##                                                             ##
## Output 1 (prtf): tercile portfolio sorted on the factor     ##
## beta                                                        ##
## Output 2 (rtns): stored returns in each portfolio           ##
## Output 3 (tkrs): stored tickers (indeces) in each portfolio ##
##                                                             ##
##                                                             ##
## Take note that the exrtn or the excess return panel must    ##
## have one period ahead of the time dimension of the factors  ##
## so that forward returns could be constructed.               ##        
#################################################################
#################################################################
