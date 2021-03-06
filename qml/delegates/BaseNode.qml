import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: baseNode
    state: "UNSELECTED"

    width: parent.width

    property int nodeId: -1
    property int parentNodeId: -1
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
        },
        State {
            name: "STAGED_DELETION"
        }
    ]

    function update()
    {
    }

    function enterNode(nodeId)
    {
        pageStack.push(Qt.resolvedUrl("../pages/NodePage.qml"), {"parentNodeId": nodeId}, PageStackAction.Immediate)
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
        if(state === "SELECTED"){
            state = "UNSELECTED"
        }
    }

    Rectangle {
        id: selectionRect
        anchors.fill: parent
        color: Theme.overlayBackgroundColor
        opacity: (appWindow.state === "SELECT" && baseNode.state === "UNSELECTED") || baseNode.state === "STAGED_DELETION" ? 0.5 : 0.0
        z: 100

        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
}
