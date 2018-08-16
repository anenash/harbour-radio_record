//Database.js
.import QtQuick.LocalStorage 2.0 as Sql

// First, let's create a short helper function to get the database connection
function getDatabase() {
     return Sql.LocalStorage.openDatabaseSync("RecordFM", "1.0", "StorageDatabase", 100000);
}

// At the start of the application, we can initialize the tables we need if they haven't been created yet
function initialize() {
    var db = getDatabase();
    db.transaction(
        function(tx) {
            // Create the settings table if it doesn't already exist
            // If the table exists, this is skipped
            tx.executeSql('CREATE TABLE IF NOT EXISTS favorites(station_id TEXT UNIQUE, title TEXT, logo TEXT)');
      });
}
