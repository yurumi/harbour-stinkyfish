import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

import "pages"
import "delegates"
/* import "js/Database.js" as Database */

ApplicationWindow
{
    id: appWindow
    initialPage: Component { NodePage { id: nodePage; parentNodeId: 0 } }
    /* initialPage: Component { Test{} } */
    state: "VIEW"

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: Orientation.Portrait
    _defaultPageOrientations: Orientation.Portrait

    /* property int cutNodesParentId: -1 */

    states: [
        State {
            name: "VIEW"
            StateChangeScript{ script: pageStack.currentPage.clearSelection()}
        },
        State {
            name: "SELECT"
        },
        State {
            name: "PASTE"
        }
    ]

    Item {
        id: initDataItem

        Component.onCompleted: {
            /* Database.checkDbVersion() */

            /* Database.clear() */
            /* Database.createNodeTodo({'parentId': 0, 'position': 0, 'type': Database.nodeTypeTODO, 'title': "todo 0.0", 'description': "uvleg uvle gvl e", 'priority': 0, 'due_date': ""}) */
            /* Database.createNodeTodo({'parentId': 0, 'position': 1, 'type': Database.nodeTypeTODO, 'title': "todo 0.1", 'description': "", 'priority': 1, 'due_date': ""}) */
            /* Database.createNodeTodo({'parentId': 1, 'position': 0, 'type': Database.nodeTypeTODO, 'title': "todo 1.0", 'description': "vflg", 'priority': 2, 'due_date': ""}) */

            /* Database.printTables() */
        }
    }

    Component.onDestruction: {
        /* console.log("Destroy Database") */
        /* Database.clear() */
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('./python'));
            console.log('hello')
            /* console.log(Qt.resolvedUrl('../src')) */

            /* setHandler('progress', function(ratio) { */
            /*     dlprogress.value = ratio; */
            /* }); */
            /* setHandler('finished', function(newvalue) { */
            /*     page.downloading = false; */
            /*     mainLabel.text = 'Color is ' + newvalue + '.'; */
            /* }); */

            importModule('entry_point', function () {});
        }

        /* function startDownload() { */
        /*     page.downloading = true; */
        /*     dlprogress.value = 0.0; */
        /*     call('datadownloader.downloader.download', function() {}); */
        /* } */

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
        }
    }
}
