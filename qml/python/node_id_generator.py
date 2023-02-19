#!/usr/bin/env python3

import uuid
import re


class NodeIdGenerator:

    @staticmethod
    def generate_root_id():
        return re.sub(r'[a-z,0-9]', '0', str(uuid.uuid1()))

    @staticmethod
    def generate_node_id():
        return str(uuid.uuid1())
