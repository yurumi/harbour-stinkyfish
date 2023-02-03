#!/usr/bin/env python3

import pytest


@pytest.fixture
def std_org_header():
    return ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n'
