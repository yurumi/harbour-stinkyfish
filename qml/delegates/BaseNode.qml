import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: baseNode
    state: "UNSELECTED"

    property int id: -1
    property int parentId: -1
    property int position: -1
    property string type: ""
    property string title: ""
    property string description: ""
    property int priority: -1
    property string due_date: ""
    property int mode: 0
    property int numChildren: 0
    property bool debugMode: false

    states: [
        State {
            name: "UNSELECTED"
        },
        State {
            name: "SELECTED"
        }
    ]

    function update()
    {
    }

    function enterNode(id)
    {
        pageStack.push(Qt.resolvedUrl("../pages/NodePage.qml"), {"parentId": id}, PageStackAction.Immediate)
    }

    function toggleSelection()
    {
        if(state == "UNSELECTED"){
            state = "SELECTED"
        }else{
            state = "UNSELECTED"
        }
    }

    function select()
    {
        state = "SELECTED"
    }

    function unselect()
    {
        state = "UNSELECTED"
    }

    /* MouseArea { */
        /* anchors.fill: parent */
        /* onClicked: { */
        /*     if(appWindow.state === "SELECT"){ */
        /*         toggleSelection() */
        /*     } */
        /*     else{ */
        /*         enterNode(baseNode.id) */
        /*     } */
        /* } */
        /* onPressAndHold: { */
        /*     appWindow.state = "SELECT" */
        /*     toggleSelection() */
        /* } */
    /* } */

    Column {
        anchors.fill: parent
        spacing: 10
        z: 100
        opacity: 0.5
        visible: debugMode

        Row {
            height: 20
            anchors.left: parent.left
            anchors.right: parent.right
            spacing: 10

            Text {
                font.pixelSize: 20
                text: "id: " + baseNode.id
            }

            Text {
                font.pixelSize: 20
                text: "parentId: " + baseNode.parentId
            }

            Text {
                font.pixelSize: 20
                text: "position: " + baseNode.position
            }

            Text {
                font.pixelSize: 20
                text: "type: " + baseNode.type
            }

            Text {
                font.pixelSize: 20
                text: "prio: " + baseNode.priority
            }

            Text {
                font.pixelSize: 20
                text: "due: " + baseNode.due_date
            }
        }
    }

    Rectangle {
        id: selectionRect
        anchors.fill: parent
        color: "black"
        opacity: 0.5
        visible: appWindow.state === "SELECT" && baseNode.state === "UNSELECTED"
        z: 100
    }
}
