#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from node import Node


class NoteNode(Node):

    TYPE = 'Note'

    def __init__(self):
        super().__init__()
        self.description = ''

    def create_org_string(self):
        org_string = super().create_org_string()
        return org_string + f'* Description\n{self.description}\n\n'

    def create_org_string_from_data(self, data):
        org_string = super().create_org_string_from_data(data)
        return org_string + f'* Description\n{data["description"]}\n'

    def create_data(self):
        data = super().create_data()
        data['description'] = self.description
        return data

    def parse_org_string(self, data):
        super().parse_org_string(data)

        node = self.org_data.get_node_by_heading(self.org_data.root, 'Description')
        if not node:
            raise ValueError(f'NoteNode: no Description section ({self.id})')
        else:
            node = node[0]

        self.description = node.content[0].strip()
