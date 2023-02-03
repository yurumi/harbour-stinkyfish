#!/usr/bin/env python3
import os, pathlib
import pytest

os.chdir(pathlib.Path.cwd() / 'tests')

pytest.main(args=['-s'])
