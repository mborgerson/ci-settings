import subprocess

import yaml

from repos import parse_repos, REPOS_CONFIG


def checkout_repo(repo, commit):
    subprocess.run(f"git clone git@github.com:{repo.repo}.git {repo.name}".split())
    subprocess.run(f"git -C {repo.name} checkout {commit}")


def parse_commits(path):
    with open(path, "r") as f:
        return yaml.load(f.read(), Loader=yaml.Loader)


def main():
    repos = parse_repos(REPOS_CONFIG)
    commits = parse_commits("versions.yaml")

    for repo in repos:
        checkout_repo(repo, commit[repo.name])


if __name__ == "__main__":
    main()
