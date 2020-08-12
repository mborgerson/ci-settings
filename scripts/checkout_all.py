import os
import subprocess

import yaml

from repos import parse_repos, REPOS_CONFIG


def checkout_repo(dir, repo, commit):
    checkout_dir = os.path.join(dir, repo.name)
    if os.environ.get("DRY_RUN", True):
        clone_str = f"git clone https://github.com/{repo.repo}.git {checkout_dir}"
    else:
        clone_str = f"git clone git@github.com:{repo.repo}.git {checkout_dir}"
    subprocess.run(clone_str.split(), check=True).check_returncode()
    subprocess.run(
        f"git -C {checkout_dir} checkout {commit}", check=True
    ).check_returncode()


def parse_commits(path):
    with open(path, "r") as f:
        return yaml.load(f.read(), Loader=yaml.Loader)


def main():
    repos = parse_repos(REPOS_CONFIG)
    commits = parse_commits("versions.yaml")

    os.mkdir("repos")

    for repo in repos:
        checkout_repo("repos", repo, commits[repo.name])


if __name__ == "__main__":
    main()
