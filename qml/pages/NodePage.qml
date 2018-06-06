import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/Database.js" as Database
import "../delegates"

Page {
    id: itemView

    property int parentId: -1
    property var appState: appWindow.state

    onAppStateChanged: {
        if(appState === 'SELECT'){
            bottomPanel.show()
            movementPanel.show()
            pastePanel.hide()
        }
        else if(appState === 'VIEW'){
            bottomPanel.hide()
            movementPanel.hide()
            pastePanel.hide()
        }
        else if(appState === 'PASTE'){
            bottomPanel.hide()
            movementPanel.hide()
            pastePanel.show()
        }
    }

    function cancelCutNodes()
    {
        Database.cancelCutNodes(appWindow.cutNodesParentId)
        refreshView(true)
    }

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


    SilicaFlickable {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: bottomPanel.top
            bottomMargin: bottomPanel.margin
        }
        clip: bottomPanel.expanded
        contentWidth: parent.width
        contentHeight: contentColumn.height + Theme.paddingLarge

        PullDownMenu {
            id: pullDownMenu
            visible: appState === "VIEW"
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

        VerticalScrollDecorator {
            visible: appState === "VIEW"
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
            }

            Column {
                id: delegateColumn
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Theme.paddingSmall
            }

        }
    }// Flickable


    DockedPanel {
        id: pastePanel
        width: parent.width
        height: bottomPanel.height
        dock: Dock.Bottom
        open: false

        MouseArea {
            anchors.fill: parent
        }

        ButtonLayout {
            anchors.centerIn: parent
            Button {
                text: "Cancel"
                onClicked: {
                    cancelCutNodes()
                    appWindow.state = "VIEW"
                }
            }
            Button {
                text: "Paste"
                onClicked: {
                    Database.pasteNodes(pageStack.currentPage.parentId)
                    Database.sanitizeNodePositions(appWindow.cutNodesParentId)
                    refreshView(true)
                    appWindow.state = "VIEW"
                }
            }
        }

        onOpenChanged: {
            if(open === false){
                cancelCutNodes()
                appWindow.state = 'VIEW'
            }
        }
    }

    DockedPanel {
        id: bottomPanel

        width: parent.width
        height: Theme.itemSizeExtraLarge + Theme.paddingLarge * 4

        dock: Dock.Bottom
        open: false

        MouseArea {
            anchors.fill: parent
        }

        ButtonLayout {
            anchors.centerIn: parent
            Button {
                text: "Cut"
                onClicked: {
                    var selectedIds = getSelection()
                    Database.cutNodes(selectedIds)
                    refreshView(true)
                    appWindow.cutNodesParentId = pageStack.currentPage.parentId
                    appWindow.state = "PASTE"
                }
            }
            Button {
                text: "Delete"
                onClicked: {
                    var selectedIds = getSelection()
                    for(var i=0; i<selectedIds.length; ++i){
                        Database.deleteNode(selectedIds[i])
                    }
                    appWindow.state = "VIEW"
                    refreshView(true)
                }
            }
            Button {
                text: "Share"
                onClicked: Database.printTables()
            }
            Button {
                text: "Edit"
                onClicked: {
                    var selectedIds = getSelection()
                    var node = Database.getMetaNode(selectedIds[0])
                    appWindow.state = "VIEW"
                    pageStack.push(Qt.resolvedUrl("AddItemPage.qml"), { "nodeId": node.id })
                }
            }

            /* IconButton { icon.source: "image://theme/icon-m-clipboard" } */
            /* IconButton { icon.source: "image://theme/icon-m-delete" } */
            /* IconButton { icon.source: "image://theme/icon-m-about"} */
            /* IconButton { icon.source: "image://theme/icon-m-edit"} */
        }

        onOpenChanged: {
            if(open === false){
                appWindow.state = 'VIEW'
            }
        }
    }

    DockedPanel {
        id: movementPanel

        width: 150
        anchors.top: parent.top
        anchors.topMargin: pageHeader.height
        anchors.bottom: parent.bottom
        anchors.bottomMargin: bottomPanel.height

        dock: Dock.Right

        MouseArea {
            anchors.fill: parent
        }

        Rectangle {
            anchors.fill: parent
            /* color: Theme.rgba(Theme.highlightBackgroundColor, Theme.highlightBackgroundOpacity) */
            color: Theme.rgba(Theme.overlayBackgroundColor, 0.5)
        }

        Column {
            anchors.centerIn: parent
            spacing: Theme.paddingLarge
            IconButton {
                icon.source: "image://theme/icon-cover-next-song"
                rotation: -90
                onClicked: {
                    var selectedIds = getSelection()
                    for(var i=selectedIds.length - 1; i>=0; --i){
                        Database.moveNodeTop(selectedIds[i])
                    }
                    refreshView(false)
                }
            }
            IconButton {
                icon.source: "image://theme/icon-cover-play"
                rotation: -90
                onClicked: {
                    var selectedIds = getSelection()
                    for(var i=0; i<selectedIds.length; ++i){
                        Database.moveNodeUp(selectedIds[i])
                    }
                    refreshView(false)
                }
            }

            Rectangle {
                id: spacerRectMovementPanel
                color: "transparent"
                width: parent.width
                height: Theme.paddingLarge * 2
            }

            IconButton {
                icon.source: "image://theme/icon-cover-play"
                rotation: 90
                onClicked: {
                    var selectedIds = getSelection()
                    for(var i=selectedIds.length-1; i>=0; --i){
                        Database.moveNodeDown(selectedIds[i])
                    }
                    refreshView(false)
                }
            }
            IconButton {
                icon.source: "image://theme/icon-cover-next-song"
                rotation: 90
                onClicked: {
                    var selectedIds = getSelection()
                    for(var i=0; i<selectedIds.length; ++i){
                        Database.moveNodeBottom(selectedIds[i])
                    }
                    refreshView(false)
                }
            }
        }

        onOpenChanged: {
            if(open === false){
                appWindow.state = 'VIEW'
            }
        }
    }

}// Page
