# Compute  is now GNU Datamash !

`compute` (now [GNU Datamash](http://www.gnu.org/s/datamash) is a command-line
program to perform textual,numerical,statistical operation on text files.

## Examples

What's the sum and mean of the values in field 1 ?

    $ seq 10 | datamash sum 1 mean 1
    55 5.5

Given a file with three columns (Name, College Major, Score),
what is the average, grouped by college major?

    $ cat scores.txt
    John       Life-Sciences    91
    Dilan      Health-Medicine  84
    Nathaniel  Arts             88
    Antonio    Engineering      56
    Kerris     Business         82
    ...


Sort input and group by column 2, calculate average on column 3:

    $ datamash --sort --group 2  mean 3 < scores.txt
    Arts             68.9474
    Business         87.3636
    Health-Medicine  90.6154
    Social-Sciences  60.2667
    Life-Sciences    55.3333
    Engineering      66.5385



## For more details

* GitHub Mirror: <http://github.com/agordon/datamash>

* Main website: <http://www.gnu.org/s/datamash>

* Examples: <http://www.gnu.org/software/datamash/examples/>

* Manual: <http://www.gnu.org/software/datamash/manual/>

* Galaxy Tool Demo: <http://computedemo.teamerlich.org/> (GNU Datamash is available on the [Galaxy ToolShed](https://toolshed.g2.bx.psu.edu/)).

* Download and installation: <http://www.gnu.org/software/datamash/download/>

* Send questions/bug-reports to the GNU Datamash mailing list: <bug-datamash@gnu.org>
    ([subscribe](https://lists.gnu.org/mailman/listinfo/bug-datamash) or [search archive](http://lists.gnu.org/archive/html/bug-datamash/) of previous discussions).


## License

Copyright (C) 2014 Assaf Gordon (assafgordon@gmail.com)

GPLv3 or later
