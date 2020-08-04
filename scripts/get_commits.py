from dataclasses import dataclass
import os

from github import Github
import yaml

GH_ACCESS_TOKEN = os.getenv("GH_ACCESS_TOKEN")


@dataclass
class Repo:
    name: str
    repo: str


def parse_repos(path):
    with open(path, "r") as f:
        raw = yaml.load(f, Loader=yaml.Loader)
    return [Repo(**r) for r in raw["repos"]]


def get_latest_commit(gh, repo):
    gh_repo = gh.get_repo(repo.repo)
    branch = gh_repo.get_branch(gh_repo.default_branch)
    return branch.commit.sha


def main():
    if GH_ACCESS_TOKEN:
        gh = Github(GH_ACCESS_TOKEN)
    else:
        gh = Github()

    config_file = os.path.join(os.path.dirname(os.path.realpath(__file__)), "..", "repos.yaml")
    repos = parse_repos(config_file)
    version_dict = { r.name: get_latest_commit(gh, r) for r in repos}

    with open("versions.yaml", "w") as f:
        f.write(yaml.dump(version_dict, Dumper=yaml.Dumper))


if __name__ == "__main__":
    main()
