#!/usr/bin/env python3

from node_id_generator import NodeIdGenerator

from node import Node
from note_node import NoteNode
from todo_node import TodoNode


class NodeFactory:

    type_map = {
        NoteNode.TYPE: NoteNode,
        TodoNode.TYPE: TodoNode,
    }

    def create_root_node(self):
        root_id = NodeIdGenerator.generate_root_id()
        org_string = ''.join([
            ':PROPERTIES:\n',
            f':ID: {root_id}\n',
            f':PARENT_ID: {root_id}\n',
            ':TYPE: root\n',
            ':VERSION: 1\n',
            ':END:\n',
            '#+TITLE: root\n',
            '* Children\n'])
        node = Node()
        node.parse_org_string(org_string)
        return node

    def create_node_from_data(self, data):
        ret = self.type_map[data['type']]()
        ret.parse_data(data)
        return ret

    def create_node_from_org_string(self, org_string):
        node = Node()
        node.parse_org_string(org_string)

        if node.type == 'root':
            return node

        ret = self.type_map[node.type]()
        ret.parse_org_string(org_string)
        return ret
