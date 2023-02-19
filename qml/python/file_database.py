#!/usr/bin/env python3

import os

from node_id_generator import NodeIdGenerator


class FileDatabase:

    DATA_DIR = os.path.expanduser('~/.local/share/harbour-stinkyfish/harbour-stinkyfish/data')

    def __init__(self, node_id_generator=None):
        self.node_id_generator = node_id_generator or NodeIdGenerator()
        self.init_data_dir()

    def init_data_dir(self):
        if not os.path.isdir(self.DATA_DIR):
            os.makedirs(self.DATA_DIR)

    def create_filename_from_id(self, fid):
        return os.path.join(self.DATA_DIR, fid + '.org')

    def root_node_exists(self):
        root_filename = self.create_filename_from_id(self.node_id_generator.generate_root_id())
        return os.path.isfile(root_filename)

    def save_to_file(self, node, output_file=None):
        if output_file is None:
            output_file = self.create_filename_from_id(node.id)

        with open(output_file, mode='w') as file:
            file.write(node.create_org_string())

    def load_org_string_by_id(self, node_id):
        filename = self.create_filename_from_id(node_id)
        with open(filename, mode='r') as in_file:
            return in_file.read()
        return None
