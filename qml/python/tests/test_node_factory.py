#!/usr/bin/env python3

import pytest

from note_node import NoteNode
from todo_node import TodoNode
from node_factory import NodeFactory


@pytest.fixture
def sut():
    return NodeFactory()


def test_create_node_when_note_node(sut):
    data = {'id': '1-2-3', 'type': NoteNode.TYPE, 'version': 2, 'title': 'check it out', 'description': 'desc'}

    result = sut.create_node(data)

    assert type(result) is NoteNode


def test_create_node_when_todo_node(sut):
    data = {'id': '1-2-3', 'type': TodoNode.TYPE, 'version': 2, 'title': 'check it out', 'description': 'desc'}

    result = sut.create_node(data)

    assert type(result) is TodoNode
