---
layout: default
title: compute - download
---

### Version

The latest released version is {{ site.compute_version }} .

The latest released version source code is [{{site.compute_src_tarball_filename}}]({{site.compute_src_tarball_url}})

The latest development version is available at <{{site.compute_git_url}}>.

### Download pre-compiled binaries

Pre-compiled binaries are available for the following platforms:

* [Debian/Ubuntu 64Bit package]({{site.compute_deb_64bit_url}})
* [RedHat/CentOS 64Bit package]({{site.compute_rpm_64bit_url}})
* [Linux-64bit]({{site.compute_bin_linux_64bit_url}})
* [Mac OS X]({{site.compute_bin_macosx_url}})
* [FreeBSD 10-64bit]({{site.compute_bin_freebsd_64bit_url}})

### HomeBrew/LinuxBrew

On Mac OS X with [HomeBrew](http://brew.sh/) or on Linux with [LinuxBrew](https://github.com/Homebrew/linuxbrew/), install `compute` by running the following:

```sh
brew install agordon/gordon/compute
```

### Compile from source code

To compile from source code, download [{{site.compute_src_tarball_filename}}]({{site.compute_src_tarball_url}})

```sh
wget {{site.compute_src_tarball_url}}
tar -xzf {{site.compute_src_tarball_filename}}
cd compute-{{site.compute_version}}
./configure
make
make check
sudo make install
```

### Compile from GIT repository

To compile from the [GIT repository]({{site.compute_git_url}}), run the following commands (and see 'prerequisites', below):

```sh
git clone {{site.compute_git_url}}
cd compute
./bootstrap
./configure
make
make check
sudo make install
```

### Prerequisites - when compiling from GIT repository

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

