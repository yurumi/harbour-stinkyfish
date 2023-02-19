#!/usr/bin/env python3

import pytest


@pytest.fixture
def org_valid_header():
    return ''.join([
        ':PROPERTIES:\n',
        ':ID: 1234\n',
        ':PARENT_ID: 0000\n',
        ':TYPE: test\n',
        ':VERSION: 33\n',
        ':END:\n',
        '#+TITLE: check it out\n'])


@pytest.fixture
def org_empty_children():
    return ''.join([
        '* Children\n'])


@pytest.fixture
def org_dummy_children():
    return ''.join([
        '* Children\n',
        '- 1-2-3\n',
        '- 2-3-4\n',
        '- 3-4-5\n'])


@pytest.fixture
def node_data_template():
    return {
        'id': '1-2-3',
        'parent_id': '0-0-0',
        'type': 'test',
        'version': 2,
        'title': 'check it out'}
