#!/usr/bin/env python3
# -*- coding: utf-8 -*-


class NodeCache:

    def __init__(self):
        self.file_database = None
        self.cached_nodes = {}  # {id: Node, ...}

    def set_file_database(self, file_database):
        self.file_database = file_database

    def get_node_by_id(self, node_id):
        # if node_id not in self.cached_nodes:
        #     self.file_database
        return None
