#!/usr/bin/env python3

import os
import re
import uuid


class FileIdGenerator:

    @staticmethod
    def generate_file_id():
        return str(uuid.uuid1())

    @staticmethod
    def generate_root_id():
        return re.sub(r'[a-z,0-9]', '0', str(uuid.uuid1()))


class FileDatabase:

    DATA_DIR = os.path.expanduser('~/.local/share/harbour-stinkyfish/harbour-stinkyfish/data')

    def __init__(self, file_id_generator=None):
        self.file_id_generator = file_id_generator or FileIdGenerator()
        self.init_data_dir()

    def init_data_dir(self):
        if not os.path.isdir(self.DATA_DIR):
            os.makedirs(self.DATA_DIR)

    def create_filename(self, fid):
        return os.path.join(self.DATA_DIR, fid + '.org')

    def root_node_exists(self):
        root_filename = self.create_filename(self.file_id_generator.generate_root_id())
        return os.path.isfile(root_filename)

    def create_root_node(self):
        root_id = self.file_id_generator.generate_root_id()
        root_filename = self.create_filename(root_id)
        with open(root_filename, mode='w') as root_file:
            root_file.write(':PROPERTIES:\n' f':ID: {root_id}\n' ':END:\n')
            root_file.write('#+title: root\n')
            root_file.write('#+type: root\n')
            root_file.write('#+version: 1.0\n\n')
            root_file.write('* Children')
