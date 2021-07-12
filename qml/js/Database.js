.pragma library

.import QtQuick.LocalStorage 2.0 as Storage

var DB_VERSION = '0.1';

var nodeTypeNOTE = 'NOTE'
var nodeTypeTODO = 'TODO'
var nodeTypeCALC = 'CALC'
var nodeTypeCHECKLIST = 'CHECKLIST'
var nodeTypeURL = 'URL'
var nodeTypeCRYPT = 'CRYPT'
var nodeTypeSKETCH = 'SKETCH'
var nodeTypeIMAGE = 'IMAGE'
var nodeTypeGEOLOC = 'GEOLOC'

// PRAGMA NOT SUPPORTED IN WEBSQL (WHICH IS USED BY QT QUICK)
// function pragmaInit()
// {
//     instance().transaction(function(tx) {
// 	tx.executeSql('PRAGMA foreign_keys = ON;')
//     });
// }

function checkDbVersion()
{
    var db = Storage.LocalStorage.openDatabaseSync('StinkyFishDb', '', 'Nodes', 5000000);  /* DB Size: 5MB */
    console.log('CHECK DB VERSION: ', db.version)
    if (db.version === '') {
        db.changeVersion('', DB_VERSION, initDb);
	    return true;
    }

    return db.version === DB_VERSION;
}

function updateDbSchema()
{
    try{
    	var db = Storage.LocalStorage.openDatabaseSync('StinkyFishDb', DB_VERSION, 'Nodes', 5000000);  /* DB Size: 5MB */
    } catch (sqlErr) {
        console.log('(UpdateSchema) SQL Error: ', sqlErr);

    	if(sqlErr.code === SQLException.VERSION_ERR){
    	    var db = Storage.LocalStorage.openDatabaseSync('StinkyFishDb', '', 'Nodes', 5000000);  /* DB Size: 5MB */
    	    var currentVersion = db.version;
    	    var nextVersion = currentVersion

    	    // // Update V1.0 --> V1.5
    	    // if(currentVersion === '1.0'){
    	    // 	nextVersion = '1.5'
    	    // 	console.log('Update article DB schema from version', currentVersion, 'to version', nextVersion);
    	    // 	db.changeVersion(currentVersion, nextVersion, function(tx){
    	    // 	    tx.executeSql('ALTER TABLE Articles ADD COLUMN syncAction TEXT');

    	    // 	    var res = tx.executeSql('SELECT * FROM Articles WHERE archiveFlag=1')
    	    // 	    for(var i=0; i < res.rows.length; i++){
    	    // 		tx.executeSql('UPDATE Articles SET archiveFlag=0, syncState=2, syncAction="archive" WHERE id=?', res.rows[i].id);
    	    // 	    }

    	    // 	    res = tx.executeSql('SELECT * FROM Articles WHERE deletionFlag=1')
    	    // 	    for(var i=0; i < res.rows.length; i++){
    	    // 		tx.executeSql('UPDATE Articles SET deletionFlag=0, syncState=2, syncAction="delete" WHERE id=?', res.rows[i].id);
    	    // 	    }

    	    // 	    res = tx.executeSql('SELECT * FROM Articles WHERE syncState=0')
    	    // 	    for(var i=0; i < res.rows.length; i++){
    	    // 		tx.executeSql('UPDATE Articles SET syncState=1, syncAction="none" WHERE id=?', res.rows[i].id);
    	    // 	    }
    	    // 	})
    	    // }// V1.0 --> V1.5

    	    // Next update try
    	    updateDbSchema();

    	}// VERSION_ERR
    }// catch (sqlErr)
}

function instance()
{
    var db = Storage.LocalStorage.openDatabaseSync('StinkyFishDb', '', 'Nodes', 5000000);  /* DB Size: 5MB */
    db.transaction(function(tx) {
        tx.executeSql('PRAGMA foreign_keys = ON;');
    });
    return db
}

function initDb(tx)
{
    console.log('INIT DB, version:', DB_VERSION)
    
    tx.executeSql( 'CREATE TABLE IF NOT EXISTS NodeMetaData ' +
		           '(id INTEGER PRIMARY KEY, parentId INTEGER, position INTEGER, type TEXT, title TEXT, description TEXT, priority INTEGER, due_date DATETIME, mode INTEGER)' )

    tx.executeSql( 'CREATE TABLE IF NOT EXISTS NodeDataNote (refId INTEGER NOT NULL, FOREIGN KEY(refId) REFERENCES NodeMetaData(id) ON DELETE CASCADE);');

    tx.executeSql( 'CREATE TABLE IF NOT EXISTS NodeDataTodo (refId INTEGER NOT NULL, ' +
		           'status INTEGER, ' +
		           'FOREIGN KEY(refId) REFERENCES NodeMetaData(id) ON DELETE CASCADE);');

    tx.executeSql( 'CREATE TABLE IF NOT EXISTS NodeDataCalc (refId INTEGER NOT NULL, ' +
		           'operator TEXT, ' +
		           'value TEXT, ' +
		           'FOREIGN KEY(refId) REFERENCES NodeMetaData(id) ON DELETE CASCADE);');

    // createTutorial();
}

