# This script compiles the 'deploy.py' script into 'deploy.exe', which can be executed
# on computers where python is not installed.
#
# To compile 'deploy.py' into 'deploy.exe' you must have python installed on your system
# along with the following modules: GItPython, markdown, semantic_version, cx_Freeze.
#
# To install them run 'pip install GItPython markdown semantic_version cx_Freeze'.
#
# To compile the script enter this directory and run "python setupPyToExe.py build".

import cx_Freeze

executable = [cx_Freeze.Executable("deploy.py")]

cx_Freeze.setup(
    name = "downloads",
    options = {
        "build_exe": {
            "packages": [
                "sys",
                "os",
                "shutil",
                "git",
                "markdown",
                "semantic_version",
                "string",
                "subprocess"
            ],
            "include_files": []
        }
    },
    executables = executable
)