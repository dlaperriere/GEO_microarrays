#!/usr/bin/env python
"""
Description

 Test analyze_geo_microarrays.R

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
from utils import r

__version_info__ = (1, 0)
__version__ = '.'.join(map(str, __version_info__))
__author__ = "David Laperriere dlaperriere@outlook.com"

script_path = os.path.abspath("./R/analyze_geo_microarrays.R")


class TestRAnalyzeGeo(unittest.TestCase):
    """ Test analyze_geo_microarrays.R   """

    def test_R(self):
        r_cmd = r.findR()
        ok = cmd.can_run("{} {} -h".format(r_cmd, script_path))
        self.assertTrue(ok)

if __name__ == "__main__":
    unittest.main()
    exit(0)
