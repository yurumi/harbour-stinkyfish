#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from abc import abstractmethod

from PyOrgMode import OrgDataStructure, OrgList


class Node:

    TYPE = ''

    def __init__(self):
        self.org_data = OrgDataStructure()
        self.id = ''
        self.type = ''
        self.version: int
        self.title = None
        self.children_node = None

    def create_org_string_from_data(self, data):
        header = ''
        try:
            header = ''.join([
                ':PROPERTIES:\n',
                f':ID: {data["id"]}\n',
                f':TYPE: {data["type"]}\n',
                f':VERSION: {data["version"]}\n',
                ':END:\n',
                f'#+TITLE: {data["title"]}\n',
                '* Children\n'])
        except KeyError as err:
            raise ValueError(f'Header data invalid: {err}')

        org_string = self._create_org_string_from_data(data)
        return header + org_string

    def parse_data(self, data):
        org_string = self.create_org_string_from_data(data)
        self.parse_string(org_string)

    def parse_string(self, data):

        def get_properties(drawer):
            return {p.name: p.value for p in drawer.content}

        if not data:
            raise ValueError('Input string is empty')

        self.org_data.load_from_string(data)

        try:
            properties_drawer = self.org_data.root.content[0]
            properties = get_properties(properties_drawer)
            self.id = properties['ID']
            self.type = properties['TYPE']
            self.version = int(properties['VERSION'])
        except KeyError as err:
            raise ValueError(f'Header is invalid: {err}')
        except AttributeError as err:
            raise ValueError(f'Header is invalid: {err}')

        self.title = self.org_data.root.title
        if self.title is None:
            raise ValueError('Header is invalid: no title set')

        children_node = self.org_data.get_node_by_heading(self.org_data.root, 'Children')
        if not children_node:
            raise ValueError('Header is invalid: no Children section')
        else:
            self.children_node = children_node[0]

        self._parse_string()

    def get_child_ids(self):
        for c in self.children_node.content:
            if type(c) == OrgList.Element:
                return c.content
        return []

    @abstractmethod
    def _create_org_string_from_data(self, data):
        return ''

    @abstractmethod
    def _parse_string(self):
        pass
