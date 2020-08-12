import os
import subprocess

import yaml

from repos import parse_repos, REPOS_CONFIG


def checkout_repo(repo, commit):
    if os.environ.get("DRY_RUN", True):
        clone_str = f"git clone https://github.com/{repo.repo}.git {repo.name}"
    else:
        clone_str = f"git clone git@github.com:{repo.repo}.git {repo.name}"
    subprocess.run(clone_str.split(), check=True)
    subprocess.run(f"git -C {repo.name} checkout {commit}", check=True)


def parse_commits(path):
    with open(path, "r") as f:
        return yaml.load(f.read(), Loader=yaml.Loader)


def main():
    repos = parse_repos(REPOS_CONFIG)
    commits = parse_commits("versions.yaml")

    for repo in repos:
        checkout_repo(repo, commits[repo.name])


if __name__ == "__main__":
    main()
