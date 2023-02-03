import QtQuick 2.0
import Sailfish.Silica 1.0

/* import "../js/Database.js" as Database */
import "../delegates"

Page {
    id: nodePage

    backNavigation: appWindow.state !== 'SELECT'

    property int parentNodeId: -1
    property var appState: appWindow.state

    onAppStateChanged: {
        if(appState === 'SELECT'){
            bottomPanel.opacity = 1.0
            bottomPanel.show()
            movementPanel.show()
            pastePanel.hide()
        }
        else if(appState === 'VIEW'){
            bottomPanel.opacity = 0.0
            bottomPanel.hide()
            movementPanel.hide()
            pastePanel.hide()
        }
        else if(appState === 'PASTE'){
            bottomPanel.opacity = 0.0
            /* bottomPanel.hide() */
            pastePanel.show()
            movementPanel.hide()
        }
    }

    function cancelCutNodes()
    {
        // TODO
        /* Database.cancelCutNodes(appWindow.cutNodesParentId) */
        refreshView(true)
    }

    function clearSelection()
    {
        for(var i=0; i<delegateColumn.children.length; ++i){
            delegateColumn.children[i].unselect()
        }

    }

    function deleteStagedNodes()
    {
        var stagedNodeIds = getStagedDeletion()
        for(var i=0; i<stagedNodeIds.length; ++i){
            // TODO
            /* Database.deleteNode(stagedNodeIds[i]) */
        }
        /* appWindow.state = "VIEW" */
        refreshView(true)
    }

    function getSelection()
    {
        var ret = new Array()
        for(var i=0; i<delegateColumn.children.length; ++i){
            if(delegateColumn.children[i].state == "SELECTED"){
                /* console.log("selected id:", delegateColumn.children[i].id, delegateColumn.children[i].title) */
                ret.push(delegateColumn.children[i].nodeId)
            }
        }
        return ret
    }

    function getStagedDeletion()
    {
        var ret = new Array()
        for(var i=0; i<delegateColumn.children.length; ++i){
            if(delegateColumn.children[i].state == "STAGED_DELETION"){
                ret.push(delegateColumn.children[i].nodeId)
            }
        }
        return ret
    }

    function refreshView(clearSelection)
    {
        var selectedNodeIds = getSelection()
        for(var i=0; i<delegateColumn.children.length; ++i){
            delegateColumn.children[i].destroy()
        }
        createView()
        if(!clearSelection){
            for(var i=0; i<selectedNodeIds.length; ++i){
                for(var k=0; k<delegateColumn.children.length; ++k){
                    if(delegateColumn.children[k].nodeId == selectedNodeIds[i]){
                        delegateColumn.children[k].select()
                    }
                }
            }
        }
    }

    function createView()
    {
        // TODO
        /* var childNodes = Database.getChildNodes(parentNodeId) */

        /* for(var i=0; i<childNodes.rows.length; i++){ */
        /*     var childNode = childNodes.rows[i] */
        /*     var component */
        /*     var node */
        /*     var data */

        /*     if(childNode.type === Database.nodeTypeNOTE){ */
        /*         component = Qt.createComponent("../delegates/NodeNoteDelegate.qml") */
        /*         node = component.createObject(delegateColumn, */
        /*                                       {"nodeId": childNode.id, */
        /*                                        "parentNodeId": childNode.parentId, */
        /*                                        "position": childNode.position, */
        /*                                        "type": childNode.type, */
        /*                                        "title": childNode.title, */

        /*                                        "description": childNode.description, */
        /*                                        "priority": childNode.priority, */
        /*                                        "due_date": childNode.due_date, */
        /*                                        "mode": 0, */
        /*                                        "numChildren": Database.getNumChildren(childNodes.rows[i].id) */
        /*                                       }) */
        /*     } */
        /*     else if(childNode.type === Database.nodeTypeTODO){ */
        /*         // type specific data */
        /*         data = Database.getNodeDataTodo(childNode.id) */

        /*         component = Qt.createComponent("../delegates/NodeTodoDelegate.qml") */
        /*         node = component.createObject(delegateColumn, */
        /*                                       {"nodeId": childNode.id, */
        /*                                        "parentNodeId": childNode.parentId, */
        /*                                        "position": childNode.position, */
        /*                                        "type": childNode.type, */
        /*                                        "title": childNode.title, */
        /*                                        "description": childNode.description, */
        /*                                        "priority": childNode.priority, */
        /*                                        "due_date": childNode.due_date, */
        /*                                        "mode": childNode.mode, */
        /*                                        "numChildren": Database.getNumChildren(childNodes.rows[i].id), */
        /*                                        "status": data.rows[0].status */
        /*                                       }) */
        /*     } */
        /*     else if(childNodes.rows[i].type === Database.nodeTypeCALC){ */
        /*         // type specific data */
        /*         data = Database.getNodeDataCalc(childNode.id) */

        /*         component = Qt.createComponent("../delegates/NodeCalcDelegate.qml") */
        /*         node = component.createObject(delegateColumn, */
        /*                                       {"nodeId": childNode.id, */
        /*                                        "parentNodeId": childNode.parentId, */
        /*                                        "position": childNode.position, */
        /*                                        "type": childNode.type, */
        /*                                        "title": childNode.title, */
        /*                                        "description": childNode.description, */
        /*                                        "priority": childNode.priority, */
        /*                                        "due_date": childNode.due_date, */
        /*                                        "mode": 0, */
        /*                                        "numChildren": Database.getNumChildren(childNodes.rows[i].id), */
        /*                                        "operator": "+",//data.rows[0].operator, */
        /*                                        "value": "33.3"//data.rows[0].value */
        /*                                       }) */
        /*     } */

        /*     if (node == null) { */
        /*         // Error Handling */
        /*         console.log("Error creating object"); */
        /*     }else{ */
        /*         node.update(); */
        /*     } */
        /* }// for */
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

        RemorsePopup {
            id: deleteRemorsePopup

            onTriggered: {
                deleteStagedNodes()
            }

            onCanceled: {
                for(var i=0; i<delegateColumn.children.length; ++i){
                    if(delegateColumn.children[i].state === "STAGED_DELETION"){
                        delegateColumn.children[i].state = "UNSELECTED"
                    }
                }
            }
        }

        PullDownMenu {
            id: pullDownMenu
            visible: appState === "VIEW"
            /* MenuItem { */
            /*     text: qsTr("Settings") */
            /*     onClicked: pageStack.push(Qt.resolvedUrl("SettingsPage.qml")) */
            /* } */

            MenuItem {
                text: qsTr("Add item")
                /* onClicked: pageStack.push(Qt.resolvedUrl("AddItemPage.qml"), {'parentNodeId': parentId, 'parentPage': nodePage}) */
                onClicked: pageStack.push(Qt.resolvedUrl("AddItemPage.qml"), {'parentNodeId': parentNodeId})
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
                    if(parentNodeId <= 0){
                        return "Home"
                    }else{
                        // TODO
                        /* return Database.getMetaNode(parentNodeId).title */
                        return "---"
                    }
                }
                description: {
                    if(parentNodeId <= 0){
                        return ""
                    }else{
                        // TODO
                        /* return Database.getMetaNode(parentNodeId).description */
                        return "ddd"
                    }
                }
            }

            Column {
                id: delegateColumn
                anchors.left: parent.left
                anchors.right: parent.right
                spacing: Theme.paddingMedium
            }

        }
    }// Flickable


    DockedPanel {
        id: pastePanel
        width: parent.width
        height: bottomPanel.height
        dock: Dock.Bottom
        open: false
        z: 10

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
                    // TODO
                    /* Database.pasteNodes(pageStack.currentPage.parentNodeId) */
                    /* Database.sanitizeNodePositions(appWindow.cutNodesParentId) */
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

        Behavior on opacity { NumberAnimation { duration: 300 } }

        MouseArea {
            anchors.fill: parent
        }

        ButtonLayout {
            anchors.centerIn: parent
            Button {
                text: "Cut"
                onClicked: {
                    var selectedNodeIds = getSelection()
                    // TODO
                    /* Database.cutNodes(selectedNodeIds) */
                    refreshView(true)
                    appWindow.cutNodesParentId = pageStack.currentPage.parentNodeId
                    appWindow.state = "PASTE"
                }
            }
            Button {
                text: "Delete"
                onClicked: {
                    /* deleteRemorsePopup.execute("Deleting", deleteSelectedNodes()) */
                    deleteRemorsePopup.execute("Deleting", function() {})

                    var selectedNodeIds = getSelection()
                    for(var k=0; k<delegateColumn.children.length; ++k){
                        if(delegateColumn.children[k].state === "SELECTED"){
                            delegateColumn.children[k].state = "STAGED_DELETION"
                        }
                    }

                    appWindow.state = "VIEW"
                    /* refreshView(true) */
                }
            }
            Button {
                text: "Share"
                // TODO
                /* onClicked: Database.printTables() */
                enabled: false
            }
            Button {
                text: "..."
                enabled: false

                /* property var nodeIdToEdit: -1 */

                /* Component.onCompleted: { */
                /*     movementPanel.onVisibleChanged.connect(openEditPage) */
                /* } */

                /* onClicked: { */
                /*     var selectedIds = getSelection() */
                /*     nodeIdToEdit = Database.getMetaNode(selectedIds[0]).id */
                /*     appWindow.state = "VIEW" */
                /* } */

                /* function openEditPage() { */
                /*     if(nodeIdToEdit > 0 && !movementPanel.visible){ */
                /*         pageStack.push(Qt.resolvedUrl("AddItemPage.qml"), */
                /*                        { "nodeId": nodeIdToEdit }) */
                /*         nodeIdToEdit = -1 */
                /*     } */
                /* } */
            }
        }

        onOpenChanged: {
            if(open === false){
                appWindow.state = 'VIEW'
            }
        }
    }

    DockedPanel {
        id: movementPanel

        width: 150 * Theme.pixelRatio
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
                    var selectedNodeIds = getSelection()
                    for(var i=selectedNodeIds.length - 1; i>=0; --i){
                        // TODO
                        /* Database.moveNodeTop(selectedNodeIds[i]) */
                    }
                    refreshView(false)
                }
            }
            IconButton {
                icon.source: "image://theme/icon-cover-play"
                rotation: -90
                onClicked: {
                    var selectedNodeIds = getSelection()
                    for(var i=0; i<selectedNodeIds.length; ++i){
                        // TODO
                        /* Database.moveNodeUp(selectedNodeIds[i]) */
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
                    var selectedNodeIds = getSelection()
                    for(var i=selectedNodeIds.length-1; i>=0; --i){
                        // TODO
                        /* Database.moveNodeDown(selectedNodeIds[i]) */
                    }
                    refreshView(false)
                }
            }
            IconButton {
                icon.source: "image://theme/icon-cover-next-song"
                rotation: 90
                onClicked: {
                    var selectedNodeIds = getSelection()
                    for(var i=0; i<selectedNodeIds.length; ++i){
                        // TODO
                        /* Database.moveNodeBottom(selectedNodeIds[i]) */
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
