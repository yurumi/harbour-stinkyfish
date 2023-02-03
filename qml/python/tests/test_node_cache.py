#!/usr/bin/env python3

import pytest
from pytest_mock import mocker

from node_cache import NodeCache
from file_database import FileDatabase


@pytest.fixture
def sut():
    mocker.patch.object()
    ret = NodeCache()
    ret.set_file_database(mock_file_database)
    return ret


@pytest.mark.skip
def test_(sut):
    assert False
