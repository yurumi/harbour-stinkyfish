#!/usr/bin/env python3

import os
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


def test_create_org_string_when_children_not_empty(sut):
    sut.id = '1-2-3'
    sut.parent_id = '0-0-0'
    sut.type = 'test'
    sut.version = 1
    sut.title = 'test title'
    sut.child_ids = ['2-2-2', '3-3-3', '4-4-4']

    expected = ''.join([
        ':PROPERTIES:\n',
        f':ID: {sut.id}\n',
        f':PARENT_ID: {sut.parent_id}\n',
        f':TYPE: {sut.type}\n',
        f':VERSION: {sut.version}\n',
        ':END:\n',
        f'#+TITLE: {sut.title}\n',
        '* Children\n',
        '- 2-2-2\n',
        '- 3-3-3\n',
        '- 4-4-4\n',
        '\n'])

    result = sut.create_org_string()

    assert expected == result


def test_parse_data_when_header_data_valid(sut):
    data = {
        'id': '1-2-3', 'parent_id': '0-0-0', 'type': 'test', 'version': 2, 'title': 'check it out'}
    expected_id = '1-2-3'
    expected_type = 'test'
    expected_version = 2
    expected_title = 'check it out'

    sut.parse_data(data)

    assert expected_id == sut.id
    assert expected_type == sut.type
    assert expected_version == sut.version
    assert expected_title == sut.title


def test_parse_org_string_when_input_empty_throws(sut):
    data = ''
    with pytest.raises(ValueError):
        sut.parse_org_string(data)


def test_parse_org_string_parses_header(sut):
    data = ''.join([
        ':PROPERTIES:\n',
        ':ID: 1234\n',
        ':PARENT_ID: 0000\n',
        ':TYPE: test\n',
        ':VERSION: 33\n',
        ':END:\n',
        '#+TITLE: check it out\n',
        '* Children\n'])

    expected_id = '1234'
    expected_type = 'test'
    expected_version = 33
    expected_title = 'check it out'

    sut.parse_org_string(data)
    assert expected_id == sut.id
    assert expected_type == sut.type
    assert expected_version == sut.version
    assert expected_title == sut.title


@pytest.mark.parametrize(
    'data',
    ['#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:PARENT_ID: 0000\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:PARENT_ID: 0000\n:VERSION: 33\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:PARENT_ID: 0000\n:TYPE: test\n:END:\n#+TITLE: check it out\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:PARENT_ID: 0000\n:TYPE: test\n:VERSION: 33\n:END:\n* Children\n',
     ':PROPERTIES:\n:ID: 1234\n:PARENT_ID: 0000\n:TYPE: test\n:VERSION: 33\n:END:\n#+TITLE: check it out\n', ])
def test_parse_org_string_when_invalid_header_throws(sut, data):
    with pytest.raises(ValueError):
        sut.parse_org_string(data)


def test_parse_org_string_when_no_children_has_empty_child_ids(sut, org_valid_header, org_empty_children):
    data = org_valid_header + org_empty_children

    expected = []

    sut.parse_org_string(data)

    assert expected == sut.child_ids


def test_parse_org_string_parses_list_of_child_ids(sut, org_valid_header, org_dummy_children):
    data = org_valid_header + org_dummy_children

    expected = ['1-2-3', '2-3-4', '3-4-5']

    sut.parse_org_string(data)

    assert expected == sut.child_ids
