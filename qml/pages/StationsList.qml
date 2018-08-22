import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils
import "Database.js" as Database

Page {
    id: stationsPage
    //"http://air2.radiorecord.ru:805/rr_320"
    property string _streamUrl: "http://air2.radiorecord.ru:805/"
    property string _streamBitrate: "_320"

    //http://www.radiorecord.ru/player/img/logos/rr.jpg
    property string _radioLogo: "http://www.radiorecord.ru/player/img/logos/"

    //https://www.radiorecord.ru/xml/ps_online_v8.txt
    property string trackStartUrl: "https://www.radiorecord.ru/radio/"
    property string trackEndUrl: "_online_v8.txt"

    property string currentStationId

    property string nextPageTitle: qsTr("Top 100")

    property bool showHint: true

    anchors.margins: 5 * Theme.pixelRatio

    signal playNext();

    QtObject {
        id: internal

        property bool isRadio: true
    }

    Component.onCompleted: {
//        tapHint.start()
        Utils.sendHttpRequest("GET", Utils.stationsUrl, getStationsList)
    }

    Timer {
        id: updateTrack
        repeat: true
        interval: 7000
        onTriggered: {
            Utils.sendHttpRequest("GET", Utils.tracksUrl, getTrackInfo);
        }
    }

    function getStationsList(data) {
        if(data === "error") {
            Utils.sendHttpRequest("GET", Utils.stationsUrl, getStationsList)
            return;
        }
        var json = JSON.parse(data);
        for (var i in json.result) {
            stationsList.append(json.result[i])
        }
        Utils.sendHttpRequest("GET", Utils.podcastIdsUrl, getPocastsList)
    }

    function getPocastsList(data) {
        if(data === "error") {
            Utils.sendHttpRequest("GET", Utils.podcastIdsUrl, getPocastsList)
            return;
        }
        var json = JSON.parse(data);
        for (var i in json.result) {
            podcastsList.append(json.result[i])
        }
    }

    function getTrackInfo(data) {
        if(data === "error") {
            console.debug("getTrackInfo: Source does not found.")
            return;
        }
        var json = JSON.parse(data);

        for (var i in json.result) {
            if (json.result[i].prefix.toString() === currentStationId.toString()) {
                playerItem.stationLogo = json.result[i].image600
                app.radioIcon = json.result[i].image600

                app.radioFullTitle = "Artist: " + json.result[i].artist + "\nTitle: " + json.result[i].song
                app.radioTitle = "<b>" + json.result[i].artist + "</b><br>" + json.result[i].song
            }
        }
    }

//    InteractionHintLabel {
//        anchors.bottom: parent.bottom
//        z: 3
//        opacity: showHint
//        Behavior on opacity { FadeAnimation {} }
//        text: qsTr("Tap and hold to open context menu")
//    }
    
//    TapInteractionHint {
//        id: tapHint
//        loops: Animation.Infinite
//        anchors.centerIn: parent
//    }

    ListModel {
        id: stationsList
    }

    ListModel {
        id: podcastsList
    }

    Component {
        id: stationDelegate
        ListItem {
            contentHeight: Theme.itemSizeLarge
            Image {
                id: radioLogo
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                height: 96 * Theme.pixelRatio
                width: 96 * Theme.pixelRatio
                fillMode: Image.PreserveAspectFit
                source: icon_png
                BusyIndicator {
                    size: BusyIndicatorSize.Medium
                    anchors.centerIn: radioLogo
                    running: radioLogo.status != Image.Ready
                }
                onStatusChanged: {
                    if(status === Image.Error) {
                        console.debug("Can not load image");
                        source = "RadioRecord.png"
                    }
                }
            }
            Label {
                anchors.left: radioLogo.right
                anchors.leftMargin: 5
                anchors.verticalCenter: radioLogo.verticalCenter
                text: title
            }

            menu: ContextMenu {
                MenuItem {
                    text: "Show top 100"
                    onClicked: {
                        console.debug("Show top 100")
                        updateTrack.stop();
                        playerItem.stationLogo = "RadioRecord.png"
                        nextPageTitle = qsTr("Top 100 ") + title
                        var url = trackStartUrl + "top100/" + prefix + ".txt";
                        Utils.sendHttpRequest("GET", url, processData);                        ;
                    }
                }
                MenuItem {
                    text: "Show history"
                    onClicked: {
                        console.debug("Show history")
                        ////history.radiorecord.ru/index-flat.php?station='+radio+'&day=today'
                        var url = "http://history.radiorecord.ru/index-flat.php?station=" + prefix + "&day=today"
                        updateTrack.stop()
                        nextPageTitle = title + qsTr(" history")
                        playerItem.stationLogo = "RadioRecord.png"
                        Utils.sendHttpRequest("GET", url, processData);
                    }
                }
            }

            function processData(data) {
                app.showFullControl = true
                pageStack.push(Qt.resolvedUrl("Top100_history.qml"), {htmlData: data, pageHeader: nextPageTitle});
            }

//            onPressed: {
//                showHint = false
//                tapHint.stop()
//            }

            onClicked: {
                radioView.currentIndex = index
                currentStationId = prefix
                playerItem.streamBitrate = _streamBitrate === "_320"?"320 kbps":_streamBitrate === "_128"?"128 kbps":"32 kbps"

                radioIcon = icon_png
                radioTitle = title
                player.stop()
                player.source = _streamBitrate === "_320"?stream_320:_streamBitrate === "_128"?stream_128:stream_64 //_streamUrl + prefix + _streamBitrate
                player.play()
                Utils.sendHttpRequest("GET", Utils.tracksUrl, getTrackInfo)
                updateTrack.start()
                drawer.open = true
            }
        }
    }

    Component {
        id: podcastDelegate
        ListItem {
            contentHeight: Theme.itemSizeLarge
            Image {
                id: podcastLogo
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                height: 96 * Theme.pixelRatio
                width: 96 * Theme.pixelRatio
                fillMode: Image.PreserveAspectFit
                source: cover
                BusyIndicator {
                    size: BusyIndicatorSize.Medium
                    anchors.centerIn: podcastLogo
                    running: podcastLogo.status != Image.Ready
                }
                onStatusChanged: {
                    if(status === Image.Error) {
                        console.debug("Can not load image");
                        source = "RadioRecord.png"
                    }
                }
            }
            Label {
                anchors.left: podcastLogo.right
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.verticalCenter: podcastLogo.verticalCenter
                text: name
            }

            onClicked: {
                radioView.currentIndex = index

                radioIcon = cover
                radioTitle = name
                pageStack.push(Qt.resolvedUrl("PodcastPage.qml"), {id: id})
            }
        }
    }

    Drawer {
        id: drawer

        anchors.fill: parent
        dock: Dock.Bottom
        open: radioPlayer.source != ""?true:false

        background: PlayerItem {
            id: playerItem
            anchors.fill: parent
        }
        backgroundSize: 185 * Theme.pixelRatio
        SilicaListView {
            id: radioView
            anchors.fill: parent
            header: PageHeader { id: viewHeader; title: qsTr("Radio Record") }
            model: internal.isRadio?stationsList:podcastsList
            delegate: internal.isRadio?stationDelegate:podcastDelegate
            spacing: Theme.paddingSmall
            clip: true
            currentIndex: -1
            highlight: Rectangle {
                color: "#b1b1b1"
                opacity: 0.3
            }
            VerticalScrollDecorator { }
            PullDownMenu {
                id: pullDownMenu
                MenuItem {
                    text: qsTr("About")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
                    }
                }
                MenuItem {
                    text: internal.isRadio?qsTr("Podcasts"):qsTr("Radio stations")
                    onClicked: {
                        internal.isRadio = !internal.isRadio
                        if (!internal.isRadio) {
                            updateTrack.stop()
                            player.stop()
                            radioPlayer.source = ""
                            drawer.open = false
                        }
                    }
                }
            }
            Connections {
                target: playerItem
                onBitrateQuality: {
                    player.stop()
                    switch (bitrate) {
                    case "320 kbps":
                        player.source = stationsList.get(radioView.currentIndex).stream_320
                        _streamBitrate = "_320"
                        break
                    case "128 kbps":
                        player.source = stationsList.get(radioView.currentIndex).stream_128
                        _streamBitrate = "_128"
                        break
                    case "64 kbps":
                        player.source = stationsList.get(radioView.currentIndex).stream_64
                        _streamBitrate = "_64"
                        break
                    }
                    player.play()

                    console.log("Quality changed to", player.source)
                }
            }
        }
    }
}

