import QtQuick 2.0
import Sailfish.Silica 1.0

import "pages"
import "delegates"
import "js/Database.js" as Database

ApplicationWindow
{
    id: appWindow
    initialPage: Component { NodePage { id: nodePage; parentNodeId: 0 } }
    /* initialPage: Component { Test{} } */
    state: "VIEW"

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait

    property int cutNodesParentId: -1

    states: [
        State {
            name: "VIEW"
	          StateChangeScript{ script: pageStack.currentPage.clearSelection()}
        },
        State {
            name: "SELECT"
        },
        State {
            name: "PASTE"
        }
    ]

    Item {
	      id: initDataItem

	      Component.onCompleted: {
          /* Database.clear() */
          Database.checkDbVersion()
          /* Database.createNodeTodo({'parentId': 0, 'position': 0, 'type': Database.nodeTypeTODO, 'title': "todo 0.0", 'description': "uvleg uvle gvl e", 'priority': 0, 'due_date': ""}) */
	        /* Database.createNodeTodo({'parentId': 0, 'position': 1, 'type': Database.nodeTypeTODO, 'title': "todo 0.1", 'description': "", 'priority': 1, 'due_date': ""}) */
	        /* Database.createNodeTodo({'parentId': 1, 'position': 0, 'type': Database.nodeTypeTODO, 'title': "todo 1.0", 'description': "vflg", 'priority': 2, 'due_date': ""}) */

	        Database.printTables()
	      }
    }

    Component.onDestruction: {
	      /* console.log("Destroy Database") */
	      /* Database.clear() */
    }

}