function clear()
{
    console.log('CLEAR DB')
    instance().transaction(function(tx) {
        tx.executeSql('DROP TABLE IF EXISTS NodeMetaData');
        tx.executeSql('DROP TABLE IF EXISTS NodeDataNote');
        tx.executeSql('DROP TABLE IF EXISTS NodeDataTodo');
        tx.executeSql('DROP TABLE IF EXISTS NodeDataCalc');
	    initDb(tx)
    });
}

function createTutorial()
{
    function createNodeDataTemplate(parentId, title, desc, nodeType){
        title = typeof title === 'undefined' ? '' : title;
        desc = typeof desc === 'undefined' ? '' : desc;
        nodeType = typeof nodeType === 'undefined' ? nodeTypeNOTE : nodeType;

        var data = {'parentId': parentId,
                    'position': 0,
                    'type': nodeType,
                    'title': title,
                    'description': desc,
                    'priority': 0,
                    'due_date': '',
                    'mode': 0};
        return data;
    }

    function createBaseNode(){
        var data = createNodeDataTemplate(0, 'Tutorial', 'Tap to enter.');
        return createNode(data);
    }

    function createHierarchyNodes(baseId){
        var level_0 = createNode(createNodeDataTemplate(baseId, 'Hierarchies...', 'Tap to enter.'));
        var level_1 = createNode(createNodeDataTemplate(level_0, '...can...', 'Tap to enter.'));
        var level_2 = createNode(createNodeDataTemplate(level_1, '...be...', 'Tap to enter.'));
        createNode(createNodeDataTemplate(level_2, '...deep.', 'Swipe left to right to go up.'));
    }

    function createNodeTypesNodes(baseId){
        var parentId = createNode(createNodeDataTemplate(baseId, 'Node types', 'One development goal was to have different node types for special purposes. Only few ideas got implemented - Paid app support where art thou?'));
        createNode(createNodeDataTemplate(parentId, 'Note (without description)'));
        createNode(createNodeDataTemplate(parentId, 'Note', 'With description.'));
        createNode(createNodeDataTemplate(parentId, 'Todo', 'Without Sub-Todos. Tap left circle to adjust progress.', nodeTypeTODO));
        var todoNodeData = createNodeDataTemplate(parentId, 'Todo', 'With Sub-Todos and auto update of overall progress', nodeTypeTODO);
        todoNodeData['mode'] = 1;
        var todoId = createNode(todoNodeData);
        var todoNodeDataProgress1 = createNodeDataTemplate(todoId, 'Todo 1', '', nodeTypeTODO);
        todoNodeDataProgress1['status'] = 50.0;
        createNode(todoNodeDataProgress1);
        var todoNodeDataProgress2 = createNodeDataTemplate(todoId, 'Todo 2', '', nodeTypeTODO);
        todoNodeDataProgress2['status'] = 25.0;
        createNode(todoNodeDataProgress2);
        var todoNodeDataProgress3 = createNodeDataTemplate(todoId, 'Todo 3', '', nodeTypeTODO);
        todoNodeDataProgress3['status'] = 100.0;
        createNode(todoNodeDataProgress3);
    }
   
    var baseId = createBaseNode();
    createHierarchyNodes(baseId);
    createNodeTypesNodes(baseId);

    moveNodeTop(baseId);
}

function createMetaNode(parentId, position, type, title, description, priority, due_date, mode)
{
    var refId
    instance().transaction(function(tx) {
	    var obj = tx.executeSql('INSERT INTO NodeMetaData (parentId, position, type, title, description, priority, due_date, mode) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
				                [parentId, position, type, title, description, priority, due_date, mode])
	    refId = obj.insertId

	    console.log(JSON.stringify(obj))
    });

    return refId
}

function createNode(data)
{
    var refId = createMetaNode(data.parentId,
			                   data.position,
			                   data.type,
			                   data.title,
			                   data.description,
			                   data.priority,
			                   data.due_date,
			                   data.mode
			                  );
    
    if(data.type === 'NOTE'){
	    console.log('create NOTE:', data.parentId, data.title, data.description, data.priority);
	    createNodeNote(data, refId)
    }
    else if(data.type === 'TODO'){
	    console.log('create TODO:', data.position, data.title, data.description, data.status);
	    createNodeTodo(data, refId);
    }
    else if(data.type === 'CALC'){
	    console.log('create CALC:', data.title, data.description);
    }

    return refId
}

