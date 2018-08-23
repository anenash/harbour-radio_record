import QtQuick 2.6
import QtQuick.LocalStorage 2.0 as Sql

Item {

    property variant record

    QtObject {
        id: internal

        // reference to the database object
        property var _db
    }

    function initDatabase() {
        // initialize the database object
        console.log('initDatabase()')
        internal._db = Sql.LocalStorage.openDatabaseSync("RecordFM", "1.0", "Radio record StorageDatabase", 100000)
        internal._db.transaction( function(tx) {
            // Create the database if it doesn't already exist
            console.log("Create the database if it doesn't already exist")
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(station TEXT, additionalInfo TEXT)')
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(settingsName TEXT, indexS TEXT, value TEXT)')
        })
    }

    function storeSettings(name, index, value) {
        console.log('storeSettings()')
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            console.log('check if a record exists')
            var result = tx.executeSql('SELECT * from settings WHERE settingsName=?', [name])
            if(result.rows.length === 1) {// use update
                console.log('record exists, update it')
                result = tx.executeSql('UPDATE settings SET indexS=?, value=? where settingsName=?', [index, value, name])
            } else { // use insert
                console.log('record does not exist, create it', name, value)
                result = tx.executeSql('INSERT INTO settings VALUES (?,?,?)', [name, index, value])
                console.log('record does not exist, create it result', JSON.stringify(result))
            }
        })
    }

    function getSettings(name) {
        // reads and applies data from _db
        console.log('getSettings()')
        var res
        if (!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT indexS from settings WHERE settingsName=?', [name])
            console.log("Get all data from the settings table result\n", JSON.stringify(result))
            if(result.rows.length === 1) {
                res = result.rows.item(0).indexS
            }
        })
        return res
    }

    function getSettingsValue(name) {
        // reads and applies data from _db
        console.log('getSettings()')
        var res
        if (!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT value from settings WHERE settingsName=?', [name])
            console.log("Get all data from the settings table result\n", JSON.stringify(result))
            if(result.rows.length === 1) {
                res = result.rows.item(0).value
            }
        })
        return res
    }

    function storeData(trackNumber, additionalInfo, oldTrackNumber) {
        // stores data to _db
        console.log('storeData()')
        if(!internal._db) { return }
        internal._db.transaction( function(tx) {
            console.log('check if a record exists')
            var result = tx.executeSql('SELECT * from trackData WHERE trackingNumber=?', [oldTrackNumber])
            if(result.rows.length === 1) {// use update
                console.log('record exists, update it')
                result = tx.executeSql('UPDATE trackData SET trackingNumber=?, additionalInfo=? where trackingNumber=?', [trackNumber, additionalInfo, oldTrackNumber])
            } else { // use insert
                console.log('record does not exist, create it', trackNumber, additionalInfo)
                result = tx.executeSql('INSERT INTO trackData VALUES (?,?)', [trackNumber, additionalInfo])
                console.log('record does not exist, create it result', JSON.stringify(result))
            }
        })
    }

    function readData(model) {
        // reads and applies data from _db
        console.log('readData()')
        if (!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT * from trackData')
            console.log("Get all data from the trackData table result\n", JSON.stringify(result))
            for (var i = 0; i < result.rows.length; i++) {
                console.log("database result", result.rows.item(i).trackingNumber, result.rows.item(i).additionalInfo)
                model.insert(0, {"trackingNumber": result.rows.item(i).trackingNumber, "additionalInfo": result.rows.item(i).additionalInfo})
            }
        })
    }

    function readRecord(trackNumber) {
        // reads and applies data from _db
        console.log('readData()')
        if (!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('SELECT * from trackData WHERE trackingNumber=?', [trackNumber])
            console.log("Get data from the trackData table result\n", JSON.stringify(result))
            if (result.rows.length === 1) {
                console.log("database result", result.rows.item(0).trackingNumber, result.rows.item(0).additionalInfo)
                record = {"trackingNumber": result.rows.item(0).trackingNumber, "additionalInfo": result.rows.item(0).additionalInfo}
            }
        })
    }

    function deleteRecord(trackNumber) {
        // reads and applies data from _db
        console.log('readData()')
        if (!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('DELETE from trackData WHERE trackingNumber=?', [trackNumber])
            console.log("Delete data from the trackData table result\n", JSON.stringify(result))
        })
    }

    function dropSettings() {
        console.log('dropSettings()')
        if (!internal._db) { return }
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('DROP TABLE IF EXISTS settings')
            console.log("Drop settings table result\n", JSON.stringify(result))
        })
        internal._db.transaction( function(tx) {
            var result = tx.executeSql('CREATE TABLE IF NOT EXISTS settings(settingsName TEXT, indexS TEXT, value TEXT)')
            console.log("Create new settings table result\n", JSON.stringify(result))
        })
    }

    Component.onCompleted: {
        initDatabase()
    }
}

