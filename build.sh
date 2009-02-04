#!/bin/bash

cd /tmp
rm -rf uckbuild
mkdir uckbuild
cd uckbuild
svn co https://uck.svn.sourceforge.net/svnroot/uck/trunk/uck
cd uck
VERSION=`cat VERSION`

# renaming uck dir adding version
cd ..
mv uck uck-$VERSION
cd uck-$VERSION

# checking if version number has been updated everywhere
MAN_FILES=`ls docs/man/*.1 | wc -l`
MAN_FILES_WITH_VERSION=`grep $VERSION" docs/man/*.1 | wc -l`
if [ $MAN_FILES -ne $MAN_FILES_WITH_VERSION ]; then
	echo "ERROR: you've to update version numer in all man pages"
	exit
fi

if [ "`grep "$VERSION" debian/changelog | wc -l`" -eq "0" ]; then
	echo "ERROR: you've to update version numer in debian/changelog"
	exit
fi

# cleaning
rm -rf `find -name .svn`
rm -rf logo
rm -rf build.sh

# generating deb package
dpkg-buildpackage

# generating source package
rm -rf debian
cd ..
tar zcfp uck_$VERSION.tar.gz uck-$VERSION

# just a note
echo
echo
echo
echo "########################################################"
echo "# Generation completed, find packages in /tmp/uckbuild #"
echo "########################################################"
echo