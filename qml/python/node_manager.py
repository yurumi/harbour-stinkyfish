#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from node import Node
from node_factory import NodeFactory


class NodeManager:

    def __init__(self, file_database, node_cache, logger, send_fcn):
        self.node_factory = NodeFactory()
        self.file_database = file_database
        self.node_cache = node_cache
        self.node_cache.set_file_database(file_database)
        self.logger = logger
        self.send_fcn = send_fcn

    def init(self):
        self.init_root_node()

    def init_root_node(self):
        if not self.file_database.root_node_exists():
            node = self.node_factory.create_root_node()
            self.file_database.save_to_file(node)
            self.logger.log('Root node created')
        else:
            self.logger.log('Root node exists')

    def create_node_from_data(self, data):
        node = self.node_factory.create_node_from_data(data)
        self.file_database.save_to_file(node)
        self.register_node_to_parent(node)
        self.send_fcn('child_node_data', data)
        return node.id

    def request_child_node_data(self, parent_node_id):
        org_string = self.file_database.load_org_string_by_id(parent_node_id)
        node = Node()
        node.parse_org_string(org_string)
        for child_node_id in node.child_ids:
            child_node_org_string = self.file_database.load_org_string_by_id(child_node_id)
            child_node = self.node_factory.create_node_from_org_string(child_node_org_string)
            self.send_fcn('child_node_data', child_node.create_data())

    def register_node_to_parent(self, node):
        parent_node_org_string = self.file_database.load_org_string_by_id(node.parent_id)
        parent_node = self.node_factory.create_node_from_org_string(parent_node_org_string)
        parent_node.register_child_node(node)
        self.file_database.save_to_file(parent_node)
