set -ex

python=python
source $(dirname $0)/vars.sh

source angr_venv/bin/activate
export PATH=$(pwd)/angr_venv/lib/*/site-packages:"$PATH"

angr_doc_rev="$(cat release.yml | grep angr-doc | cut -d ' ' -f2)"

mkdir -p $CHECKOUT_DIR
pushd $CHECKOUT_DIR

git clone git@github.com:angr/angr-doc.git angr-doc
git clone git@github.com:angr/angr.github.io.git angr.github.io
if [ "$DRY_RUN" == "false" ]; then
    git -C angr-doc fetch $angr_doc_rev
    git -C angr-doc reset --hard $angr_doc_rev
fi
angr_doc_version=$(sed -n -e "s/.*version = u'\(.\+\)'.*/\1/p" angr-doc/api-doc/source/conf.py)

make -C angr-doc/api-doc html
rm -rf angr.github.io/api-doc
cp -r angr-doc/api-doc/build/html angr.github.io/api-doc

pushd angr.github.io
git commit --author "angr release bot <angr-dev@asu.edu>" -m "update api-docs for version $angr_doc_version" api-doc
if [ "$DRY_RUN" == "false" ]; then
    git push origin master
fi
popd
popd