function createNodeNote(data, refId)
{
    instance().transaction(function(tx) {
        console.log('CREATE DATA FOR NODE ', refId, ' (type: ', data.type, ')')
	    var obj = tx.executeSql('INSERT INTO NodeDataNote (refId) VALUES (?)', [refId])
    });

    return refId
}

function createNodeTodo(data, refId)
{
    instance().transaction(function(tx) {
	    console.log('CREATE DATA FOR NODE ', refId, ' (type: ', data.type, ')')
	    var obj = tx.executeSql('INSERT INTO NodeDataTodo (refId, status) VALUES (?, ?)', [refId, data.status])
    });

    return refId
}

function createNodeCalc(data, refId)
{
    instance().transaction(function(tx) {
	    console.log('CREATE DATA FOR NODE ', refId, ' (type: ', data.type, ')')
	    var obj = tx.executeSql('INSERT INTO NodeDataCalc (refId, operator, value) VALUES (?, ?, ?)', [refId, data.operator, data.value])
    });

    return refId
}

function updateNode(data)
{
    instance().transaction(function(tx) {
	    var obj = tx.executeSql('UPDATE NodeMetaData SET type=?, title=?, description=?, priority=?, due_date=?, mode=? WHERE id=?;',
				                [data.type, data.title, data.description, data.priority, data.due_date, data.mode, data.id])
    });

    updateNodeCustomData(data);
}

function updateNodeCustomData(data){
    if(data.type = nodeTypeTODO){
	    instance().transaction(function(tx) {
	        var obj = tx.executeSql('UPDATE NodeDataTodo SET status=? WHERE refId=?;', [data.status, data.id])
	    });
    }
}

function calculateNodeDynamicData(id){
    var metaNode = getMetaNode(id);
    var data;
    if(metaNode.type = nodeTypeTODO){
	    var children = getChildNodes(id);

	    instance().transaction(function(tx) {
	        var obj = tx.executeSql('UPDATE NodeDataTodo SET status=? WHERE refId=?;', [data.status, data.id])
	    });
    }
    return data;
}

function getChildNodes(parentId)
{
    var childNodes;
    
    instance().transaction(function(tx) {
	    childNodes = tx.executeSql('SELECT * FROM NodeMetaData WHERE parentId=? ORDER BY position', [parentId]);
    });

    return childNodes;
}

function getNumChildren(parentId)
{
    var children = getChildNodes(parentId);
    return children.rows.length;
}

function getMetaNode(id)
{
    var metaNode;
    instance().transaction(function(tx) {
	    metaNode = tx.executeSql('SELECT * FROM NodeMetaData WHERE id=?', [id])
    });
    return metaNode.rows.item(0);
}

function getMetaSiblingAtPosition(parentId, position)
{
    var metaNode;
    instance().transaction(function(tx) {
	    metaNode = tx.executeSql('SELECT * FROM NodeMetaData WHERE parentId=? AND position=?', [parentId, position])
    });
    return metaNode.rows.item(0);
}

function getNodeDataTodo(id)
{
    var data
    
    instance().transaction(function(tx) {
	    data = tx.executeSql('SELECT * FROM NodeDataTodo WHERE refId=?', [id])
    });

    return data    
}

function getNodeDataCalc(id)
{
    var data
    
    instance().transaction(function(tx) {
	    data = tx.executeSql('SELECT * FROM NodeDataCalc WHERE refId=?', [id])
    });

    return data    
}

function deleteNode(id)
{
    var childNodes = getChildNodes(id);
    for(var i=0; i<childNodes.rows.length; ++i){
	    deleteNode(childNodes.rows[i].id);
    }

    instance().transaction(function(tx) {
    	var rs = tx.executeSql('DELETE FROM NodeMetaData WHERE id=?', [id])
    });

    // Workaround for unsupported FOREIGN KEY (ON DELETE CASCADE)
    instance().transaction(function(tx) {
    	var rs = tx.executeSql('DELETE FROM NodeDataTodo WHERE refId=?', [id])
    });    
    instance().transaction(function(tx) {
    	var rs = tx.executeSql('DELETE FROM NodeDataNote WHERE refId=?', [id])
    });
    instance().transaction(function(tx) {
    	var rs = tx.executeSql('DELETE FROM NodeDataCalc WHERE refId=?', [id])
    });    

}

function cutNodes(selectedIds)
{
    var db = instance();
    db.transaction(function(tx) {	
	    for(var i=0; i<selectedIds.length; ++i){
            tx.executeSql('UPDATE NodeMetaData SET parentId=-1 WHERE id=?;', [selectedIds[i]]);
	    }
    })
}

function cancelCutNodes(parentId)
{
    var db = instance();
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT * FROM NodeMetaData WHERE parentId=-1;');
	    for(var i=0; i<rs.rows.length; ++i){
            tx.executeSql('UPDATE NodeMetaData SET parentId=? WHERE id=?;', [parentId, rs.rows.item(i).id]);
	    }
    })
}

