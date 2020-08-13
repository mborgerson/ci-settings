set -ex
source $(dirname $0)/vars.sh

for i in $REPOS; do
    if [ -e $CHECKOUT_DIR/$i/setup.py ]; then
        pushd $CHECKOUT_DIR/$i
        python setup.py sdist -d ../../sdist
        popd
    fi
done
