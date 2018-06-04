import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/Database.js" as Database
import "../delegates"

Dialog {
    id: addDialog
    state: "CREATE"

    /* property var parentPage */
    property int nodeId: -1
    property int parentNodeId: -1
    property int position: -1
    property alias nodeType: nodeTypeCombo.value

    property var dynamicComponent
    property var dynamicObject: null

    states: [
    State {
        name: "CREATE"
	PropertyChanges { target: nodeTypeCombo; enabled: true }
	StateChangeScript{ script: console.log("CREATE MODE") }
    },
    State {
        name: "EDIT"
	PropertyChanges { target: nodeTypeCombo; enabled: false }
	StateChangeScript{ script: console.log("EDIT MODE") }
    }
    ]

    
    function createDynamicObject(){
	dynamicObject = dynamicComponent.createObject(addComponentsColumn)
    }

    function acceptNode(){
	if(position == -1){
	    position = Database.getNumChildren(parentNodeId)
	}
	
	var data = { 'parentId': parentNodeId,
		     'position': position,
		     'type': nodeType,
		     'title': titleField.text,
		     'description': descriptionField.text,
		     'priority': priorityCombo.currentIndex,
		     'due_date': "",
		     'mode': 0
		   };

	if(nodeType === Database.nodeTypeNOTE){	    
        }
	else if(nodeType === Database.nodeTypeTODO){
	    data.status = dynamicObject.status;
	    data.mode = dynamicObject.mode;
        }

	if(state === "EDIT"){
	    data["id"] = nodeId	    
	    Database.updateNode(data);
	}else{
	    nodeId = Database.createNode(data);
	}	
    }
    
    onAccepted: acceptNode()

    onNodeIdChanged: {
	state = "EDIT"
	nodeTypeCombo.enabled = false
    	var node = Database.getMetaNode(nodeId)
    	parentNodeId = node.parentId
    	position = node.position
    	nodeType = node.type
    	titleField.text = node.title
        descriptionField.text = node.description
    	priorityCombo.currentIndex = node.priority
    }
    
    onNodeTypeChanged: {
	if(dynamicObject != null){
	    dynamicObject.destroy()
	}

	if(nodeType === Database.nodeTypeTODO){
	    dynamicComponent = Qt.createComponent("../delegates/NodeTodoEditDelegate.qml")
	    if (dynamicComponent.status == Component.Ready)
		createDynamicObject();
	    else
		dynamicComponent.statusChanged.connect(createDynamicObject);
	}

	if(state === "EDIT"){
	    var metaNode = Database.getMetaNode(nodeId)

	    if(nodeType === Database.nodeTypeTODO){
		var customData = Database.getNodeDataTodo(nodeId)
	    	dynamicObject.status = customData.rows.item(0).status
		dynamicObject.mode = metaNode.mode
	    }
	}
    }

    
    SilicaFlickable {
	anchors.fill: parent
    contentWidth: parent.width
	contentHeight: 300

	Column {
	    id: addComponentsColumn
	    width: parent.width
        spacing: Theme.paddingLarge

	    DialogHeader {
		acceptText: "Save"
            }

	    Row {
		width: parent.width
		ComboBox {
		    id: nodeTypeCombo
		    label: "Type"
		    width: parent.width / 2

		    menu: ContextMenu {
			MenuItem { text: Database.nodeTypeNOTE }
			MenuItem { text: Database.nodeTypeTODO }
			MenuItem { text: Database.nodeTypeCALC }
		    }
		}

		Button {
		    id: addSiblingButton
		    text: "Save + Add Sibling"

		    onClicked: {
			acceptNode()
			pageStack.replace(Qt.resolvedUrl("AddItemPage.qml"), {'parentNodeId': parentNodeId})
		    }
		}
	    }

	    Row {
		width: parent.width
		
		ComboBox {
		    id: priorityCombo
		    width: parent.width / 2
		    label: "Priority"

		    menu: ContextMenu {
			MenuItem { text: "NO" }
			MenuItem { text: "LOW" }
			MenuItem { text: "MEDIUM" }
			MenuItem { text: "HIGH" }
		    }
		}
		Button {
		    id: addChildButton
		    text: "Save + Add Child"
		    width: addSiblingButton.width

		    onClicked: {
			acceptNode()
			console.log("id:", nodeId, "parentId:", parentNodeId)
			pageStack.replace(Qt.resolvedUrl("AddItemPage.qml"), {'parentNodeId': nodeId})
		    }
		}
		
	    }

	    Button {
		id: button
		text: "Choose a date"

		onClicked: {
		    var dialog = pageStack.push(pickerComponent, {
			date: new Date()
		    })
		    dialog.accepted.connect(function() {
			button.text = "You chose: " + dialog.dateText
		    })
		}

		Component {
		    id: pickerComponent
		    DatePickerDialog {}
		}
	    }

	    TextField {
		id: titleField
		width: parent.width
		placeholderText: "Node title"
		label: "Title"
		focus: addDialog.state === "CREATE"
	    }
	    TextField {
		id: descriptionField
		width: parent.width
		placeholderText: "Node description"
		label: "Description"
	    }
        }// Column
    }// Flickable
}// Page
