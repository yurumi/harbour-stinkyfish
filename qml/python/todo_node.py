#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from note_node import NoteNode


class TodoNode(NoteNode):

    TYPE = 'TODO'

    def __init__(self):
        super().__init__()

    def create_org_string_from_data(self, data):
        return super().create_org_string_from_data(data)

    def parse_org_string(self, data):
        super().parse_org_string(data)
