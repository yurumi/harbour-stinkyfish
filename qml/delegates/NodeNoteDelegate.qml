import QtQuick 2.0
import Sailfish.Silica 1.0

BaseNode {
    id: baseNode
    width: parent.width
    height: content.height

    Item {
	id: content
	anchors.left: parent.left
	anchors.right: parent.right
	height: contentColumn.height

	Rectangle {
	    anchors.fill: parent
	    color: Theme.highlightBackgroundColor
	    opacity: Theme.highlightBackgroundOpacity
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
		height: titleText.height        

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
		    height: 1
		    anchors.left: parent.left
		    anchors.right: parent.right
		    color: "#cccccc"
		}

		Rectangle {
		    id: lightRect
		    height: 1
		    anchors.top: darkRect.bottom
		    anchors.left: parent.left
		    anchors.right: parent.right
		    /* color: "#eeeeee" */
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
    } // content

    /* Rectangle { */
    /* 	id: contentRect */
    /* 	anchors.fill: parent */
    /* 	color: "green" */

    /* 	Column { */
    /* 	    anchors.fill: parent */
    /* 	    spacing: 10 */
    /* 	    Row { */
    /* 		anchors.left: parent.left */
    /* 		anchors.right: parent.right */
    /* 		spacing: 20 */

    /* 		Text { */
    /* 		    text: "id: " + baseNode.id */
    /* 		} */

    /* 		Text { */
    /* 		    text: "parentId: " + baseNode.parentId */
    /* 		} */

    /* 		Text { */
    /* 		    text: "position: " + baseNode.position */
    /* 		} */

    /* 		Text { */
    /* 		    text: "type: " + baseNode.type */
    /* 		} */

    /* 		Text { */
    /* 		    text: "prio: " + baseNode.priority */
    /* 		} */

    /* 		Text { */
    /* 		    text: "due: " + baseNode.due_date */
    /* 		} */
    /* 	    } */

    /* 	    Row { */
    /* 		anchors.left: parent.left */
    /* 		anchors.right: parent.right */
    /* 		spacing: 20 */

    /* 		Text { */
    /* 		    text: "title: " + baseNode.title */
    /* 		} */

    /* 		Text { */
    /* 		    text: "desc: " + baseNode.description */
    /* 		} */
    /* 	    } */

    /* 	    Text { */
    /* 		visible: text.length > 0 */
    /* 		text: baseNode.description */
    /* 	    } */
	    
    /* 	} */
	
    /* 	/\* onCreatedChanged: { *\/ */
    /* 	/\*     if (created) { *\/ */
    /* 	/\*         sun.z = 1;    // above the sky but below the ground layer *\/ */
    /* 	/\*         window.activeSuns++; *\/ */
    /* 	/\*         // once item is created, start moving offscreen *\/ */
    /* 	/\*         dropYAnim.duration = (window.height + window.centerOffset - sun.y) * 16; *\/ */
    /* 	/\*         dropAnim.running = true; *\/ */
    /* 	/\*     } else { *\/ */
    /* 	/\*         window.activeSuns--; *\/ */
    /* 	/\*     } *\/ */
    /* 	/\* } *\/ */

    /* 	/\* SequentialAnimation on y{ *\/ */
    /* 	/\*     id: dropAnim *\/ */
    /* 	/\*     running: false *\/ */
    /* 	/\*     NumberAnimation { *\/ */
    /* 	/\*         id: dropYAnim *\/ */
    /* 	/\*         to: (window.height / 2) + window.centerOffset *\/ */
    /* 	/\*     } *\/ */
    /* 	/\*     ScriptAction { *\/ */
    /* 	/\*         script: { sun.created = false; sun.destroy() } *\/ */
    /* 	/\*     } *\/ */
    /* 	/\* } *\/ */
    /* } */
}
