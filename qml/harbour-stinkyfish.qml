import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "pages"
import "delegates"

ApplicationWindow
{
    id: appWindow
    initialPage: Component { NodePage { id: nodePage; parentNodeId: rootNodeId } }
    /* initialPage: Component { Test{} } */
    state: "VIEW"

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait

    /* property int cutNodesParentId: -1 */
    property string rootNodeId: '00000000-0000-0000-0000-000000000000'

    states: [
        State {
            name: "VIEW"
            StateChangeScript{
                script: {
                    if (pageStack.currentPage !== null) {
                        pageStack.currentPage.clearSelection()
                    }
                }
            }
        },
        State {
            name: "SELECT"
        },
        State {
            name: "PASTE"
        }
    ]

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'));

            importModule('entry_point', function () {});
        }

        function generateRootId() {
            return python.call_sync('entry_point.generate_root_id')
        }

        function generateNodeId() {
            return python.call_sync('entry_point.generate_node_id')
        }

        function createNode(data) {
            python.call('entry_point.create_node_from_data', [data], function (nodeId) {
                console.log(nodeId + ' created');
            });
        }

        function requestChildNodeData(nodeId) {
            python.call('entry_point.request_child_node_data', [nodeId]);
        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('[Python error]: ' + traceback);
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('[Python]: ' + data);
        }
    }
}
