#!/bin/bash

VERSION_MAJOR=8
VERSION=$VERSION_MAJOR$(date +.%y.%m.%d | sed -e "s/\.0*/./g")

REPOS=${REPOS-archinfo vex pyvex cle claripy angr angr-management angrop angr-doc ailment}

for i in $REPOS; do
    if [ ! -e $i/setup.py ]; then
        continue
    fi

    # Replace version in setup.py
    sed -i -e "s/version=['\"][^'\"]*['\"]/version='$VERSION'/g" $i/setup.py
    # Replace version in __init__.py
    sed -i -e "s/^__version__ = .*/__version__ = $(version_to_tuple $VERSION)/g" $i/*/__init__.py

    for j in $REPOS; do
        if [ "$i" == "$j" ]; then
            continue;
        fi

        # Replace dependency versions in setup.py
        sed -i -e "s/'$j\(\(==[^']*\)\?\)',\$/'$j==$VERSION',/" $i/setup.py
    done
done

# Update angr-doc versions
sed -i -e "s/version = u['\"][^'\"]*['\"]/version = u'$VERSION'/g" angr-doc/api-doc/source/conf.py
sed -i -e "s/release = u['\"][^'\"]*['\"]/release = u'$VERSION'/g" angr-doc/api-doc/source/conf.py

# Commit and push to github
git config --global user.name "angr release bot"
git config --global user.email "angr@lists.cs.ucsb.edu"
for i in $REPOS; do
    git checkout -b release/$VERSION
    git -c $i commit -m "Update version to $VERSION"
    git tag -a v$VERSION -m "release version $VERSION"
    if ! $DRY_RUN; then
        git push origin release/$VERSION
        git push origin v$VERSION
    fi
done

# Create source distributions
for i in $REPOS; do
    python $i/setup.py sdist -d sdist
done
