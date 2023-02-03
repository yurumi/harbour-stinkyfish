#!/usr/bin/env python3

import pytest

from node import Node


@pytest.fixture
def sut():
    return Node()


@pytest.mark.parametrize(
    'data',
    [{},
     {'type': 'test', 'version': 2, 'title': 'check it out'},
     {'id': '1-2-3', 'version': 2, 'title': 'check it out'},
     {'id': '1-2-3', 'type': 'test', 'title': 'check it out'},
     {'id': '1-2-3', 'type': 'test', 'version': 2}, ])
def test_create_org_string_from_data_when_header_data_invalid_throws(sut, data):
    with pytest.raises(ValueError):
        sut.create_org_string_from_data(data)


def test_parse_data_when_header_data_valid(sut):
    data = {'id': '1-2-3', 'type': 'test', 'version': 2, 'title': 'check it out'}
    expected_id = '1-2-3'
    expected_type = 'test'
    expected_version = 2
    expected_title = 'check it out'

    sut.parse_data(data)

    assert expected_id == sut.id
    assert expected_type == sut.type
    assert expected_version == sut.version
    assert expected_title == sut.title


def test_parse_string_when_input_empty_throws(sut):
    data = ''
    with pytest.raises(ValueError):
        sut.parse_string(data)


def test_parse_string_parses_header(sut):
    data = ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n'
    expected_id = '1234'
    expected_type = 'test'
    expected_version = 33
    expected_title = 'check it out'

    sut.parse_string(data)
    assert expected_id == sut.id
    assert expected_type == sut.type
    assert expected_version == sut.version
    assert expected_title == sut.title


@pytest.mark.parametrize(
    'data',
    ['#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n', ])
def test_parse_string_when_invalid_header_throws(sut, data):
    with pytest.raises(ValueError):
        sut.parse_string(data)


@pytest.mark.parametrize(
    'data',
    [':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children'])
def test_get_child_ids_when_no_children_returns_empty_list(sut, data):
    sut.parse_string(data)

    expected = []

    result = sut.get_child_ids()

    assert expected == result


def test_get_child_ids_returns_list_with_children(sut):
    data = ':PROPERTIES:\n:ID: 1234\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n- 1-2-3\n- 2-3-4\n - 3-4-5\n'
    sut.parse_string(data)

    expected = ['1-2-3', '2-3-4', '3-4-5']

    result = sut.get_child_ids()

    assert expected == result
