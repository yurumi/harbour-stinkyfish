#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from note_node import NoteNode


class TodoNode(NoteNode):

    TYPE = 'TODO'

    def __init__(self):
        super().__init__()

    def _create_org_string_from_data(self, data):
        return super()._create_org_string_from_data(data)

    def _parse_string(self):
        super()._parse_string()
