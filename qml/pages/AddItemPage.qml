import QtQuick 2.0
import Sailfish.Silica 1.0

import "../delegates"

Dialog {
    id: addDialog
    state: "CREATE"

    /* property var parentPage */
    property string nodeId: ''
    property string parentNodeId: ''
    property int position: -1
    property alias nodeType: nodeTypeCombo.value

    property var dynamicComponent
    property var dynamicObject: null

    canAccept: titleField.text.length > 0

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
            // TODO
            /* position = Database.getNumChildren(parentNodeId) */
        }

        var data = {
            'id': python.generateNodeId(),
            'parent_id': parentNodeId,
            'type': nodeType,
            'version': 1,
            'title': titleField.text,
            'description': descriptionField.text,
            'priority': priorityCombo.currentIndex,
            'due_date': "",
            'mode': 0
        };

        // TODO
        if(nodeType === 'Note'){
        }
        else if(nodeType === 'TODO'){
            data.status = dynamicObject.status;
            data.mode = dynamicObject.mode;
        }

        if (state === 'CREATE'){
            python.createNode(data);
            python.updateNode(data['parent_id'])
        }else if(state === 'EDIT'){
            data['id'] = nodeId;
            // TODO
            /* Database.updateNode(data); */
        }
    }

    onAccepted: acceptNode()

    /* onNodeIdChanged: { */
    /*     state = "EDIT" */
    /*     nodeTypeCombo.enabled = false */
    /*     var node = Database.getMetaNode(nodeId) */
    /*     parentNodeId = node.parentId */
    /*     position = node.position */
    /*     nodeType = node.type */
    /*     titleField.text = node.title */
    /*     descriptionField.text = node.description */
    /*     priorityCombo.currentIndex = node.priority */
    /* } */

    onNodeTypeChanged: {
        if(dynamicObject != null){
            dynamicObject.destroy()
        }

        // TODO
        if(nodeType === 'TODO'){
            dynamicComponent = Qt.createComponent("../delegates/NodeTodoEditDelegate.qml")
            if (dynamicComponent.status == Component.Ready)
                createDynamicObject();
            else
                dynamicComponent.statusChanged.connect(createDynamicObject);
        }

        // TODO
        /* if(state === "EDIT"){ */
        /*     var metaNode = Database.getMetaNode(nodeId) */

        /*     if(nodeType === Database.nodeTypeTODO){ */
        /*         var customData = Database.getNodeDataTodo(nodeId) */
        /*         dynamicObject.status = customData.rows.item(0).status */
        /*         dynamicObject.mode = metaNode.mode */
        /*     } */
        /* } */
    }


    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: addComponentsColumn.height

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

                    // TODO: aus node_factory/python holen
                    menu: ContextMenu {
                        MenuItem { text: 'Note' }
                        MenuItem { text: 'TODO' }
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
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: descriptionField.focus = true
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
