#!/usr/bin/env python3

from file_database import FileDatabase
from node_cache import NodeCache
from node_manager import NodeManager
from pyologger import PyoLogger


node_manager = NodeManager(
    file_database=FileDatabase(),
    node_cache=NodeCache(),
    logger=PyoLogger())
node_manager.init()
