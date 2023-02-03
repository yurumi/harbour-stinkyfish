#!/usr/bin/env python3

import pytest
from unittest.mock import create_autospec

from file_database import FileDatabase
from node_cache import NodeCache
from node_manager import NodeManager


class StdLogger:

    def log(self, message):
        print(message)


@pytest.fixture
def mock_database():
    return create_autospec(spec=FileDatabase, spec_set=True)


@pytest.fixture
def mock_node_cache():
    return create_autospec(spec=NodeCache, spec_set=True)


@pytest.fixture
def sut(mock_database, mock_node_cache):
    return NodeManager(
        file_database=mock_database,
        node_cache=mock_node_cache,
        logger=StdLogger())


def test_init_root_node_when_root_does_not_exist_creates_node(
        sut, mock_database):
    mock_database.root_node_exists.return_value = False

    sut.init_root_node()

    mock_database.create_root_node.assert_called_once()


def test_init_root_node_when_root_does_exist_not_created_again(
        sut, mock_database):
    mock_database.root_node_exists.return_value = True

    sut.init_root_node()

    mock_database.create_root_node.assert_not_called()
