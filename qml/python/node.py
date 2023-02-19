#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from PyOrgMode import OrgDataStructure, OrgList


class Node:

    TYPE = ''

    def __init__(self):
        self.org_data = None
        self.id = ''
        self.parent_id = ''
        self.type = ''
        self.version = 0
        self.title = None
        self.child_ids = []

    def create_org_string(self):
        org_string = ''
        org_string = ''.join([
            ':PROPERTIES:\n',
            f':ID: {self.id}\n',
            f':PARENT_ID: {self.parent_id}\n',
            f':TYPE: {self.type}\n',
            f':VERSION: {self.version}\n',
            ':END:\n',
            f'#+TITLE: {self.title}\n',
            '* Children\n'])

        for child_id in self.child_ids:
            org_string += f'- {child_id}\n'

        org_string += '\n'

        return org_string

    def create_org_string_from_data(self, data):
        org_string = ''
        try:
            org_string = ''.join([
                ':PROPERTIES:\n',
                f':ID: {data["id"]}\n',
                f':PARENT_ID: {data["parent_id"]}\n',
                f':TYPE: {data["type"]}\n',
                f':VERSION: {data["version"]}\n',
                ':END:\n',
                f'#+TITLE: {data["title"]}\n',
                '* Children\n'])
        except KeyError as err:
            raise ValueError(f'Header data invalid: {err} ({self.id})')

        return org_string

    def create_data(self):
        ret = {
            'id': self.id,
            'parent_id': self.parent_id,
            'type': self.type,
            'version': self.version,
            'title': self.title,
            'num_children': len(self.child_ids)
        }
        return ret

    def parse_data(self, data):
        org_string = self.create_org_string_from_data(data)
        self.parse_org_string(org_string)

    def parse_file(self, filename):
        with open(filename, 'r') as file:
            org_string = file.read()
            self.parse_org_string(org_string)

    def parse_org_string(self, org_string):

        def get_properties(drawer):
            return {p.name: p.value for p in drawer.content}

        if not org_string:
            raise ValueError(f'Input string is empty ({self.id})')

        self.org_data = OrgDataStructure()
        self.org_data.load_from_string(org_string)

        try:
            properties_drawer = self.org_data.root.content[0]
            properties = get_properties(properties_drawer)
            self.id = properties['ID']
            self.parent_id = properties['PARENT_ID']
            self.type = properties['TYPE']
            self.version = int(properties['VERSION'])
        except KeyError as err:
            raise ValueError(f'Header is invalid: {err} ({self.id})')
        except AttributeError as err:
            raise ValueError(f'Header is invalid: {err} ({self.id})')

        self.title = self.org_data.root.title
        if self.title is None:
            raise ValueError(f'Header is invalid: no title set ({self.id})')

        children_node = self.org_data.get_node_by_heading(self.org_data.root, 'Children')
        if not children_node:
            raise ValueError(f'Header is invalid: no Children section ({self.id})')
        else:
            children_node = children_node[0]
            for c in children_node.content:
                if type(c) == OrgList.Element:
                    self.child_ids = c.content
                    break

    def register_child_node(self, node):
        self.child_ids.append(node.id)
