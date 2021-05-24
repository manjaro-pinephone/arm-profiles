# Copyright 2021, laggardkernel and the ranger-fzf-marks contributors
# SPDX-License-Identifier: MIT

from __future__ import absolute_import, division, print_function
import os
from ranger.api.commands import Command


class FzfMarksBase(Command):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.fzf_cmd = os.environ.get("FZF_MARKS_CMD", "fzf")
        # https://github.com/urbainvaes/fzf-marks
        self.bookmark_file = os.environ.get("FZF_MARKS_FILE") or os.path.join(
            os.environ.get("HOME", os.path.expanduser("~")), ".fzf-marks"
        )


class fmark(FzfMarksBase):
    """
    :fmark <name>
    Mark the current directory with provided keyword
    """

    def execute(self):
        if not self.arg(1):
            self.fm.notify(
                "A keyword must be given for the current bookmark!", bad=True
            )
            return

        item = "{} : {}".format(self.arg(1), self.fm.thisdir.path)

        if not os.path.exists(self.bookmark_file):
            with open(self.bookmark_file, "a") as f:
                pass

        with open(self.bookmark_file, "r") as f:
            for line in f.readlines():
                if line.split(":")[1].strip() == self.fm.thisdir.path:
                    self.fm.notify(
                        "Fzf bookmark already exists: {}".format(line.strip()), bad=True
                    )
                    return

        with open(self.bookmark_file, "a") as f:
            f.write("{}{}".format(item, os.linesep))
            self.fm.notify("Fzf bookmark has been added: {}".format(item))


class dmark(FzfMarksBase):
    """
    dmark: delete current directory from fzf-marks file
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fzf_opts = os.environ.get(
            "FZF_DMARK_OPTS",
            "--cycle -m --ansi --bind=ctrl-o:accept,ctrl-t:toggle",
        )

    def execute(self):
        import subprocess

        items = None
        query = ""

        if self.arg(1):
            query = self.arg(1)

        if not os.path.exists(self.bookmark_file):
            self.fm.notify("No fzf bookmark is created yet!", bad=True)
            return

        # TODO: batch deletion
        command = '< "{2}" sort -f | {0} {1} --query="{3}"'.format(
            self.fzf_cmd, self.fzf_opts, self.bookmark_file, query
        )

        process = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = process.communicate()
        if process.returncode == 0:
            items = stdout.rstrip().split("\n")

        if not items:
            return

        with open(self.bookmark_file, "r") as f:
            lines = f.readlines()

        with open(self.bookmark_file, "w") as f:
            for line in lines:
                if line.strip() not in items:
                    f.write(line)

        self.fm.notify("Fzf bookmark is deleted: {}".format(", ".join(items)))


class fzm(FzfMarksBase):
    """
    fzm: select and jump to bookmark stored in fzf-marks
    """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fzf_opts = os.environ.get(
            "FZF_FZM_OPTS",
            "--cycle +m --ansi --bind=ctrl-o:accept,ctrl-t:toggle --select-1",
        )

    def execute(self):
        import subprocess

        target = None
        query = ""

        if self.arg(1):
            query = self.arg(1)

        if not os.path.exists(self.bookmark_file):
            self.fm.notify("No fzf bookmark is created yet!", bad=True)
            return

        command = '< "{2}" sort -f | {0} {1} --query "{3}"'.format(
            self.fzf_cmd, self.fzf_opts, self.bookmark_file, query
        )

        process = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = process.communicate()
        if process.returncode == 0:
            key, target = stdout.rstrip().split(" : ", 1)
            target = os.path.expanduser(target)

        if not target:
            return
        elif os.path.isdir(target):
            self.fm.cd(target)
        elif os.path.isfile(target):
            self.fm.select_file(target)
        else:
            self.fm.notify(
                "Invalid fzf bookmark location: {} : {}".format(key, target), True
            )
