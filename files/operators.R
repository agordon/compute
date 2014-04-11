##
## This R scripts shows the R function equivalent of compute's operators.
##
## This file is part of the 'compute' package, see
##  https://agordon.github.io/compute
##

seq1  = c(1,2,3,4)
seq2  = c(1,2,3)
seq3  = c(2)
seq9  = c(2,3,5,7,11,13,17,19,23)
seq10 = c(2,3,5,7,11,13,17,19,23,29)
seq11 = c(2,3,5,7,11,13,17,19,23,29,31)
seq12 = c(2,3,5,7,11,13,17,19,23,29,31,37)
seq20 = c(117,89,86,101,90,110,97,91,106,99,118,110,82,91,105,90,108,96,
      92,103,107,87,100,101,101,86,97,94,97,87,114,104,97,107,94,117,
      100,111,111,113,93,113,107,108,95,117,106,105,105,105,105,99,
      91,103,84,99,99,99,108,94,103,96,93,90,107,111,103,98,103,96,
      113,111,84,109,96,110,90,78,111,85,102,91,107,99,120,109,107,
      92,106,86,108,107,104,78,100,97,99,86,98,82)
seq21 = c(63,13,64,23,86,61,76,28,84,27,38,40,15,29,120,56,59,33,73,103,
      15,22,36,45,40,35,3,114,66,55,16,17,29,30,42,32,34,110,16,33,
      57,35,48,78,35,84,20,83,78,49,26,29,50,41,23,21,24,79,92,41,
      77,64,12,31,6,32,22,8,19,27,14,12,64,51,29,33,24,58,1,56,47,
      98,44,33,18,38,5,33,17,21,116,169,57,40,2,59,88,42,68,23)
seq22 = c(61,61,61,61,61,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,64,
      64,64,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,
      67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,67,
      67,67,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,70,
      70,70,70,70,70,70,70,70,73,73,73,73,73,73,73,73)
seq23 =  c(rep(1,7),rep(2,33),rep(3,58),rep(4,116),rep(5,125),rep(6,126),
       rep(7,121),rep(8,107),rep(9,56),rep(10,37),rep(11,25),rep(12,4))

# define a population-flavor variance and sd functions
# (R's default are sample-variance and sample-sd)
pop.var=function(x)(var(x)*(length(x)-1)/length(x))
pop.sd=function(x)(sqrt(var(x)*(length(x)-1)/length(x)))
smp.var=var
smp.sd=sd

# Helper functions for quartiles
q1=function(x) { quantile(x, prob=0.25) }
q3=function(x) { quantile(x, prob=0.75) }

# Helper function for madraw
madraw=function(x) { mad(x,constant=1.0) }

# 'moments' library contains skewness and kurtosis
library(moments)

# helper functions for skewness
pop.skewness=skewness
smp.skewness=function(x) { skewness(x) * sqrt( length(x)*(length(x)-1) ) / (length(x)-2) }

# helper functions for excess kurtosis
pop.excess_kurtosis=function(x) { kurtosis(x)-3 }
smp.excess_kurtosis=function(x) {
  n=length(x)
  ( (n-1) / ( (n-2)*(n-3) ) ) *
     ( (n+1) * pop.excess_kurtosis(x) + 6 )
}

# Helper function for SES - Standard Error of Skewness
SES = function(n) { sqrt( (6*n*(n-1)) / ( (n-2)*(n+1)*(n+3) ) ) }
# Helper function for SEK - Standard ERror of Kurtosis
SEK = function(n) { 2*SES(n) * sqrt ( (n*n-1) / ( (n-3)*(n+5)  ) ) }

# Helper function for Skewness Test Statistics
skewnessZ = function(x) { smp.skewness(x)/SES(length(x)) }
# Helper function for Kurtosis  Test Statistics
kurtosisZ = function(x) { smp.excess_kurtosis(x)/SEK(length(x)) }

# Helper function for Jarque-Bera pValue
jarque.bera.pvalue=function(x) { t=jarque.test(x) ; t$p.value }

# Helper function for D'Agostino-Pearson Omnibus Test for normality
dpo=function(x) {
 DP = skewnessZ(x)^2 + kurtosisZ(x)^2
 pval = 1.0 - pchisq(DP,df=2)
}

# Helper function to execute function 'f' on all input sequences
test=function(f) {
 f_name =  deparse(substitute(f))
 cat(f_name,"(seq1)=",  f(seq1), "\n")
 cat(f_name,"(seq2)=",  f(seq2), "\n")
 cat(f_name,"(seq3)=",  f(seq3), "\n")
 cat(f_name,"(seq9)=",  f(seq9), "\n")
 cat(f_name,"(seq10)=", f(seq10),"\n")
 cat(f_name,"(seq11)=", f(seq11),"\n")
 cat(f_name,"(seq12)=", f(seq12),"\n")
 cat(f_name,"(seq20)=", f(seq20),"\n")
 cat(f_name,"(seq21)=", f(seq21),"\n")
 cat(f_name,"(seq22)=", f(seq22),"\n")
 cat(f_name,"(seq23)=", f(seq23),"\n")
}

# Run tests
test(mean)
test(median)
test(q1)
test(q3)
test(IQR)
test(smp.sd)
test(pop.sd)
test(smp.var)
test(pop.var)
test(mad)
test(madraw)
test(skewness)
test(smp.skewness)
test(pop.excess_kurtosis)
test(smp.excess_kurtosis)
test(jarque.bera.pvalue)
