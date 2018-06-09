import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/Database.js" as Database

BaseNode {
    id: baseNode
    height: listItem.height

    ListItem {
        id: listItem
        width: parent.width
        contentHeight: contentColumn.height

        menu: BaseNodeContextMenu {}

        function showDeleteRemorseItem() {
            deleteRemorse.execute(listItem, "Deleting", function() {
                Database.deleteNode(baseNode.nodeId)
                nodePage.refreshView(true)
            } )
        }

        onClicked: {
            if(appWindow.state === "SELECT"){
                toggleSelection()
            }
            else{
                enterNode(baseNode.nodeId)
            }
        }

        RemorseItem { id: deleteRemorse }

        Rectangle {
            anchors.fill: parent
            color: Theme.rgba(Theme.highlightBackgroundColor, 0.1)
        }

        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Theme.paddingLarge
            height: if(descriptionItem.visible){titleRow.height + descriptionItem.height}else{titleRow.height}

            Item {
                id: titleRow
                width: parent.width
                height: titleText.height + Theme.paddingMedium

                Text {
                    id: titleText
                    anchors.left: parent.left
                    anchors.right: if(childCounter.visible){childCounter.left}else{parent.right}
                    text: baseNode.title
                    font.pixelSize: Theme.fontSizeLarge
                    /* color: if(childCounter.visible){"white"}else{"black"} */
                    clip: true
                    wrapMode: Text.Wrap
                    color: Theme.highlightColor
                } // titleText

                ChildCountDisplay {
                    id: childCounter
                    numChildren: baseNode.numChildren
                }
            } // titleRow

            Item {
                id: descriptionItem
                visible: baseNode.description.length > 0
                height: descriptionText.height + darkRect.height + lightRect.height
                /* height: descriptionText.height + lightRect.height */
                width: titleRow.width

                Rectangle {
                    id: darkRect
                    height: 1 * Theme.pixelRatio
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: Theme.overlayBackgroundColor
                }

                Rectangle {
                    id: lightRect
                    height: 1 * Theme.pixelRatio
                    anchors.top: darkRect.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: Theme.highlightColor
                }

                Text {
                    id: descriptionText
                    anchors.top: lightRect.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: baseNode.description
                    font.pixelSize: Theme.fontSizeSmall
                    clip: true
                    wrapMode: Text.Wrap
                    color: Theme.secondaryHighlightColor
                } // descriptionText

            } // descriptionItem

        } // contentColumn
    } // listItem
}
