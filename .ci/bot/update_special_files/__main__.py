#!/usr/bin/env python3

from pathlib import Path
import os
import sys

from gitlab.exceptions import GitlabGetError
import gitlab as gl
import click

from .exceptions import (
    RequiredEnvVarNotFound,
    MergeRequestNotYetApproved,
    MergeRequestAlreadyApprovedByBotMarvin
)
from .renderers import Paths, AuthorsRenderer, ChangeLogRenderer, ReadMeRenderer


@click.command()
@click.argument("repository_path", type=click.Path(resolve_path=True))
def cli(repository_path):

    # Grab required environment variables.
    project_id = os.environ.get("CI_PROJECT_ID", None)
    if project_id is None :
        raise RequiredEnvVarNotFound("CI_PROJECT_ID")
    merge_request_iid = os.environ.get("MERGE_REQUEST_IID", None)
    if merge_request_iid is None :
        raise RequiredEnvVarNotFound("MERGE_REQUEST_IID")
    reporter_bot_private_token = os.environ.get("REPORTER_BOT_ACCESS_TOKEN", None)
    if reporter_bot_private_token is None :
        raise RequiredEnvVarNotFound("REPORTER_BOT_ACCESS_TOKEN")

    # Validate merge request approvals before updating special files:
    # * Exit when not approved by anyone.
    # * Exit when already approved by bot_marvin, meaning special files have already been updated.
    gitlab = gl.Gitlab("https://gitlab.com", private_token=reporter_bot_private_token)
    project = gitlab.projects.get(project_id)
    merge_request = project.mergerequests.get(merge_request_iid)
    approvals = merge_request.approvals.get()
    if not approvals.approved_by:
        raise MergeRequestNotYetApproved(merge_request_iid)
    for approver in approvals.approved_by:
        if approver["user"]["username"] == "bot_marvin":
            raise MergeRequestAlreadyApprovedByBotMarvin()

    # Define paths to templates and renderings.
    templates_path = Path(sys.argv[0]).parent.joinpath("templates")
    repository_path = Path(repository_path)
    paths = Paths(templates_path, repository_path)

    # Render the templates.
    renderers = []
    contributors = project.repository_contributors()
    renderers.append(AuthorsRenderer(paths, contributors))
    milestone = merge_request.milestone
    renderers.append(ChangeLogRenderer(paths, milestone, merge_request))
    if milestone: renderers.append(ReadMeRenderer(paths, milestone))
    renderings_paths = []
    for renderer in renderers:
        renderer.render()
        renderer.write()
        renderings_paths.append(renderer.rendering_path)

    # Prepare the commit.
    special_files_commit = {
        "branch": merge_request.source_branch,
        "commit_message": "Update special files",
        "actions": []
    }
    for rendering_path in renderings_paths:
        action = {
            "file_path": str(rendering_path.relative_to(repository_path)),
            "content": open(rendering_path, "rt").read()
        }
        try:
            f = project.files.get(rendering_path.name, ref=merge_request.source_branch)
        except GitlabGetError as e:
            if e.response_code != 404:
                raise(e)
            else:
                action["action"] = "create"
        else:
            action["action"] = "update"
        finally:
            special_files_commit["actions"].append(action)

    # Commit and approve.
    project.commits.create(special_files_commit)
    merge_request.approve()

if __name__ == "__main__":
    try:
        cli()
    except RequiredEnvVarNotFound as e:
        raise(e)
    except (MergeRequestNotYetApproved, MergeRequestAlreadyApprovedByBotMarvin) as e:
        print(e)
