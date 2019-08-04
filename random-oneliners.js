
// Unwatch all repos from an organization (run on https://github.com/watching)
Array.from(document.querySelectorAll('.Box-row'))
    .filter((e) => e.innerText.indexOf('ORGNAME') > -1)
    .forEach(e => e.querySelector('button[value=included]').click());


// Update value in indexedDB from console
var dbName = '_ionicstorage';
var tableName = '_ionickv';
var rowID = 'id';

indexedDB.open(dbName).onsuccess = (event) => {
    var db = event.target.result;
    var objectStore = db.transaction([tableName], "readwrite").objectStore(tableName);
    var request = objectStore.get(rowID);

    request.onsuccess = function(event) {
        var data = event.target.result;
        console.log('original', data);

        if (true) {
            data.variable = '';
            objectStore.put(data, rowID);
            console.log('updated');
        }
    };
};