# This script automates the deployment of a new version of Windows 10 Virtual Desktop Enhancer.

import os
import shutil
from git import Repo                    # pip install GItPython
from markdown import markdown           # pip install markdown
from semantic_version import Version    # pip install semantic_version
from string import Template
from subprocess import call

# Release folder (relative to the deploy-release folder)
release_folder = "./release"
# Source folder (relative to the deploy-release folder)
source_folder = ".."
project_repository = Repo(source_folder)
# These files should not be included in the release.
ignored_files = (".git", ".gitignore", "*.md", "deploy-release")

#
# 0) Verify that we currently are on the 'master' branch (to avoid accidental release of development branches).
#
current_branch = project_repository.active_branch.name
if (current_branch != "master"):
    print("!!! CAUTION !!!")
    print("It looks like you are building a release on branch '" + current_branch + "' instead of 'master'.")
    if input("Are you sure you want to proceed? [y/N] ").lower() != 'y':
        print("Automatic deployment interrupted successfully.")
        exit()
    else:
        print("Proceeding with automatic deployment on branch '" + current_branch + "'.")

#
# 1) Update the version number.
#
# Sort all the git tags by date and get the latest one.
latest_version_tag = str(sorted(project_repository.tags, key=lambda t: t.commit.committed_datetime)[-1])
# Check if the latest version is a valid semantic version.
try:
    latest_version = Version(latest_version_tag)
except ValueError as e:
    print("The latest version of the program (" + latest_version_tag + ") did not follow the correct naming convention. Unable to proceed with the automatic deployment.")
    exit()

# Ask for the new version number and verify that it is valid.
new_version = None
problem = ""
# Continue asking for a version number until the user provides a valid one.
while new_version is None:
    if (problem != ""):
        print("\nError: " + problem + "\n")
    new_version_tag = input("Latest version is '" + latest_version_tag + "'. Enter the new version number: ")
    try:
        new_version = Version(new_version_tag)
        if (new_version <= latest_version):
            new_version = None
            problem = "The version number must be greater than the latest one."
    except ValueError as e:
        new_version = None
        problem = "The version number '" + new_version_tag + "' is not valid."

#
# 2) Clear the release folder.
#
if os.path.exists(release_folder):
    shutil.rmtree(release_folder)

#
# 3) Copy all the pertinent files into the release folder.
#
shutil.copytree(
    source_folder,
    release_folder,
    False,
    shutil.ignore_patterns(
        '*.md',             # Ignore Markdown files.
        '.git',             # Ignore .git folder
        'deploy-release'    # Do not copy deploy-release into itself.
    )
)

#
# 4) Convert documentation from Markdown to HTML.
#
# Load the HTML template from file.
with open('html_template.html', 'r', encoding="utf-8") as html_template_file:
    html_template = Template(html_template_file.read())
# Locate all the Markdown files in the folder.
for root, dirs, files in os.walk(source_folder):
    for fileName in files:
        if (fileName.endswith(".md")):
            file_path = (root.replace(source_folder, "") + '\\' + fileName)
            with open(source_folder + file_path, 'r', encoding="utf-8") as md_file:
                # Replace references to Markdown files with HTML files.
                body = md_file.read().replace(".md", ".html")
            # Convert Markdown to HTML.
            body = markdown(
                body,
                extensions = [
                    "markdown.extensions.fenced_code",  # Enable code blocks.
                    "markdown.extensions.tables",       # Enable tables.
                    "markdown.extensions.nl2br",        # Enable line breaks.
                    "markdown.extensions.toc"           # Enable links and anchors.
                ]
            )
            # Fill in the HTML template.
            final_html = html_template.substitute(title=fileName[:-3], body=body)
            # Write the HTML file.
            html_file_path = release_folder + file_path[:-3] + ".html"
            if not os.path.exists(os.path.dirname(html_file_path)):
                os.makedirs(os.path.dirname(html_file_path))
            with open(html_file_path,"w", encoding="utf-8") as out_file:
                out_file.write(final_html)

#
# 5) Create the final zip file from the copied files.
#
shutil.make_archive('Windows.10.Virtual.Desktop.Enhancer.' + new_version_tag, 'zip', release_folder)

#
# 6) Ask the user if he wants to see the diff from last version.
#

if input("Do you want to see the diff with the previous release? [y/N] ").lower() == 'y':
    call(['git', "diff", latest_version_tag])

print("Done!")