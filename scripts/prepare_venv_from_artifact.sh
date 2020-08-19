set -ex

PYTHON=$1
SDIST_LOC=$2
VENV_PATH=$3

PACKAGES=($($PYTHON scripts/get_repo_names.py --python-only | sed -E "s#-#_#g s#([[:alnum:]_]+)#$SDIST_LOC/\1*#g"))
$PYTHON -m venv $VENV_PATH
source $VENV_PATH/bin/activate &> /dev/null || source $VENV_PATH/Scripts/activate
python -m pip install --upgrade pip wheel
python -m pip install "${PACKAGES[@]}"
