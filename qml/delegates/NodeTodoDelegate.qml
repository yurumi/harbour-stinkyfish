import QtQuick 2.0
import Sailfish.Silica 1.0

import "../js/Database.js" as Database

BaseNode {
    id: baseNode
    width: parent.width
    height: content.height

    property int status: -1
    property double statusAuto: 0.0
    property int numSubTodos: 0

    function update() {
	if(mode == 1){
	    statusAuto = calcChildrenProgress(id)
	} // mode == 1
    }

    function calcChildrenProgress(parentId){
	var ret = 0
	var children = Database.getChildNodes(parentId)
	var sumProgress = 0
	var numTodoNodes = 0
	for(var i=0; i<children.rows.length; ++i){
	    if(children.rows[i].type == Database.nodeTypeTODO){
		var childStatus = 0
		if(children.rows[i].mode == 1){
		    childStatus = calcChildrenProgress(children.rows[i].id)
		}else{
		    var customData = Database.getNodeDataTodo(children.rows[i].id)
		    childStatus = customData.rows[0].status   
		}
		
		sumProgress += childStatus
		numTodoNodes++;
	    }
	}

	if(numTodoNodes > 0){
	    ret = sumProgress / numTodoNodes
	    console.log("     --->", ret)	   
	}

	if(parentId == baseNode.id){
	    numSubTodos = numTodoNodes
	}

	return ret
    }
    
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

	Row {
	    
	    Rectangle {
		id: progressVis
		width: 100
		height: contentColumn.height
		color: "transparent"

		Canvas {
		    anchors.fill: parent
		    visible: mode == 1
		    onPaint: {
			var ctx = getContext("2d");
			ctx.reset();

			var centreX = width / 2;
			var centreY = height / 2;

			var angle1 = -Math.PI * 0.5
			var angle2 = angle1 + statusAuto / 100.0 * 2.0 * Math.PI;
			
			ctx.beginPath();
			ctx.fillStyle = Theme.highlightDimmerColor;
			ctx.moveTo(centreX, centreY);
			/* ctx.arc(centreX, centreY, width / 4, angle2, angle1, false); */
			ctx.arc(centreX, centreY, width / 2 - Theme.paddingMedium, 0.0, 2.0 * Math.PI, false);
			ctx.lineTo(centreX, centreY);
			ctx.fill();

			ctx.beginPath();
			ctx.fillStyle = Theme.highlightColor;
			ctx.moveTo(centreX, centreY);
			ctx.arc(centreX, centreY, width / 2 - Theme.paddingMedium, angle1, angle2, false);
			ctx.lineTo(centreX, centreY);
			ctx.fill();

		    	ctx.beginPath();
			ctx.fillStyle = Theme.highlightDimmerColor;
			ctx.moveTo(centreX, centreY);
			/* ctx.arc(centreX, centreY, width / 4, angle2, angle1, false); */
			ctx.arc(centreX, centreY, width / 4, 0.0, 2.0 * Math.PI, false);
			ctx.lineTo(centreX, centreY);
			ctx.fill();
		    }

		    Text {
			id: numSubTodosText
			anchors.centerIn: parent
			text: numSubTodos
			color: Theme.highlightColor
			font.pixelSize: Theme.fontSizeSmall
		    }
		}

		ProgressCircle {
		    id: progressCircle
		    anchors.fill: parent
		    anchors.margins: Theme.paddingMedium
		    progressColor: Theme.highlightColor
		    backgroundColor: Theme.highlightDimmerColor
		    value: baseNode.status / 100.0
		    visible: mode == 0
		}

		MouseArea {
		    anchors.fill: parent
		    onClicked: {
			if(baseNode.status < 25.0){
			    baseNode.status = 25.0
			}
			else if(baseNode.status < 50.0){
			    baseNode.status = 50.0			    
			}
			else if(baseNode.status < 75.0){
			    baseNode.status = 75.0			    
			}
			else if(baseNode.status < 100.0){
			    baseNode.status = 100.0			    
			}
			else if(baseNode.status > 99.9){
			    baseNode.status = 0.0
			}

			var data = {
			    'type': Database.nodeTypeTODO,
			    'id': baseNode.id,
			    'status': baseNode.status			    
				   }
			Database.updateNodeCustomData(data)
		    }
		}
	    }

	    Column {
		id: contentColumn
		width: content.width - progressVis.width - Theme.paddingLarge
		height: {
		    var ret
		    if(descriptionItem.visible){
			ret = titleRow.height + descriptionItem.height}
		    else{
			ret = titleRow.height
		    }
		    return Math.max(ret, progressVis.width)
		}
		
		Item {
		    id: titleRow
		    width: parent.width
		    height: {
			if(descriptionItem.visible){
			    titleText.height
			}else{
			    Math.max(progressVis.width, titleText.height)
			}
		    }
		    
		    Text {
			id: titleText
			anchors.left: parent.left
			anchors.right: if(childCounter.visible){childCounter.left}else{parent.right}
			anchors.verticalCenter: parent.verticalCenter
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
	} // row
    } // content
}
