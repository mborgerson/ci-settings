#!/bin/bash
set -ex

VERSION_MAJOR=8
VERSION=$VERSION_MAJOR$(date +.%y.%m.%d | sed -e "s/\.0*/./g")
VERSION_TUPLE=$(awk -F '.' '{ printf "(%d, %d, %d, %d)\n", $1, $2, $3, $4}' <<< $VERSION)
REPOS=$(python scripts/get_repo_names.py)
CHECKOUT_DIR=repos

git config --global user.name "angr release bot"
git config --global user.email "angr@lists.cs.ucsb.edu"

for i in $REPOS; do
    pushd $CHECKOUT_DIR/$i

    if [ -e setup.py ]; then
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
        # continue
    elif [ $i == "angr-doc" ]; then
        sed -i -e "s/version = u['\"][^'\"]*['\"]/version = u'$VERSION'/g" api-doc/source/conf.py
        sed -i -e "s/release = u['\"][^'\"]*['\"]/release = u'$VERSION'/g" api-doc/source/conf.py
    else
        popd
        continue
    fi

    # Commit and push to github
    git checkout -q -b release/$VERSION
    git add --all
    git commit -m "Update version to $VERSION"
    git tag -a v$VERSION -m "release version $VERSION"
    popd
done

# Push to github
if ! $DRY_RUN; then
    for i in $REPOS; do
        git -C $CHECKOUT_DIR/$i push origin release/$VERSION
        git -C $CHECKOUT_DIR/$i push origin v$VERSION
    done
fi

# Create source distributions
for i in $REPOS; do
    if [ -e $CHECKOUT_DIR/$i/setup.py ]; then
        pushd $CHECKOUT_DIR/$i
        python setup.py sdist -d ../../sdist
        popd
    fi
done
