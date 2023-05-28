#!/usr/bin/env python3

import pytest

from PyOrgMode import OrgDataStructure


@pytest.fixture
def sut():
    return OrgDataStructure()

@pytest.mark.skip
@pytest.mark.parametrize(
    'input_file, output_file',
    [('test_1.org', '/tmp/test_1.org'),
     ('test_2.org', '/tmp/test_2.org')])
def test_load_save_does_not_alter_contents(sut, input_file, output_file):
    sut.load_from_file(input_file)
    sut.save_to_file(output_file)

    assert [row for row in open(input_file)] == [row for row in open(output_file)]
