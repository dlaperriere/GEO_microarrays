"""
Utility methods used to run R scripts
"""
import os
import sys

sys.path.append(os.path.abspath(""))
sys.path.append(os.path.abspath("../"))

from utils import cmd

__version_info__ = (1, 0)
__version__ = '.'.join(map(str, __version_info__))
__author__ = "David Laperriere dlaperriere@outlook.com"

__all__ = ['findR', 'runR']


def findR():
    """
    Find path to R scripting front-end (Rscript)

    Try Rscript, $R_HOME, whereis Rscript and 
    HKLM\SOFTWARE\R-core\R*\InstallPath
    """
    R = None
    if cmd.can_run("Rscript --version"):
        R = "Rscript"
    else:
        if "R_HOME" in os.environ:
            R = os.path.join(os.environ['R_HOME'], "bin", "Rscript")
        else:
            if cmd.on_windows():
                reg_cmd = 'cmd /c %SystemRoot%\\system32\\reg.exe query HKLM\SOFTWARE\R-core /s /f InstallPath'
                reg_info, status = cmd.run(reg_cmd)
                # HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R64\3.2.5
                #    InstallPath    REG_SZ    C:\Program Files\R\R-3.2.5
                for line in reg_info.split('\n'):
                    if 'InstallPath' in line:
                        # ['', '', 'InstallPath', '', 'REG_SZ', '', 'C:\\Program Files\\R\\R-3.2.5']
                        R = os.path.join(line.split(
                            '  ')[-1], "bin", "Rscript")
            else:
                if cmd.can_run("whereis ls"):
                    whereis_info, status = cmd.run("whereis Rscript")
                    # Rscript: /usr/bin/Rscript /usr/bin/X11/Rscript
                    wrscript = whereis_info.split()
                    if len(wrscript) >= 2:
                        R = wrscript[1]
    return R


def runR(r=findR(), script="", args=""):
    """
    Run R script

        parameters
         - r: path to R scripting front-end  (Rscript)
         - script: R script filename
         - args: script parameters

        return
         - output,status (0=ok -1=error)
    """
    r_cmd = " ".join((r, script, args))
    print("\nrunning R cmd: {}\n".format(r_cmd))
    return cmd.run(r_cmd)


def test():
    r = findR()
    if r is None:
        print("Could not find R scripting front-end path (Rscript)")
        exit(-1)
    print("findR:", r)
    runR(r, "", "--version")

if __name__ == '__main__':
    test()
