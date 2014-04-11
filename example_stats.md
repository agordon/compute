---
layout: default
title: compute - Statistics examples
---

### Statistics Functions in compute

compute supports the following statistical operations:

1. **mean** - arithmetic mean.
2. **median** - median value (50th percentile) ([details](http://en.wikipedia.org/wiki/Median)).
3. **q1**   - First quartile ([details](http://en.wikipedia.org/wiki/Quartile))
4. **q3**   - Third quartile.
5. **iqr**  - Inter-quartile range.
6. **mode** - The value appearing most often in the data ([details](http://en.wikipedia.org/wiki/Mode_%28statistics%29)).
7. **antimode** - The value appearing least often in the data.
8. **pstdev** - Standard-deviation of a set representing the entire **population** ([details](http://en.wikipedia.org/wiki/Standard_deviation)).
9. **sstdev** - Standard-deviation of a set representing a **sample** of a population.
10. **pvar**  - Variance of a **population** ([details](http://en.wikipedia.org/wiki/Variance)).
11. **svar**  - Variance of a **sample**.
12. **mad**   - Median Absolute Deviation, scaled by 1.4826 for normal distribution ([details](http://en.wikipedia.org/wiki/Median_absolute_deviation)).
13. **madraw**- Median Absolute Deviation, unscaled.
14. **pskew** - Skewness of a set representing the entire **population** ([details](http://en.wikipedia.org/wiki/Skewness)).
15. **sskew** - Skewness of a set representing a **sample** of a population.
16. **pkurt** - Excess Kurtosis of a set representing the entire **population** ([details](http://en.wikipedia.org/wiki/Kurtosis)).
17. **skurt** - Excess Kurtosis of a set representing a **sample** of a population.
18. **jarque** - p-Value of Jarque-Bera test for normality ([details](http://en.wikipedia.org/wiki/Jarque%E2%80%93Bera_test)).
19. **dpo**   - p-Value of D'Agostino-Pearson Omnibus test for normality ([details](http://en.wikipedia.org/wiki/D%27Agostino%27s_K-squared_test#Omnibus_K2_statistic)).

### Equivalent to R functions

compute is designed to closely follow [R project](http://www.r-project.org/)'s
statistical functions. See the [R equivalent code](./files/operators.R) for each
of compute's operators. When building `compute` from source code on your local computer,
these operators are checked using the `make check` command.

### Using statistical functions

Example of calculating the (Five-Number Summary)[http://en.wikipedia.org/wiki/Five-number_summary] (min,q1,median,q3,max values) of all values in the first column of the input file:

```sh
$ compute min 1 q1 1 median 1 q3 1 max 1 < FILE.TXT
78      93     100        107    120
```

The same command, with header lines for better clarity:

```sh
$ compute -H min 1 q1 1 median 1 q3 1 max 1 < FILE.TXT
min(x)  q1(x)  median(x)  q3(x)  max(x)
78      93     100        107    120
```

Finding out the count,mean and sample standard-deviation:

```sh
$ compute -H count 1 mean 1 sstdev 1 < FILE.TXT
count(x)   mean(x)   sstdev(x)
100        100.06    9.5767184
```

Testing for normality (**See next section for discussion about normality testing**):

```sh
$ compute -H sskew 1 skurt 1 dpo 1 jarque 1 < FILE.TXT
sskew(x)     skurt(x)     dpo(x)    jarque(x)
-0.207246    -0.5770543   0.3341    0.3271
```

### Testing for normality

A normal distribution is required for many applications of. Testing whether your
data fits a normal distribution or not is commonly a first step before starting a
more thorough analysis.

Several operations can be used to test for normality, thought care must be taken
when inferring results. **Always** consult a trained statistician before making final
analysis.

**Skewness**

[Skewness](http://en.wikipedia.org/wiki/Skewness) operations (**sskew**, **pskew**)
test the data set for asymmetry of the probability distribution of a real-valued
random variable about its mean. A normally distributed set should have low skewness.

The rule-of-thumb ranges were suggested in [Mulmer, M.G., Principles of Statistics (1979)](http://store.doverpublications.com/0486637603.html):

```
                     x > 0       -  positively skewed / skewed right
                 0 > x           -  negatively skewed / skewed left

                     x > 1       -  highly skewed right
                 1 > x >  0.5    -  moderately skewed right
               0.5 > x > -0.5    -  approximately symmetric
              -0.5 > x > -1      -  moderately skewed left
                -1 > x           -  highly skewed left
```

**Jarque-Bera Test**

[Jarque-Bera test](http://en.wikipedia.org/wiki/Jarque%E2%80%93Bera_test) is a
goodness-of-fit test of whether sample data have the skewness and kurtosis
matching a normal distribution.

`compute`'s **jarque** operator returns the p-value calculated for the data set
based on the Jarque-Bera test, under the null-hepythesis of normality.
A **high** p-value indicates the null hypothesis **cannot** be rejected,
and therefor the input data **might** be normally distributed.
A **low** p-value indicates the null hypothesis **can** be rejected, and the
data is likely not normally distributed.

**D'Agostino-Peason Omnibus Test**

[D'Agostino-Pearson Omnibus test](http://en.wikipedia.org/wiki/D%27Agostino%27s_K-squared_test#Omnibus_K2_statistic) detects deviations from normality due to either skewness or kurtosis.

Similarly to **jarque** operator, the **dpo** operator returns the p-value calculated for the data set
based on the Jarque-Bera test, under the null-hepythesis of normality.
A **high** p-value indicates the null hypothesis **cannot** be rejected,
and therefor the input data **might** be normally distributed.
A **low** p-value indicates the null hypothesis **can** be rejected, and the
data is likely not normally distributed.


**Examples - Testing for normality**

The files used in the following examples:

- [seq20](./files/seq20.txt) - 100 normally-distributed random values.
- [seq21](./files/seq21.txt) - 100 random values drawn from a non-normal distribution.

Testing normally-distribted values:

```sh
$ compute -H sskew 1 jarque 1 dpo 1 < seq20.txt
sskew(x)    jarque(x)  dpo(x)
-0.207246   0.327135   0.334111
```

The skewness result is close enough to zero to be considered approximately symmetric,
while both Jarque-Bera test and D'Agostino-Pearson-Omnibus test return high p-values -
indicating the null-hypothesis of normal-distribution *cannot* be rejected.

**NOTE**: This does not yet prove the data is truly normally distributed - but this is a
positive first step.


Testing non-normally-distributed values:

```sh
$ compute -H sskew 1 jarque 1 dpo 1 < seq21.txt
sskew(x)   jarque(x)   dpo(x)
1.212020   8.0113e-09  7.6899e-10
```

The skewness result is large enough to indicate the values are highly skewed.
The Jarque-Bera test and D'Agostino-Pearson-Omnibus test results show very low p-values -
indicating the null-hypothesis of normal-distribution *can* be rejected.


**Further information**

For an informative tutorial about skewness and kurtosis, see [Measures of Shape: Skewness and Kurtosis, by Stan Brown](http://www.tc3.edu/instruct/sbrown/stat/shape.htm)
