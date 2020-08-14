set -ex

PYTHON=$1
SDIST_LOC=$(realpath $2)
VENV_PATH=$(realpath $3)

PACKAGES=$($PYTHON scripts/get_repo_names.py --python-only)
source $VENV_PATH/bin/activate || source $VENV_PATH/Scripts/activate

WHEELS=$(realpath wheels)
mkdir -p $WHEELS wheels_build
pushd wheels_build

for package in ${PACKAGES[@]}; do
    tar -xf $SDIST_LOC/$package*
    pushd $package*
    python setup.py bdist_wheel
    mv dist/* $WHEELS
    popd
done

popd
