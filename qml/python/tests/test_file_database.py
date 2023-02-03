#!/usr/bin/env python3

import pytest
from unittest.mock import create_autospec

import os

from file_database import FileDatabase, FileIdGenerator


@pytest.fixture
def sut(fs):
    return FileDatabase()


def test_root_node_exists_when_not_existing_returns_false(sut, fs):
    expected = False

    result = sut.root_node_exists()

    assert expected == result


def test_root_node_exists_when_existing_returns_true(sut, fs):
    fs.create_file(os.path.join(FileDatabase.DATA_DIR, '00000000-0000-0000-0000-000000000000.org'))
    expected = True

    result = sut.root_node_exists()

    assert expected == result


def test_create_root_node(sut, fs):
    expected = os.path.join(FileDatabase.DATA_DIR, '00000000-0000-0000-0000-000000000000.org')

    sut.create_root_node()

    assert os.path.isfile(expected)
