#!/usr/bin/env python
"""
Description

 Test the python versions available on the system

Note
 - works with python 2.7 and 3.5

Author
  David Laperriere <dlaperriere@outlook.com>

"""

from __future__ import print_function

import os
import sys
import unittest

sys.path.append(os.path.abspath(""))
sys.path.append(os.path.abspath("../"))

from utils import cmd

__version_info__ = (1, 0)
__version__ = '.'.join(map(str, __version_info__))
__author__ = "David Laperriere dlaperriere@outlook.com"

script_path = os.path.abspath("../")


class TestPython(unittest.TestCase):
    """ Test availability of python v2 & v3  """

    def test_python2(self):
        ok = cmd.can_run("python2 -V")
        self.assertTrue(ok)

    def test_python3(self):
        ok = cmd.can_run("python3 -V")
        self.assertTrue(ok)


if __name__ == "__main__":
    unittest.main()
    exit(0)
