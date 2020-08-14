set -ex

PYTHON=$1
SDIST_LOC=$2
VENV_PATH=$3

PACKAGES=$($PYTHON scripts/get_repo_names.py --python-only | sed -E "s/([[:alnum:]-]+)/$SDIST_LOC\/\1*/g")
$PYTHON -m venv $VENV_PATH
source $VENV_PATH/bin/activate || source $VENV_PATH/Scripts/activate
pip install --upgrade pip wheel
pip install $PACKAGES
