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
def test_parse_org_string_parses_description(
        sut, org_valid_header, org_empty_children, description, expected):
    data = org_valid_header + org_empty_children + description

    sut.parse_org_string(data)

    assert expected == sut.description


def test_parse_org_string(sut):
    data = ''.join([
        ':PROPERTIES:\n',
        ':ID: 3c791696-afef-11ed-a803-080027d3c137\n',
        ':PARENT_ID: 00000000-0000-0000-0000-000000000000\n',
        ':TYPE: Note\n',
        ':VERSION: 1\n',
        ':END:\n',
        '#+TITLE: 3\n',
        '* Children\n',
        '- 734e1da6-afef-11ed-a634-080027d3c137\n',
        '- 777e1da6-afef-11ed-a634-080027d3c137\n\n',
        '* Description\n',
        'bla bla bla\n'])

    sut.parse_org_string(data)

    assert 'bla bla bla' == sut.description
    assert 2 == len(sut.child_ids)
