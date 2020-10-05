from datetime import date
import re

from jinja2 import Template
from bs4 import Tag
import bs4
import mistune

class Paths:
    def __init__(self, templates, renderings):
        self.templates = templates
        self.renderings = renderings

class Renderer:
    def __init__(self, paths, filename):
        self.template_path = paths.templates.joinpath(f"{filename}.md.j2")
        self.rendering_path = paths.renderings.joinpath(f"{filename}.md")
        with open(self.template_path, "rt") as f:
            self.template = Template(f.read())
        self.rendering = None

    def write(self):
        with open(self.rendering_path, "wt") as f:
            f.write(self.rendering)


class AuthorsRenderer(Renderer):
    contributors_details = [
        {
            "name": "flow.gunso",
            "details": "author"
        }
    ]

    def __init__(self, paths, contributors):
        super().__init__(paths, "AUTHORS")
        self.contributors = contributors

    def _prepare(self):
        for contributor in self.contributors:
            for contributor_details in self.contributors_details:
                if contributor["name"] == contributor_details["name"]:
                    contributor["details"] = contributor_details["details"]

    def render(self):
        self._prepare()
        self.rendering = self.template.render(
            contributors=self.contributors
        )


class ChangeLogRenderer(Renderer):
    def __init__(self, paths, milestone, merge_request):
        super().__init__(paths, "CHANGELOG")
        self.milestone = milestone
        self.merge_request = merge_request

    def _prepare(self):
        self.date = date.today()

        self.changes = {}
        # Scrap from the current CHANGELOG the unreleased changes, if any.
        with open(self.rendering_path, "rt") as f:
            previous_changelog_html = mistune.markdown(f.read())
        soup = bs4.BeautifulSoup(previous_changelog_html, "html.parser")
        first_header = soup.find("h1")
        if first_header.string == "Unreleased":
            self.changes["Unreleased"] = {}
            for next_sibling in first_header.next_siblings:
                if next_sibling.name == "h1":
                    break
                elif next_sibling.name == "h2":
                    type_of_changes = next_sibling.string
                    self.changes["Unreleased"][type_of_changes] = []
                elif next_sibling.name == "ul":
                    for item in next_sibling.children:
                        if isinstance(item, Tag):
                            self.changes["Unreleased"][type_of_changes].append(item.string)

        self.target = self.milestone["title"] if self.milestone else "Unreleased"
        if "Unreleased" in self.changes and self.target != "Unreleased":
            self.changes[self.target] = self.changes.pop("Unreleased")
        else:
            self.changes[self.target] = {}

        for label in self.merge_request.labels:
            if "::" in label:
                type_of_change = label.split("::")[1].title()
                if type_of_change not in self.changes[self.target]:
                    self.changes[self.target][type_of_change] = [] 
        for commit in self.merge_request.commits():
            if commit.committer_name != "bot_marvin":
                self.changes[self.target][type_of_change].append(commit.message)

        self.changes = self.changes[self.target]

    def render(self):
        self._prepare()
        self.rendering = self.template.render(
            target=self.target,
            changes=self.changes,
            date=self.date
        )


class ReadMeRenderer(Renderer):
    def __init__(self, paths, milestone):
        super().__init__(paths, "README")
        self.milestone = milestone

    def _prepare(self):
        """Pattern is from https://github.com/semver/semver/issues/232#issuecomment-546728483"""
        semver_pattern = re.compile(r"^(?P<major>0|[1-9]\d*)\.(?P<minor>0|[1-9]\d*)\.(?P<patch>0|[1-9]\d*)(?:-(?P<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$")
        for match in re.finditer(semver_pattern, self.milestone["title"]):
            self.major = match["major"]
            self.minor = match["minor"]
            self.patch = match["patch"]
            self.pre_release = match["prerelease"]
            self.build_metadata = match["buildmetadata"]

    def render(self):
        self._prepare()
        self.rendering = self.template.render(
            semver=self.milestone["title"],
            major=self.major,
            minor=".".join([self.major, self.minor]),
            patch=".".join([self.major, self.minor, self.patch])
        )
