#!/usr/bin/env python3


from note_node import NoteNode
from todo_node import TodoNode


class NodeFactory:

    type_map = {
        NoteNode.TYPE: NoteNode,
        TodoNode.TYPE: TodoNode,
    }

    def create_node(self, data):
        ret = self.type_map[data['type']]()
        ret.parse_data(data)
        return ret
