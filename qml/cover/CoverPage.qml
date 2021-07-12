import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage
    
    Label {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: coverImage.top
            bottomMargin: Theme.paddingLarge
        }

        text: "Stinkyfish"
    }

    Image {
        id: coverImage
        source: "qrc:///img/arnold.png"
        asynchronous: true
        opacity: 0.5
        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        fillMode: Image.PreserveAspectFit
    }


    /* CoverActionList { */
    /*     id: coverAction */

    /*     CoverAction { */
    /*         iconSource: "image://theme/icon-cover-next" */
    /*     } */

    /*     CoverAction { */
    /*         iconSource: "image://theme/icon-cover-pause" */
    /*     } */
    /* } */
}


