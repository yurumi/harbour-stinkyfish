#!/usr/bin/env python3

import pytest
from unittest.mock import create_autospec

import os

from file_database import FileDatabase
from node_cache import NodeCache
from node_manager import NodeManager


class StdLogger:

    def log(self, message):
        print(message)


@pytest.fixture
def mock_send_fcn():
    def fcn(signal_name, data):
        print(f'{signal_name}:\t{data}')

    return fcn


@pytest.fixture
def mock_database():
    return create_autospec(spec=FileDatabase, spec_set=True)


@pytest.fixture
def mock_node_cache():
    return create_autospec(spec=NodeCache, spec_set=True)


@pytest.fixture
def sut(mock_database, mock_node_cache, mock_send_fcn):
    return NodeManager(
        file_database=mock_database,
        node_cache=mock_node_cache,
        logger=StdLogger(),
        send_fcn=mock_send_fcn)


def test_init_root_node_when_root_does_not_exist_creates_node(
        sut, fs, mock_database):
    mock_database.root_node_exists.return_value = False

    sut.init_root_node()

    mock_database.save_to_file.assert_called_once()
