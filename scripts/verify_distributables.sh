#!/bin/bash -e

python -m venv angr_venv
source angr_venv/bin/activate || source angr_venv/Scripts/activate

pip install sdist/*

python -c "import angr; print('angr imports!')"
