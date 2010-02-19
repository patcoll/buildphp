buildphp
========

buildphp is a customizable build system, based on Rake, that compiles PHP and supported modules and extensions.

The goal is to create a script that will get, compile and install PHP 5.2+ and a list of desired dependencies. It was written to allow rapid builds of PHP and PHP modules, with a concentration on building a comprehensive build kit for PHP 5.3.

By default, script builds PHP as a FastCGI binary, though this can obviously be changed by editing PHP's configuration flags.

Tested on an Intel Core 2 Duo iMac with Mac OS X Leopard (with Developer Tools installed) and also tested on a 64-bit Ubuntu box. I've put in switches to enable PIC whenever it has been necessary for me to get a working build. YMMV.

BORING DISCLAIMER: This software is distributed as-is and I claim no warranties except that it "works for me," so don't blame me if it destroys your computer.

  * Homepage: http://github.com/patcoll/buildphp
  * Author: [Pat Collins](http://burned.com)


Dependencies
------------

Typical POSIX stuff:

  * gcc
  * g++
  * sh
  * tar
  * wget

Ruby stuff:

  * ruby
  * rake


Quick Start
-----------

To install all dependencies and compile PHP:

    rake

The following command is also equivalent to `rake`:

    rake php:compile

To install PHP after a successful build (PLEASE NOTE: if configured as an Apache module this command may overwrite an existing PHP module):

    rake install

To delete all source folders (folders within "src") and temporary (everything within "tmp") files:

    rake clean
    
To delete all source folders (folders within "src"), temporary (everything within "tmp") and installed (everything within "local") files:

    rake clobber

That's it.


Further Installation Notes
--------------------------

The supported versions for PHP are in `lib/buildphp/packages/php.rb`. The versions of the rest of the packages should build for 5.2 or 5.3. YMMV.

For 5.3, it's recommended to uncomment the MySQL Native Driver (`mysqlnd`) in `Mysql::@php_modules` and to comment out the `mysql` package, which downloads and compiles the entire MySQL package. Not really necessary.


PECL Modules
------------

PECL modules are PHP extensions written in C that are distributed separately from the core PHP distribution. Some popular PECL modules include APC and Memcache. To see a list of PECL packages that have been configured to work with buildphp, type:

    rake pecl
    
These modules need an installation of PHP to work, so the `php:install` task is a prerequisite for each of them. For example, to build and activate the `memcache` PECL module:

    rake memcache



Features
--------

### Isolation

buildphp was designed to provide a build environment that operates as isolated as possible from the rest of the system. Of course if your system has common libraries such as `zlib` and your configuration flags don't explicitly disable functionality that depend on such libraries, then the configure scripts will pick up on those system-wide libraries, which may lead to unexpected results.

The good news is that it is relatively trivial to add build scripts for these sorts of libraries and then have the version of PHP you're compiling depend on your compiled version of that library instead of the system version. See the existing build scripts for examples. Further detailed documentation is forthcoming.

### Custom Path Configuration

Some environment variables you can tweak:

`TMP_DIR`

You may change this variable if you wish to change where temporary files are stored. Current this is only used for grabbing PEAR packages for installation. Default is the "tmp" folder, which is empty in a standard distribution of buildphp. Another good option could be "/tmp".

`EXTRACT_TO`

You may change this variable if you wish to change which directory packages are downloaded to and extracted. Default is the "packages" folder, which is empty in a standard distribution of buildphp.

`INSTALL_TO`

You may change this variable if you wish to change which directory buildphp installs all packages into. *There is currently no support for per-package installation directories.* Default is the "local" folder, which is empty in a standard distribution of buildphp.

For example, to install all files into `/usr/local`:

`INSTALL_TO=/usr/local sudo rake php:install`

This should be run only by those who know what they're doing. See boring disclaimer above.

**Please note:** It is also possible to perform installations of dependencies individually as well. For example, it is possible to install the configured MySQL package in `/usr/local` by doing the following:

`INSTALL_TO=/usr/local sudo rake mysql:install`

Your mileage may vary. Repeat disclaimer here.

### Package Detection

buildphp removes the need for downloading packages multiple times by allowing archives to stay in the "packages" folder. As long as the existing package passes an MD5 digest check, it can stay. If developers package all necessary source packages with a buildphp distribution, it can significantly reduce network load when using buildphp to execute multiple builds at once. (Good for creating server farms?)

### Compilation Detection

For each package, buildphp runs the `is_compiled` method on each package to detect if there are any files that match the `*.o` glob. This is customized for some packages that don't fit a "standard" source folder structure. Since all packages contain build scripts that compile C and C++ code, this was the simplest (but not the most accurate) solution. Suggestions are welcome on how to improve. Fork and go.

One thing to note: when a build of a certain package fails for any reason (exit status greater than zero, or a ^C user interrupt) then an attempt is made to clean the source directory using a "make clean" command, which in theory brings the source directory back to the state it was before the build was attempted.

### Installation Detection

For each package, buildphp runs the `is_installed` method to detect whether the package has been installed or not. The first iteration of this just detects one file that is installed when a `make install` command is issued for that package. This works for most packages by just checking to see if a binary file exists in `local/bin` or a library exists in `local/lib`. Forks are welcomed.

### Force Mode

buildphp uses some pretty basic methods to detect whether packages are compiled or installed. This is done to prevent duplicated work from build to build.

An example: If the MySQL package has already been built and installed but the PHP package has not been (maybe the user threw a ^C mid-process) we don't want to compile and install MySQL all over again. That's a long wait.

On the other hand, if we change some package options and need to recompile and reinstall MySQL, we need to override this default behavior to do so. This is where a "force" mode comes in handy. A simple call to:

    rake mysql:force:install

will ignore the `is_installed` status and force a configure, compile and install of the MySQL package.

- - -

Bugs, Issues, Comments, Contributions, TODO
----------------------------

http://github.com/patcoll/buildphp/issues

TODO
----

  * Remove separate package files for bundled PHP extensions. Put their configure flags directly into `Php::get_build_string`
  * Put PECL extension package files into a new `packages/pecl` folder.
  * Rewrite packages to use a simpler DSL syntax.

License
-------

Copyright (c) 2009 Pat Collins <[burned.com](http://burned.com/)\>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.