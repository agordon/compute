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
  count      count number of elements in the input group
  sum        print the sum the of values
  min        print the minimum value
  max        print the maximum value
  absmin     print the minimum of abs(values)
  absmax     print the maximum of abs(values)
  mean       print the mean of the values
  median     print the median value
  mode       print the mode value (most common value)
  antimode   print the anti-mode value (least common value)
  pstdev     print the population standard deviation
  sstdev     print the sample standard deviation
  pvar       print the population variance
  svar       print the sample variance

String operations:
  unique      print comma-separated sorted list of unique values
  collapse    print comma-separed list of all input values
  countunique print number of unique values


General options:
  -f, --full                Print entire input line before op results
                            (default: print only the groupped keys)
  -g, --group=X[,Y,Z]       Group via fields X,[Y,Z]
  --header-in               First input line is column headers
  --header-out              Print column headers as first line
  -H, --headers             Same as '--header-in --header-out'
  -i, --ignore-case         Ignore upper/lower case when comparing text
                            This affects grouping, and string operations
  -s, --sort                Sort the input before grouping
                            Removes the need to manually pipe the input through 'sort'
  -t, --field-separator=X   use X instead of whitespace for field delimiter
  -T                        Use tab as field separator
                            Same as -t $'\t'
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

```

### Real-world examples

See more examples in the [Examples Section](./examples.html).

