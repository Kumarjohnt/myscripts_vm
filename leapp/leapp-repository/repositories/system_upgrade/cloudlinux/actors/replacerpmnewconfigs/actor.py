from __future__ import print_function
import os
import fileinput

from leapp.actors import Actor
from leapp.tags import FirstBootPhaseTag, IPUWorkflowTag
from leapp import reporting
from leapp.libraries.common.cllaunch import run_on_cloudlinux

REPO_DIR = '/etc/yum.repos.d'
CL_MARKERS = ['cloudlinux', 'imunify']
RPMNEW = '.rpmnew'
LEAPP_BACKUP_SUFFIX = '.leapp-backup'


class ReplaceRpmnewConfigs(Actor):
    """
    Replace CloudLinux-related repository config .rpmnew files.
    """

    name = 'replace_rpmnew_configs'
    consumes = ()
    produces = ()
    tags = (FirstBootPhaseTag, IPUWorkflowTag)

    @run_on_cloudlinux
    def process(self):
        renamed_repofiles = []

        for reponame in os.listdir(REPO_DIR):
            if any(mark in reponame for mark in CL_MARKERS) and RPMNEW in reponame:
                base_reponame = reponame[:-7]
                base_path = os.path.join(REPO_DIR, base_reponame)
                new_file_path = os.path.join(REPO_DIR, reponame)
                backup_path = os.path.join(REPO_DIR, base_reponame + LEAPP_BACKUP_SUFFIX)

                os.rename(base_path, backup_path)
                os.rename(new_file_path, base_path)
                renamed_repofiles.append(base_reponame)

        for reponame in os.listdir(REPO_DIR):
            if LEAPP_BACKUP_SUFFIX in reponame:
                repofile_path = os.path.join(REPO_DIR, reponame)
                for line in fileinput.input(repofile_path, inplace=True):
                    if line.startswith('enabled'):
                        print("enabled = 0")
                    else:
                        print(line, end='')

        if renamed_repofiles:
            replaced_string = '\n'.join(['- {}'.format(repofile_name) for repofile_name in renamed_repofiles])
            reporting.create_report([
                reporting.Title('CloudLinux repository config files replaced by updated versions'),
                reporting.Summary(
                    'One or more RPM repository configuration files related to CloudLinux '
                    'have been replaced with new versions provided by the upgraded packages. '
                    'Any manual modifications to these files have been overriden by this process. '
                    'Old versions of files were backed up to files with a naming pattern '
                    '<repository_file_name>.leapp-backup. '
                    'Replaced repository files: \n{}'.format(replaced_string)
                ),
                reporting.Severity(reporting.Severity.MEDIUM),
                reporting.Tags([reporting.Tags.UPGRADE_PROCESS])
            ])
