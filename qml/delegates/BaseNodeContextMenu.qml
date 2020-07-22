import QtQuick 2.0
import Sailfish.Silica 1.0

ContextMenu {
    hasContent: appWindow.state === "VIEW"

    MenuItem {
        text: "Selection Mode"
        onClicked: {
            appWindow.state = "SELECT"
            toggleSelection()
        }
    }
    MenuItem {
        text: "Edit"
        onClicked: {
            pageStack.push(Qt.resolvedUrl("../pages/AddItemPage.qml"),
                           { "nodeId": baseNode.nodeId })
        }
    }
    MenuItem {
        text: "Delete"
        onClicked: {
            listItem.showDeleteRemorseItem()
        }
    }
}
