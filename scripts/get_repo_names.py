#!/usr/bin/env python3

from repos import parse_repos, REPOS_CONFIG

repos = parse_repos(REPOS_CONFIG)
print(" ".join([repo.name for repo in repos]))