function pasteNodes(parentId)
{
    var posOffset = getNumChildren(parentId);

    var db = instance();
    db.transaction(function(tx) {	
        var rs = tx.executeSql('SELECT * FROM NodeMetaData WHERE parentId=-1;');
	    for(var i=0; i<rs.rows.length; ++i){
	        console.log('UPDATE ID', rs.rows.item(i).id, posOffset+i, parentId);
            tx.executeSql('UPDATE NodeMetaData SET parentId=?, position=? WHERE id=?;', [parentId, posOffset+i, rs.rows.item(i).id]);
	    }
    })    
}

function sanitizeNodePositions(parentId)
{
    var children = getChildNodes(parentId);
    var db = instance();
    db.transaction(function(tx) {	
	    for(var i=0; i<children.rows.length; ++i){
            tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [i, children.rows.item(i).id]);
	    }
    })
}

function swapNodePositions(firstNode, secondNode)
{
    var db = instance();
    db.transaction(function(tx) {	
        tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [secondNode.position, firstNode.id]);
        tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [firstNode.position, secondNode.id]);
    });    
}

function moveNodeUp(id)
{
    var firstNode = getMetaNode(id);
    if(firstNode.position > 0){
	    var secondNode = getMetaSiblingAtPosition(firstNode.parentId, firstNode.position - 1);
	    swapNodePositions(firstNode, secondNode);
    }
}

function moveNodeTop(id)
{
    var nodeToMove = getMetaNode(id);
    var children = getChildNodes(nodeToMove.parentId);

    instance().transaction(function(tx) {	
        tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [0, nodeToMove.id]);

	    var pos = 1;
	    for(var i=0; i<children.rows.length; ++i){
	        var childId = children.rows.item(i).id;
	        if(childId != nodeToMove.id){
		        tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [pos, childId]);
		        pos++;
	        }
	    }
    });
}

function moveNodeBottom(id)
{
    var nodeToMove = getMetaNode(id);
    var children = getChildNodes(nodeToMove.parentId);

    instance().transaction(function(tx) {	
        tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [children.rows.length-1, id]);

	    var pos = 0;
	    for(var i=0; i<children.rows.length; ++i){
	        var childId = children.rows.item(i).id;
	        if(childId != nodeToMove.id){
		        tx.executeSql('UPDATE NodeMetaData SET position=? WHERE id=?;', [pos, childId]);
		        pos++;
	        }
	    }
    });
}

function moveNodeDown(id)
{
    var firstNode = getMetaNode(id);
    if(firstNode.position < (getNumChildren(firstNode.parentId) - 1)){
	    var secondNode = getMetaSiblingAtPosition(firstNode.parentId, firstNode.position + 1);
	    swapNodePositions(firstNode, secondNode);
    }
}

function printTables() {
    var db = instance();
    db.transaction(function(tx) {	
        var rs = tx.executeSql('SELECT name FROM sqlite_master WHERE type="table" ORDER BY name;');
        for(var i = 0; i < rs.rows.length; i++) {
            var dbItem = rs.rows.item(i);
            console.log('Name: ' + dbItem.name);
        }
    });

    console.log('********** NodeMetaData **********')
    db.transaction( function(tx) {
	    var rs = tx.executeSql('SELECT * FROM NodeMetaData;');
	    for(var i=0; i < rs.rows.length; i++){
	        var dbItem = rs.rows.item(i)
	        console.log('   id: ', dbItem.id, ', parentId: ', dbItem.parentId, ', type: ', dbItem.type, ', pos: ', dbItem.position, ', mode: ', dbItem.mode)
	    }
    });
    
    console.log('********** NodeDataNote **********')
    db.transaction( function(tx) {
	    var rs = tx.executeSql('SELECT * FROM NodeDataNote;');
	    for(var i=0; i < rs.rows.length; i++){
	        var dbItem = rs.rows.item(i)
	        console.log('   refId: ', dbItem.refId)
	    }
    });

    console.log('********** NodeDataTodo **********')
    db.transaction( function(tx) {
	    var rs = tx.executeSql('SELECT * FROM NodeDataTodo;');
	    for(var i=0; i < rs.rows.length; i++){
	        var dbItem = rs.rows.item(i)
	        console.log('   refId: ', dbItem.refId, ', status: ', dbItem.status)
	    }
    });

    console.log('********** NodeDataCalc **********')
    db.transaction( function(tx) {
	    var rs = tx.executeSql('SELECT * FROM NodeDataCalc;');
	    for(var i=0; i < rs.rows.length; i++){
	        var dbItem = rs.rows.item(i)
	        console.log('   refId: ', dbItem.refId, ', operator: ', dbItem.operator, ', value: ', dbItem.value)
	    }
    });
}
