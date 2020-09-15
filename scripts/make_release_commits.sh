#!/bin/bash
set -ex

python=python
source "$(dirname "$0")/vars.sh"

for i in $REPOS; do
    pushd "$CHECKOUT_DIR/$i"

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
    elif [ "$i" == "angr-doc" ]; then
        sed -i -e "s/version = u['\"][^'\"]*['\"]/version = u'$VERSION'/g" api-doc/source/conf.py
        sed -i -e "s/release = u['\"][^'\"]*['\"]/release = u'$VERSION'/g" api-doc/source/conf.py
    else
        popd
        continue
    fi

    # Commit and push to github
    git checkout -q -b "release/$VERSION"
    git add --all
    git commit -m "Update version to $VERSION"
    git tag -a "v$VERSION" -m "release version $VERSION"
    popd
done
