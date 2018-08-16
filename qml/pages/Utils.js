
var root = /<div class="text_info">[^]*?<\/div>/gm;
var topHref = /href="([^]*?)"/g;
//var artist = /<span class="top100_artist">([^]*?)<\/span>/g;
//var title = /<span class="top100_title">([^]*?)<\/span>/g;
var artist = /artist">([^]*?)<\/span>/g;
var title = /title">([^]*?)<\/span>/g;

function sendHttpRequest(requestType, url, callback, params) {
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState === 4) {
            if (doc.status === 200) {
//                console.log("Get response:", doc.responseText);
                callback(doc.responseText);
            } else {
                callback("error");
            }
        }
    }
    doc.open(requestType, url);
    if(requestType === "GET") {
        doc.setRequestHeader('User-Agent', 'Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20100101 Firefox/21.0');
        doc.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    } else {
        doc.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
    }
    console.log("send url", url);
    doc.send(params);
}

function getTop100(data, callback) {
    var res = data.match(root)
    var arr = []
//    console.log("Parsing result", res);
    for(var i in res) {
        var r = getInfo(res[i])
        if(r) {
            arr.push(r)
            callback.append(r)
            console.log(JSON.stringify(r))
        }
    }
    return arr;
}

function getInfo(data) {
    var res1 = topHref.exec(data)
    var res2 = ""
    var res3 = ""
    if(res1) {
        res2 = artist.exec(data)
        if(res2) {
            res3 = title.exec(data)
            if(res3) {
                console.log(data, "Id", res1[1], "artist", res2[1], "title", res3[1])
                return {"href": res1[1], "artist": res2[1], "title": res3[1]}
            }
        }
    }
    console.log("Parsing error for:", data)
}
