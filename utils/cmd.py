"""
Utility methods used to run commands
"""
import os
import subprocess
import sys

__version_info__ = (1, 0)
__version__ = '.'.join(map(str, __version_info__))
__author__ = "David Laperriere dlaperriere@outlook.com"

__all__ = ['can_run', 'find_shell', 'on_windows', 'run']


def find_shell():
    """ Find current command shell  """
    cmd_shell = "?"
    if "ComSpec" in os.environ:
        cmd_shell = os.environ['ComSpec']

    if "SHELL" in os.environ:
        cmd_shell = os.environ['SHELL']
    return cmd_shell


def on_windows():
    """ Is the current operating system windows? """
    return sys.platform == 'win32'

def use_shell():
    if on_windows():
        return False
    return True

def can_run(cmd):
    """ Test a command """
   
    try:
        out = subprocess.check_call(cmd, shell=use_shell())
    except:
        return False
    return True


def run(cmd):
    """ Run a command and return output,status (0 ok, -1 error) """
    out = ""

    try:
        out = subprocess.check_output(cmd, universal_newlines=True, shell=use_shell())
    except:
        return (out, -1)
    return (out, 0)


def test():
    shell = find_shell()
    print(shell)
    print("Test", can_run("Test"))

if __name__ == '__main__':
    test()
