#!/usr/bin/env python3

import pytest

from note_node import NoteNode


@pytest.fixture
def sut():
    return NoteNode()


@pytest.mark.parametrize(
    'description, expected',
    [('* Description\ncheck it out\n', 'check it out'),
     ('* Description\n', '')])
def test_parse_string_parses_description(sut, std_org_header, description, expected):
    data = std_org_header + description

    sut.parse_string(data)

    assert expected == sut.description
