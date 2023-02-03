#!/usr/bin/env python3
# -*- coding: utf-8 -*-


class NodeManager:

    def __init__(self, file_database, node_cache, logger):
        self.file_database = file_database
        self.node_cache = node_cache
        self.node_cache.set_file_database(file_database)
        self.logger = logger

    def init(self):
        self.init_root_node()
        self.logger.log('NodeManager initialized')

    def init_root_node(self):
        if not self.file_database.root_node_exists():
            self.file_database.create_root_node()
            self.logger.log('Root node created')
        else:
            self.logger.log('Root node exists')

    def create_node(self):
        pass

    def get_node_by_id(self, node_id):
        return None
