---
layout: default
title: compute - Manual
---

### compute Usage

Run `compute --help` to see the help screen:

```sh
$ compute --help
Usage: compute [OPTION] op col [op col ...]
Performs numeric/string operations on input from stdin.

'op' is the operation to perform on field 'col'.

Numeric operations:
  sum        sum the of values
  min        minimum value
  max        maximum value
  absmin     minimum of the absolute values
  absmax     maximum of the absolute values

Textual/Numeric operations:
  count       count number of elements in the group
  first       the first value of the group
  last        the last value of the group
  rand        one random value from the group
  unique      comma-separated sorted list of unique values
  collapse    comma-separated list of all input values
  countunique number of unique/distinct values

Statistical operations:
  mean       mean of the values
  median     median value
  q1         1st quartile value
  q3         3rd quartile value
  iqr        inter-quartile range
  mode       mode value (most common value)
  antimode   anti-mode value (least common value)
  pstdev     population standard deviation
  sstdev     sample standard deviation
  pvar       population variance
  svar       sample variance
  mad        Median Absolute Deviation,
             scaled by constant 1.4826 for normal distributions
  madraw     Median Absolute Deviation, unscaled
  sskew      skewness of the (sample) group
  pskew      skewness of the (population) group
             For values x reported by 'sskew' and 'pskew' operations:
                     x > 0       -  positively skewed / skewed right
                 0 > x           -  negatively skewed / skewed left
                     x > 1       -  highly skewed right
                 1 > x >  0.5    -  moderately skewed right
               0.5 > x > -0.5    -  approximately symmetric
              -0.5 > x > -1      -  moderately skewed left
                -1 > x           -  highly skewed left
  skurt      Excess Kurtosis of the (sample) group
  pkurt      Excess Kurtosis of the (population) group
  jarque     p-value of the Jarque-Beta test for normality
  dpo        p-value of the D'Agostino-Pearson Omnibus test for normality.
             For 'jarque' and 'dpo' operations:
               Null hypothesis is normality.
               Low p-Values indicate non-normal data.
               High p-Values indicate null-hypothesis cannot be rejected.


General options:
  -f, --full                Print entire input line before op results
                            (default: print only the grouped keys)
  -g, --group=X[,Y,Z]       Group via fields X,[Y,Z]
  --header-in               First input line is column headers
  --header-out              Print column headers as first line
  -H, --headers             Same as '--header-in --header-out'
  -i, --ignore-case         Ignore upper/lower case when comparing text
                            This affects grouping, and string operations
  -s, --sort                Sort the input before grouping
                            Removes the need to manually pipe the input through 'sort'
  -t, --field-separator=X   use X instead of TAB as field delimiter
  -W, --whitespace          use whitespace (one or more spaces and/or tabs)
                            for field delimiters
  -z, --zero-terminated     end lines with 0 byte, not newline
      --help     display this help and exit
      --version  output version information and exit

Examples:

Print the sum and the mean of values from column 1:

  $ seq 10 | compute sum 1 mean 1
  55  5.5

Group input based on field 1, and sum values (per group) on field 2:

  $ cat example.txt
  A  10
  A  5
  B  9
  B  11
  $ compute -g 1 sum 2 < example.txt
  A  15
  B  20

Unsorted input must be sorted (with '-s'):

  $ cat example.txt
  A  10
  C  4
  B  9
  C  1
  A  5
  B  11
  $ compute -s -g1 sum 2 < example.txt
  A 15
  B 20
  C 5

Which is equivalent to:
  $ cat example.txt | sort -k1,1 | compute -g 1 sum 2


More detailed manual and examples, please visit
  http://agordon.github.io/compute/

```

### Tabs, Spaces and Field Delimiters

By default, `compute` uses TABs (ASCII 9) as field-delimiters. Spaces are not treated as field-delimiters.

To use any other character as field delimeter, add `-t "X"'` to the command line parameters (where `X` is the desired character, such as `,`).

To use whitespace as field-delimiter (i.e. one or more spaces and tabs)
use the `-W` or `--whitespace` parameter.

Note the difference between `-t " "` and `-W`:

- Using `-t " "` means: Use a single space (ASCII 32) character as field delimiter.
    TABs are then treated like any other character.
- Using `-W` means: Use any whitespace (either TAB or SPACE) characters as field delimiter.
    Multiple spaces and TABS are then treated as one delimiter.



### Real-world examples

See more examples in the [Examples Section](./examples.html) and the
[Statistics Examples Section](./example_stats.html).

