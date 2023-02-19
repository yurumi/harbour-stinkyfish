#!/usr/bin/env python3

import pyotherside as pyo

from file_database import FileDatabase
from node_cache import NodeCache
from node_manager import NodeManager
from pyologger import PyoLogger
from node_id_generator import NodeIdGenerator


node_manager = NodeManager(
    file_database=FileDatabase(),
    node_cache=NodeCache(),
    logger=PyoLogger(),
    send_fcn=pyo.send)
node_manager.init()

# Exposed API Endpoints for calls from QML
generate_root_id = NodeIdGenerator.generate_root_id
generate_node_id = NodeIdGenerator.generate_node_id
create_node_from_data = node_manager.create_node_from_data
request_child_node_data = node_manager.request_child_node_data
