#!/usr/bin/env python3

import pytest

import os

from node import Node
from file_database import FileDatabase


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


def test_save_to_file_when_output_file_given(sut, fs):
    node = Node()
    output_filename = 'check.org'
    sut.save_to_file(node, output_filename)
    assert os.path.isfile(output_filename)


def test_save_to_file_when_no_output_file_given_then_id_as_filename(sut, fs):
    node = Node()
    node.id = '1-2-3'
    expected = os.path.join(FileDatabase.DATA_DIR, node.id + '.org')
    sut.save_to_file(node)
    assert os.path.isfile(expected)


# @pytest.mark.parametrize(
#     'input_file, output_file',
#     [('test_1.org', '/tmp/test_1.org'),
#      ('test_2.org', '/tmp/test_2.org')])
def test_save_to_file_does_not_alter_content(sut, mocker):
    output_file = '/tmp/test.org'

    org_string = ''.join([
        ':PROPERTIES:\n',
        ':ID: 1-2-3\n',
        ':TYPE: test\n',
        ':VERSION: 22\n',
        ':END:\n',
        '#+TITLE: check it out\n',
        '* Children\n',
        '- [[2-3-4]]\n',
        '- [[3-4-5]]\n'])

    node = Node()
    mocker.patch.object(node, 'create_org_string')
    node.create_org_string.return_value = org_string

    sut.save_to_file(node, output_file)

    assert [row + "\n" for row in org_string.split("\n")][:-1] == [row for row in open(output_file)]


def test_load_org_string_by_id_when_file_exists(sut, fs, org_valid_header):
    node_id = '1-2-3'
    filename = FileDatabase().create_filename_from_id(node_id)
    with open(filename, mode='w') as out_file:
        out_file.write(org_valid_header)

    result = sut.load_org_string_by_id(node_id)

    assert org_valid_header == result
