from dataclasses import dataclass
import os

import yaml

REPOS_CONFIG = os.path.join(
    os.path.dirname(os.path.realpath(__file__)), "..", "etc", "repos.yaml"
)


@dataclass
class Repo:
    name: str
    repo: str


def parse_repos(path):
    with open(path, "r") as f:
        raw = yaml.load(f, Loader=yaml.Loader)
    return [Repo(**r) for r in raw["repos"]]
