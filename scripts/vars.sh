VERSION_MAJOR=8
VERSION=$VERSION_MAJOR$(date +.%y.%m.%d | sed -e "s/\.0*/./g")
VERSION_TUPLE=$(awk -F '.' '{ printf "(%d, %d, %d, %d)\n", $1, $2, $3, $4}' <<< $VERSION)
REPOS=$(python scripts/get_repo_names.py)
CHECKOUT_DIR=repos
