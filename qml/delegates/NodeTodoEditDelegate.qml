import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
    id: root
    anchors{
	left: parent.left
	right: parent.right
    }
    height: 500

    property alias status: progressSlider.value
    property alias mode: modeSwitch.checked

    onModeChanged: {
	if(mode){
	    progressSlider.enabled = false
	    progressSlider.opacity = 0.5
	}else{
	    progressSlider.enabled = true	    
	    progressSlider.opacity = 1.0
	}
    }

    Column {
	anchors.fill: parent
	spacing: Theme.paddingLarge

	Slider {
	    id: progressSlider
    	    width: parent.width
	    label: "Progress"
    	    minimumValue: 0
    	    maximumValue: 100
    	    value: 0
	    stepSize: 5
    	    valueText: value + " %"
	}

	TextSwitch {
	    id: modeSwitch
	    text: "Auto Progress"
	    description: "Show the progress as progress of child TODO items."
	}
	
    }
}
