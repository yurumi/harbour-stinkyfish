import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root
    width: Math.max(height, childCounterText.width + 2 * Theme.paddingSmall)
    height: childCounterText.height + Theme.paddingSmall
    opacity: appWindow.state === "SELECT" ? 0.0 : 1.0

    property int numChildren: 0

    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: -Theme.paddingLarge

    Behavior on opacity { NumberAnimation { duration: 700 } }

    Rectangle {
        id: childCounter
        anchors.fill: parent
        radius: 5
        color: Theme.rgba(Theme.secondaryHighlightColor, 0.3)
        /* border.width: 1 * Theme.pixelRatio */
        /* border.color: Theme.overlayBackgroundColor */
        visible: numChildren > 0

        Text {
            id: childCounterText
            anchors.centerIn: parent
            text: numChildren
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
        }
    }
}
