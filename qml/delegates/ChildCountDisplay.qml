import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root
    width: Math.max(height, childCounterText.width + 2 * Theme.paddingSmall)
    height: childCounterText.height + Theme.paddingSmall

    property int numChildren: 0

    anchors.verticalCenter: parent.verticalCenter
    anchors.right: parent.right
    anchors.rightMargin: -Theme.paddingLarge

    Rectangle {
	id: childCounter
	anchors.fill: parent
	radius: 5
	color: "#777777"
	/* border.width: 1 */
	border.color: "#444444"
	visible: numChildren > 0
	
	Text {
	    id: childCounterText
	    anchors.centerIn: parent
	    text: numChildren
	    font.pixelSize: Theme.fontSizeSmall
	    color: "white"
	}
    }
}
