buildphp
========

Build script for PHP 5.2+

The goal is to create a script that will get, compile and install PHP 5.2+ and a list of desired dependencies. It was written to allow rapid builds of PHP and PHP modules.

By default, script builds PHP as a FastCGI binary, though this can obviously be changed by editing PHP's configuration flags.

Tested on an Intel Core 2 Duo iMac with Mac OS X Leopard (with Developer Tools installed) and also tested on a 64-bit Ubuntu box. I've put in switches to enable PIC whenever it has been necessary for me to get a working build. YMMV.

BORING DISCLAIMER: This software is distributed as-is and I claim no warranties except that it "works for me," so don't blame me if it destroys your computer.

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


Instructions
------------

To install all dependencies and compile PHP:

    rake

The following command is also equivalent to `rake`:

    rake php:compile

To install PHP after a successful build (PLEASE NOTE: if configured as an Apache module this command may overwrite an existing PHP module):

    rake install

To delete all source folders (folders within "packages") and temporary (everything within "tmp") files:

    rake clean
    
To delete all source folders (folders within "packages"), temporary (everything within "tmp") and installed (everything within "local") files:

    rake clobber

That's it.

Features
--------

### Isolation

buildphp was designed to provide a build environment that operates as isolated as possible from the rest of the system. Of course if your system has common libraries such as `zlib` and your configuration flags don't explicitly disable functionality that depend on such libraries, then the configure scripts will pick up on those system-wide libraries, which may lead to unexpected results.

The good news is that it is relatively trivial to add build scripts for these sorts of libraries and then have the version of PHP you're compiling depend on your compiled version of that library instead of the system version. See the existing build scripts for examples. Further detailed documentation is forthcoming.

MAC USERS: For Mac OS X systems with MAMP installed, it has been requested that we include a MAMP-compatibility mode that compiles PHP against already existing dependencies within the MAMP package. This would involve changing the `@prefix` object variable to `/Applications/MAMP/Library` for each package that has a MAMP equivalent. This is forthcoming.

### Custom Path Configuration

Some environment variables you can tweak:

`BUILDPHP_TMP_DIR`

You may change `BUILDPHP_TMP_DIR` if you wish to change where temporary files are stored. Current this is only used for grabbing PEAR packages for installation. Default is the "tmp" folder, which is empty in a standard distribution of buildphp. Another good option could be "/tmp".

`BUILDPHP_EXTRACT_TO`

You may change `BUILDPHP_EXTRACT_TO` if you wish to change which directory packages are downloaded to and extracted. Default is the "packages" folder, which is empty in a standard distribution of buildphp.

`BUILDPHP_INSTALL_TO`

You may change `BUILDPHP_INSTALL_TO` if you wish to change which directory buildphp installs all packages into. *There is currently no support for per-package installation directories.* Default is the "local" folder, which is empty in a standard distribution of buildphp.

For example, to install all files into `/usr/local`:

`BUILDPHP_INSTALL_TO=/usr/local sudo rake`

This should be run only by those who know what they're doing. See boring disclaimer above.

**Please note:** It is also possible to perform installations of dependencies individually as well. For example, it is possible to install the configured MySQL package in `/usr/local` by doing the following:

`BUILDPHP_INSTALL_TO=/usr/local sudo rake mysql`

Your mileage may vary. Repeat disclaimer here.

### Package Detection

buildphp removes the need for downloading packages multiple times by allowing archives to stay in the "packages" folder. As long as the package matches the `@filename` property and passes an MD5 digest check, it can stay. If developers package all necessary source packages with a buildphp distribution, it can significantly reduce network load when using buildphp to execute multiple builds at once.

### Compilation Detection

For each package, buildphp runs the `is_compiled` method on each package to detect if there are any files that match the `*.o` glob. This is customized for some packages that don't fit a "standard" source folder structure. Since all packages contain build scripts that compile C and C++ code, this was the simplest (but not the most accurate) solution. Suggestions are welcome on how to improve. Fork and go.

### Installation Detection

For each package, buildphp runs the `is_installed` method to detect whether the package has been installed or not. The first iteration of this just detects one file that is installed when a `make install` command is issued for that package. This works for most packages by just checking to see if a binary file exists in `local/bin` or a library exists in `local/lib`. Forks are welcomed.

### Force Mode

buildphp uses some pretty basic methods to detect whether packages are compiled or installed. This is done to prevent duplicated work from build to build.

An example: If the MySQL package has already been built and installed but the PHP package has not been (maybe the user threw a ^C mid-process) we don't want to compile and install MySQL all over again. That's a long wait.

On the other hand, if we change some package options and need to recompile MySQL, we need to override this default behavior to do so. This is where a "force" mode comes in handy. A simple call to:

    rake mysql:force:install

will ignore the `is_installed` status and force a configure, compile and install of the MySQL package.

- - -

TODO
----

TODO: "remove" method that could remove individual package's files. each package would need to implement a diff to enable removal of files later.

TODO: Create build tasks for all packages below.

Packages
--------

php
	http://www.php.net/distributions/php-5.2.9.tar.gz
	http://www.php.net/distributions/php-5.3.0.tar.gz

### PHP dependencies for this build:

<!-- # bcmath built in -->
bz2
	http://www.bzip.org/1.0.5/bzip2-1.0.5.tar.gz
db4
	http://download.oracle.com/berkeley-db/db-4.7.25.tar.gz
curl
	http://curl.haxx.se/download/curl-7.19.4.tar.gz
freetype
	http://nongnu.askapache.com/freetype/freetype-2.3.9.tar.gz
gd
	http://www.libgd.org/releases/gd-2.0.35.tar.gz
jpeg
	ftp://ftp.uu.net/graphics/jpeg/jpegsrc.v6b.tar.gz
png
	ftp://ftp.simplesystems.org/pub/libpng/png/src/libpng-1.2.35.tar.gz
gettext
	http://ftp.gnu.org/pub/gnu/gettext/gettext-0.17.tar.gz
imap
	ftp://ftp.cac.washington.edu/imap/imap-2007e.tar.gz
<!-- # kerberos built in -->
ncurses
	ftp://ftp.gnu.org/pub/gnu/ncurses/ncurses-5.7.tar.gz
gmp
	ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.0.tar.gz
iconv
	http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.12.tar.gz
ldap
	ftp://ftp.openldap.org/pub/OpenLDAP/openldap-stable/openldap-stable-20090411.tgz
mysql
pdo_mysql
	http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/mysql-5.1.33.tar.gz
	42493187729677cf8f77faeeebd5b3c2
openssl
	http://www.openssl.org/source/openssl-0.9.8k.tar.gz
	http://www.openssl.org/source/openssl-0.9.8k.tar.gz.md5
pgsql
	ftp://ftp5.us.postgresql.org/pub/PostgreSQL/source/v8.3.7/postgresql-8.3.7.tar.gz
pspell
	ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.tar.gz
<!-- # xmlrpc built in -->
pcre
	ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.9.tar.gz
unixODBC
	http://www.unixodbc.org/unixODBC-2.2.14.tar.gz
xml
	ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/libxml2-2.6.30.tar.gz
<!-- # expat libraries not needed. built in. -->
<!-- # dom libraries not needed. built in. -->
xsl
	ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.1/libxslt-1.1.22.tar.gz
zlib
	http://www.zlib.net/zlib-1.2.3.tar.gz