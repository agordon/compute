---
layout: default
title: Calc - download
---

### Version

The latest released version is {{ site.calc_version }} .

The latest development version is available at <{{site.calc_git_url}}>.

### Download pre-compiled binaries

Pre-compiled binaries are available for the following platforms:

* [Debian/Ubuntu 64Bit package]({{site.calc_deb_64bit_url}})
* [Linux-64bit]({{site.calc_bin_linux_64bit_url}})
* [Mac OS X]({{site.calc_bin_macosx_url}})
* [FreeBSD 10-64bit]({{site.calc_bin_freebsd_64bit_url}})

### HomeBrew/LinuxBrew

On Mac OS X with [HomeBrew](http://brew.sh/) or on Linux with [LinuxBrew](https://github.com/Homebrew/linuxbrew/), install `calc` by running the following:

```sh
brew install agordon/gordon/calc
```

### Compile from source code

To compile from source code, download [{{site.calc_src_tarball_filename}}]({{site.calc_src_tarball_url}})

```sh
wget {{site.calc_src_tarball_url}}
tar -xzf {{site.calc_src_tarball_filename}}
cd calc-{{site.calc_version}}
./configure
make
make check
sudo make install
```

### Compile from GIT repository

To compile from the [GIT repository]({{site.calc_git_url}}), run the following commands (and see 'prerequisites', below):

```sh
git clone {{site.calc_git_url}}
cd calc
./bootstrap
./configure
make
make check
sudo make install
```

### Prerequisites

To use the `--sort` with `--headers` options together, **GNU Sed** version 4.2.2 is required (it is not required if using just `--sort` or just `--headers` or neither of them).

To compile from the GIT repository, the following programs are needed: automake,autoconf,gcc/clang,gperf,help2man.

On **Debian/Ubuntu** systems, use the following command:

```sh
sudo apt-get install build-essential help2man gperf autoconf automake gettext autopoint
```

On **RedHat/CentOS** systems, use the following command:

```sh
sudo yum install gcc git make automake autoconf gettext pkgconfig gperf help2man
```

On **Mac OS X** with **XCode** and HomeBrew, use the following commands:

```sh
brew install help2man
```

