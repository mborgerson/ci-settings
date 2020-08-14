set -ex

PYTHON=$1
SDIST_LOC=$2
VENV_PATH=$3

PACKAGES=$($PYTHON scripts/get_repo_names.py --python-only)
source $VENV_PATH/bin/activate || source $VENV_PATH/Scripts/activate

mkdir -p wheels
for package in ${PACKAGES[@]}; do
    tar -xf $SDIST_LOC/$package*
    pushd dist/$package
    python setup.py bdist_wheel
    mv dist/* ../../wheels
    popd
done
