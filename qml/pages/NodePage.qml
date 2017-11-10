import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/Database.js" as Database
import "../delegates"

Page {
    id: itemView

    property int parentId: -1

    function clearSelection()
    {
	for(var i=0; i<delegateColumn.children.length; ++i){
	    delegateColumn.children[i].unselect()
	}

    }

    function getSelection()
    {
	var ret = new Array()
	for(var i=0; i<delegateColumn.children.length; ++i){
	    if(delegateColumn.children[i].state == "SELECTED"){
		/* console.log("selected id:", delegateColumn.children[i].id, delegateColumn.children[i].title) */
		ret.push(delegateColumn.children[i].id)
	    }
	}	
	return ret
    }
    
    function refreshView(clearSelection)
    {
	var selectedIds = getSelection()
	for(var i=0; i<delegateColumn.children.length; ++i){
	    delegateColumn.children[i].destroy()
	}
	createView()
	if(!clearSelection){
	    for(var i=0; i<selectedIds.length; ++i){
		for(var k=0; k<delegateColumn.children.length; ++k){
		    if(delegateColumn.children[k].id == selectedIds[i]){
			delegateColumn.children[k].select()
		    }
		}
	    }
	}
    }

    function createView()
    {
	var childNodes = Database.getChildNodes(parentId)

	for(var i=0; i<childNodes.rows.length; i++){
	    var childNode = childNodes.rows[i]
	    var component
	    var node
	    var data

	    if(childNode.type === Database.nodeTypeNOTE){
		component = Qt.createComponent("../delegates/NodeNoteDelegate.qml")
		node = component.createObject(delegateColumn,
					      {"id": childNode.id,
					       "parentId": childNode.parentId,
					       "position": childNode.position,
					       "type": childNode.type,
					       "title": childNode.title,

					       "description": childNode.description,
					       "priority": childNode.priority,
					       "due_date": childNode.due_date,
					       "mode": 0,
					       "numChildren": Database.getNumChildren(childNodes.rows[i].id)
					      })
	    }
	    else if(childNode.type === Database.nodeTypeTODO){
		// type specific data
		data = Database.getNodeDataTodo(childNode.id)
		
		component = Qt.createComponent("../delegates/NodeTodoDelegate.qml")
		node = component.createObject(delegateColumn,
					      {"id": childNode.id,
					       "parentId": childNode.parentId,
					       "position": childNode.position,
					       "type": childNode.type,
					       "title": childNode.title,
					       "description": childNode.description,
					       "priority": childNode.priority,
					       "due_date": childNode.due_date,
					       "mode": childNode.mode,
					       "numChildren": Database.getNumChildren(childNodes.rows[i].id),
					       "status": data.rows[0].status
					      })
	    }
	    else if(childNodes.rows[i].type === Database.nodeTypeCALC){
		// type specific data
		data = Database.getNodeDataCalc(childNode.id)
		
		component = Qt.createComponent("../delegates/NodeCalcDelegate.qml")
		node = component.createObject(delegateColumn,
					      {"id": childNode.id,
					       "parentId": childNode.parentId,
					       "position": childNode.position,
					       "type": childNode.type,
					       "title": childNode.title,
					       "description": childNode.description,
					       "priority": childNode.priority,
					       "due_date": childNode.due_date,
					       "mode": 0,
					       "numChildren": Database.getNumChildren(childNodes.rows[i].id),
					       "operator": data.rows[0].operator,
					       "value": data.rows[0].value
					      })
	    }

	    if (node == null) {
		// Error Handling
		console.log("Error creating object");
	    }else{
		node.update();
	    }
	}// for
    }

    Component.onCompleted: {
	createView()
    }

    onStatusChanged: {
        if(status === PageStatus.Activating){
            refreshView(true)
        }
    }


    Flickable {
	anchors.fill: parent
	contentWidth: parent.width
	contentHeight: contentColumn.height + Theme.paddingMedium

        PullDownMenu {
            MenuItem {
                text: qsTr("Settings")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))
            }

            MenuItem {
                text: qsTr("Add item")
                /* onClicked: pageStack.push(Qt.resolvedUrl("AddItemPage.qml"), {'parentNodeId': parentId, 'parentPage': itemView}) */
                onClicked: pageStack.push(Qt.resolvedUrl("AddItemPage.qml"), {'parentNodeId': parentId})
            }
        }

        ViewPlaceholder {
            enabled: delegateColumn.children.length === 0
            text: qsTr("Pull up/down to add items.")
        }

	Column {
	    id: contentColumn
	    anchors.left: parent.left
	    anchors.right: parent.right	 
	    anchors.margins: Theme.paddingMedium	
	    
	    PageHeader {
		id: pageHeader
		title: {
		    if(parentId <= 0){
			return "Home"
		    }else{
			return Database.getMetaNode(parentId).title
		    }
		}
		description: {		    
		    if(parentId <= 0){
			return ""
		    }else{
			return Database.getMetaNode(parentId).description
		    }
		}

		/* Rectangle { */
		/*     anchors.fill: parent */
		/*     /\* anchors.left: parent.horizontalCenter *\/ */
		/*     /\* anchors.right: parent.right *\/ */
		/*     height: 100 */
		/*     color: "blue" */

		/*     Text { */
		/* 	anchors.centerIn: parent */
		/* 	width: 80 */
		/* 	font.pixelSize: 50 */
		/* 	elide: Text.ElideRight */
		/* 	text: "check check eckw" */
		/*     } */
		/* } */
	    }
    
	    Column {
		id: delegateColumn
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: Theme.paddingSmall
	    }

	}
    }// Flickable
}// Page
