import QtQuick 2.0

BaseNode {
    id: baseNode
    width: parent.width
    height: 200

    property string operator: ""
    property string value: ""

    Rectangle {
	anchors.fill: parent
	color: "blue"

	Column {
	    anchors.fill: parent
	    spacing: 10
	    Row {
		height: 20
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 20

		Text {
		    text: "id: " + baseNode.id
		}

		Text {
		    text: "parentId: " + baseNode.parentId
		}

 		Text {
		    text: "position: " + baseNode.position
		}

		Text {
		    text: "type: " + baseNode.type
		}

		Text {
		    text: "prio: " + baseNode.priority
		}

		Text {
		    text: "due: " + baseNode.due_date
		}
	    }

	    Row {
		spacing: 50
		Text {
		    text: "operator: " + operator
		}

		Text {
		    text: "value: " + value
		}
	    }
	}
    }
}
