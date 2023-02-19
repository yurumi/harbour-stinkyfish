#!/usr/bin/env python3

import pytest

from note_node import NoteNode
from todo_node import TodoNode
from node_factory import NodeFactory


@pytest.fixture
def sut():
    return NodeFactory()


def test_create_root_node(sut):
    result = sut.create_root_node()

    assert result.type == 'root'
    assert result.id == '00000000-0000-0000-0000-000000000000'
    assert result.org_data is not None


def test_create_node_from_data_when_note_node(sut, node_data_template):
    node_data_template['type'] = NoteNode.TYPE
    node_data_template['description'] = 'desc'

    expected_title = 'check it out'

    result = sut.create_node_from_data(node_data_template)

    assert type(result) is NoteNode
    assert expected_title == result.title
    assert result.org_data is not None


def test_create_node_from_data_when_todo_node(sut, node_data_template):
    node_data_template['type'] = TodoNode.TYPE
    node_data_template['description'] = 'desc'

    expected_title = 'check it out'

    result = sut.create_node_from_data(node_data_template)

    assert type(result) is TodoNode
    assert expected_title == result.title
    assert result.org_data is not None


def test_create_node_from_org_string_when_note_node(sut, org_valid_header, org_empty_children):
    org_valid_header = org_valid_header.replace(':TYPE: test', f':TYPE: {NoteNode.TYPE}')
    org_string = ''.join([org_valid_header, org_empty_children, '* Description\n'])

    expected_title = 'check it out'

    result = sut.create_node_from_org_string(org_string)

    assert type(result) is NoteNode
    assert expected_title == result.title
    assert result.org_data is not None


def test_create_node_from_org_string_when_todo_node(sut, org_valid_header, org_empty_children):
    org_valid_header = org_valid_header.replace(':TYPE: test', f':TYPE: {TodoNode.TYPE}')
    org_string = ''.join([org_valid_header, org_empty_children, '* Description\n'])

    expected_title = 'check it out'

    result = sut.create_node_from_org_string(org_string)

    assert type(result) is TodoNode
    assert expected_title == result.title
    assert result.org_data is not None
