set -ex

# Apple doesn't incluide realpath
function realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

python=$1
sdist_path=$(realpath $2)
venv_path=$(realpath $3)

packages=$($python scripts/get_repo_names.py --python-only)
source $venv_path/bin/activate &> /dev/null || source $venv_path/Scripts/activate

wheels=$(realpath wheels)
mkdir -p $wheels wheels_build
pushd wheels_build

for package in ${packages[@]}; do
    tar -xf $sdist_path/$package-$VERSION_MAJOR*
    pushd $package-$VERSION_MAJOR*
    python setup.py bdist_wheel
    mv dist/* $wheels
    popd
done

popd
