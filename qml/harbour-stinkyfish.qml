import QtQuick 2.0
import Sailfish.Silica 1.0

import "pages"
import "delegates"
import "js/Database.js" as Database

ApplicationWindow
{
    id: appWindow
    initialPage: Component { NodePage { id: initPage; parentId: 0 } }
    state: "VIEW"

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait

    property int cutNodesParentId: -1
    
    states: [
    State {
        name: "VIEW"
	PropertyChanges { target: selectionModeOverlay; visible: false }
	PropertyChanges { target: pasteModeOverlay; visible: false }
	StateChangeScript{ script: pageStack.currentPage.clearSelection()}
    },
    State {
        name: "SELECT"
	PropertyChanges { target: selectionModeOverlay; visible: true }
	PropertyChanges { target: pasteModeOverlay; visible: false }
    },
    State {
        name: "PASTE"
	PropertyChanges { target: selectionModeOverlay; visible: false }
	PropertyChanges { target: pasteModeOverlay; visible: true }
    }
    ]
    
    Item {
	id: initDataItem

	Component.onCompleted: {
            Database.checkDbVersion()
            /* Database.clear() */
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

    Item {
	id: selectionModeOverlay
	anchors.fill: parent
	visible: false

	Rectangle {
	    id: operationOverlay
	    height: 100
	    anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 280
	    anchors.right: parent.right
	    color: "blue"

	    Row {
		anchors.margins: Theme.paddingSmall
		spacing: Theme.paddingSmall
		
		Button {
		    width: 80
		    text: "Back"
		    onClicked: appWindow.state = "VIEW"
		}
		Button {
		    width: 80
		    text: "Del"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			for(var i=0; i<selectedIds.length; ++i){
			    Database.deleteNode(selectedIds[i])
			}
			appWindow.state = "VIEW"
			pageStack.currentPage.refreshView(true)
		    } 
		}
		Button {
		    width: 80
		    text: "Print"
		    onClicked: Database.printTables()
		}
		/* Button { */
		/*     width: 100 */
		/*     text: "SanPos" */
		/*     onClicked: {Database.sanitizeNodePositions(pageStack.currentPage.parentId); pageStack.currentPage.refreshView(true);}  */
		/* } */
		Button {
		    width: 80
		    text: "Cut"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			Database.cutNodes(selectedIds)
			pageStack.currentPage.refreshView(true)
			appWindow.cutNodesParentId = pageStack.currentPage.parentId
			appWindow.state = "PASTE"
		    } 
		}
		Button {
		    width: 80
		    text: "Edit"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			var node = Database.getMetaNode(selectedIds[0])
			appWindow.state = "VIEW"
			pageStack.push(Qt.resolvedUrl("pages/AddItemPage.qml"), { "nodeId": node.id })
		    } 
		}
		/* Button { */
		/*     width: 100 */
		/*     text: "ClearDb" */
		/*     onClicked: {Database.clear(); pageStack.currentPage.refreshView(true);}  */
		/* } */
	    }
	}

	/* Rectangle { */
	/*     id: movementOverlay */
	/*     width: 100 */
	/*     height: 400 */
	/*     anchors.bottom: operationOverlay.top */
	/*     anchors.right: parent.right */
	/*     color: "green" */

	/*     Column { */
	/* 	anchors.margins: Theme.paddingSmall */
	/* 	/\* Button { *\/ */
	/* 	/\*     width: 100 *\/ */
	/* 	/\*     text: "ClearDb" *\/ */
	/* 	/\*     onClicked: {Database.clear(); pageStack.currentPage.refreshView(true);}  *\/ */
	/* 	/\* } *\/ */
	/*     } */
	/* } */

	Rectangle {
	    id: movementOverlay
	    width: 100
	    height: 400
	    anchors.bottom: operationOverlay.top
	    anchors.right: parent.right
	    color: "green"

	    Column {
		anchors.margins: Theme.paddingSmall
		spacing: Theme.paddingSmall
		
		Button {
		    width: 100
		    text: "Top"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			for(var i=selectedIds.length - 1; i>=0; --i){
			    Database.moveNodeTop(selectedIds[i])
			}
			pageStack.currentPage.refreshView(false)
		    } 
		}
		Button {
		    width: 100
		    text: "Up"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			for(var i=0; i<selectedIds.length; ++i){
			    Database.moveNodeUp(selectedIds[i])
			}
			pageStack.currentPage.refreshView(false)
		    } 
		}
		Button {
		    width: 100
		    text: "Down"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			for(var i=selectedIds.length-1; i>=0; --i){
			    Database.moveNodeDown(selectedIds[i])
			}
			pageStack.currentPage.refreshView(false)
		    } 
		}
		
		Button {
		    width: 100
		    text: "Bottom"
		    onClicked: {
			var selectedIds = pageStack.currentPage.getSelection()
			for(var i=0; i<selectedIds.length; ++i){
			    Database.moveNodeBottom(selectedIds[i])
			}
			pageStack.currentPage.refreshView(false)
		    } 
		}
	    }
	}
    }// selectionModeOverlay

    Item {
	id: pasteModeOverlay
	anchors.fill: parent
	visible: false
	
	Rectangle {
	    height: 100
	    anchors.bottom: parent.bottom
	    anchors.left: parent.left
	    anchors.right: parent.right
	    color: "black"

	    Row {
		anchors.margins: Theme.paddingSmall
		spacing: Theme.paddingSmall
		
		Button {
		    width: 100
		    text: "Cancel"
		    onClicked: {
			Database.cancelCutNodes(appWindow.cutNodesParentId)
			pageStack.currentPage.refreshView(true)			
			appWindow.state = "VIEW"	
		    }
		}

		Button {
		    width: 100
		    text: "Paste"
		    onClicked: {
			Database.pasteNodes(pageStack.currentPage.parentId)
			Database.sanitizeNodePositions(appWindow.cutNodesParentId)
			pageStack.currentPage.refreshView(true)
			appWindow.state = "VIEW"
		    } 
		}
	    }
	}	
    }// pasteModeOverlay
}

