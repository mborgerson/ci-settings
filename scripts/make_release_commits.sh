#!/bin/bash

set -e
set -x

VERSION_MAJOR=8
VERSION=$VERSION_MAJOR$(date +.%y.%m.%d | sed -e "s/\.0*/./g")
VERSION_TUPLE=$(awk -F '.' '{ printf "(%d, %d, %d, %d)\n", $1, $2, $3, $4}' <<< $VERSION)

REPOS=$(python scripts/get_repo_names.py)

CHECKOUT_DIR=repos

for i in $REPOS; do
    pushd $CHECKOUT_DIR/$i

    if [ ! -e setup.py ]; then
        popd
        continue
    fi

    # Replace version in setup.py
    sed -i -e "s/version=['\"][^'\"]*['\"]/version='$VERSION'/g" setup.py
    # Replace version in __init__.py
    sed -i -e "s/^__version__ = .*/__version__ = $VERSION_TUPLE/g" ./*/__init__.py

    for j in $REPOS; do
        if [ "$i" == "$j" ]; then
            continue;
        fi

        # Replace dependency versions in setup.py
        sed -i -e "s/'$j\(\(==[^']*\)\?\)',\$/'$j==$VERSION',/" setup.py
    done

    popd
done

# Update angr-doc versions
sed -i -e "s/version = u['\"][^'\"]*['\"]/version = u'$VERSION'/g" $CHECKOUT_DIR/angr-doc/api-doc/source/conf.py
sed -i -e "s/release = u['\"][^'\"]*['\"]/release = u'$VERSION'/g" $CHECKOUT_DIR/angr-doc/api-doc/source/conf.py

# Commit and push to github
git config --global user.name "angr release bot"
git config --global user.email "angr@lists.cs.ucsb.edu"
for i in $REPOS; do
    pushd $CHECKOUT_DIR/$i

    git checkout -b release/$VERSION
    git add --all
    git commit -m "Update version to $VERSION"
    git tag -a v$VERSION -m "release version $VERSION"
    if ! $DRY_RUN; then
        git push origin release/$VERSION
        git push origin v$VERSION
    fi

    popd
done

# Create source distributions
for i in $REPOS; do
    python $CHECKOUT_DIR/$i/setup.py sdist -d sdist
done
