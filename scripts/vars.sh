VERSION_MAJOR=9
VERSION_MINOR=0
VERSION=$VERSION_MAJOR.$VERSION_MINOR.$BUILD_BUILDID
VERSION_TUPLE=$(awk -F '.' '{ printf "(%d, %d, %d)\n", $1, $2, $3}' <<< $VERSION)
REPOS=$($python scripts/get_repo_names.py)
CHECKOUT_DIR=repos
