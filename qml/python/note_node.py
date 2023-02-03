#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from node import Node


class NoteNode(Node):

    TYPE = 'Note'

    def __init__(self):
        super().__init__()
        self.description = ''

    def _create_org_string_from_data(self, data):
        return f'* Description\n{data["description"]}'

    def _parse_string(self):
        node = self.org_data.get_node_by_heading(self.org_data.root, 'Description')
        if not node:
            raise ValueError('NoteNode: no Description section')
        else:
            node = node[0]

        self.description = node.content[0].strip()
