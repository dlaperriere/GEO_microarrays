#!/usr/bin/env python
"""
Description

 Test analyze_geo_microarrays.py

Note
 - works with python 2.7 and 3.5

Author
  David Laperriere <dlaperriere@outlook.com>

"""

from __future__ import print_function

import os
import shutil
import sys
import unittest

sys.path.append(os.path.abspath(""))
sys.path.append(os.path.abspath("../"))

from utils import cmd

__version_info__ = (1, 0)
__version__ = '.'.join(map(str, __version_info__))
__author__ = "David Laperriere dlaperriere@outlook.com"

script_path = os.path.abspath("./analyze_geo_microarrays.py")


class TestPythonAnalyzeGeo(unittest.TestCase):
    """ Test analyze_geo_microarrays.py v3  """

    def test_python(self):
        ok = cmd.can_run("python {} -h".format(script_path))
        self.assertTrue(ok)

    def test_python3(self):
        ok = cmd.can_run("python3 {} -h".format(script_path))
        self.assertTrue(ok)

    def test_example_bad(self):
        """ test example with R error"""
        sample_file = os.path.join("test", "bad.samples.txt")
        analysis_file = os.path.join("test", "bad.analysis.txt")
        shutil.copyfile(sample_file, "bad.samples.txt")
        out, status = cmd.run(
            "python {} -g {}".format(script_path, analysis_file))
        os.unlink("bad.samples.txt")
        self.assertEqual(status, -1)

    def test_example_GSE8597(self):
        """ test GSE8597 example """
        sample_file = os.path.join("test", "MCF7_E2_CHX.GSE8597.samples.txt")
        analysis_file = os.path.join(
            "test", "MCF7_E2_CHX.GSE8597.analysis.txt")
        shutil.copyfile(sample_file, "MCF7_E2_CHX.GSE8597.samples.txt")
        out, status = cmd.run(
            "python {} -g {}".format(script_path, analysis_file))
        os.remove("MCF7_E2_CHX.GSE8597.samples.txt")
        self.assertEqual(status, 0)

        # excel file created
        excel_file = "DiffExpression.GSE8597.xlsx"
        statinfo = os.stat(excel_file)
        self.assertTrue(statinfo.st_size != 0)
        os.remove(excel_file)

if __name__ == "__main__":
    unittest.main()
    exit(0)
