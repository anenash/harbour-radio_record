import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils
import "../utils"

Page {
    id: stationsPage
    //"http://air2.radiorecord.ru:805/rr_320"
    property string _streamUrl: "http://air2.radiorecord.ru:805/"

    //http://www.radiorecord.ru/player/img/logos/rr.jpg
    property string _radioLogo: "http://www.radiorecord.ru/player/img/logos/"

    //https://www.radiorecord.ru/xml/ps_online_v8.txt
    property string trackStartUrl: "https://www.radiorecord.ru/radio/"
    property string trackEndUrl: "_online_v8.txt"

    property string currentStationId

    property string nextPageTitle: qsTr("Top 100")


    anchors.margins: 5 * Theme.pixelRatio

    signal playNext();

    QtObject {
        id: internal

        property bool isRadio: true
        property string streamBitrate: "128 kbps"
        property bool showHint: true
    }

    Database {
        id: database
    }

    Component.onCompleted: {
        database.initDatabase()
        var bitrate = database.getSettingsValue("bitrate")
        if (bitrate) {
            internal.streamBitrate = bitrate
        }
        var showHint = database.getSettings("hints")
        if (showHint) {
            internal.showHint = showHint == 0
            if (!internal.showHint) {
                tapHint.stop()
            }
        }

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
        for (var i in json.result.stations) {
            stationsList.append(json.result.stations[i])
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
            console.warn("getTrackInfo: Source does not found.")
            return;
        }
        var json = JSON.parse(data);

        for (var i in json.result) {
            if (json.result[i].id.toString() === currentStationId.toString()) {
                playerItem.stationLogo = json.result[i].track.image600
                app.radioIcon = json.result[i].track.image600

                app.radioFullTitle = json.result[i].track.artist + "\n" + json.result[i].track.song
                app.radioTitle = "<b>" + json.result[i].track.artist + "</b><br>" + json.result[i].track.song
            }
        }
    }

    function changeBitrate(newBitrate) {
        player.stop()
        switch (internal.streamBitrate) {
        case "320 kbps":
            player.source = stationsList.get(radioView.currentIndex).stream_320
            break
        case "128 kbps":
            player.source = stationsList.get(radioView.currentIndex).stream_128
            break
        case "64 kbps":
            player.source = stationsList.get(radioView.currentIndex).stream_64
            break
        }
        player.play()
    }

    InteractionHintLabel {
        anchors.bottom: parent.bottom
        z: 3
        opacity: internal.showHint
        visible: internal.showHint
        Behavior on opacity { FadeAnimation {} }
        text: qsTr("Tap and hold to open context menu")
    }
    
    TapInteractionHint {
        id: tapHint

        loops: Animation.Infinite
        anchors.centerIn: parent
        visible: internal.showHint
    }

    ListModel {
        id: stationsList
    }

    ListModel {
        id: podcastsList
    }

    Component {
        id: stationDelegate

        ListItem {
            contentHeight: Theme.itemSizeExtraLarge
            Image {
                id: radioLogo

                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                anchors.verticalCenter: parent.verticalCenter
                height: 96 * Theme.pixelRatio
                width: 96 * Theme.pixelRatio
                fillMode: Image.PreserveAspectFit
                source: icon_fill_colored //icon_png
                BusyIndicator {
                    size: BusyIndicatorSize.Medium
                    anchors.centerIn: radioLogo
                    running: radioLogo.status != Image.Ready
                }
                onStatusChanged: {
                    if(status === Image.Error) {
                        console.error("Can not load image");
                        source = "RadioRecord.png"
                    }
                }
            }
            Label {
                id: titleLabel

                anchors.left: radioLogo.right
                anchors.leftMargin: Theme.horizontalPageMargin
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingSmall
                text: title
            }

            Text {
//                anchors.left: radioLogo.right
//                anchors.leftMargin: Theme.horizontalPageMargin
//                anchors.top: titleLabel.bottom
//                anchors.topMargin: Theme.paddingSmall
//                anchors.right: parent.right
//                anchors.rightMargin: Theme.horizontalPageMargin
                anchors {
                    top: titleLabel.bottom
                    topMargin: Theme.paddingSmall
                    left: radioLogo.right
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                color: Theme.secondaryColor
                wrapMode: Text.WordWrap
                maximumLineCount: 2
                elide: Text.ElideRight
                text: tooltip
            }

            menu: ContextMenu {
//                MenuItem {
//                    text: qsTr("Show top 100")
//                    onClicked: {
//                        console.debug("Show top 100")
//                        updateTrack.stop();
//                        playerItem.stationLogo = "RadioRecord.png"
//                        nextPageTitle = qsTr("Top 100 ") + title
//                        var url = trackStartUrl + "top100/" + prefix + ".txt";
//                        Utils.sendHttpRequest("GET", url, processData);                        ;
//                    }
//                }
                MenuItem {
                    text: qsTr("Show history")
                    onClicked: {
                        ////history.radiorecord.ru/index-flat.php?station='+radio+'&day=today'
                        //var url = "http://history.radiorecord.ru/index-flat.php?station=" + prefix + "&day=today"
//                        var url = "https://www.radiorecord.ru/api/api/station/history/?full&id=" + id
                        var url = "https://www.radiorecord.ru/api/api/station/history/?today&id=" + id
                        updateTrack.stop()
                        nextPageTitle = title + qsTr(" history")
                        playerItem.stationLogo = "RadioRecord.png"
                        Utils.sendHttpRequest("GET", url, processData);
                    }
                }
            }

            function processData(data) {
                app.showFullControl = true
                pageStack.push(Qt.resolvedUrl("Top100_history.qml"), {modelData: data, pageHeader: nextPageTitle});
            }

            onPressed: {
                internal.showHint = false
                tapHint.stop()
                database.storeSettings("hints", 1, "")
            }

            onClicked: {
                radioView.currentIndex = index
                currentStationId = id
                playerItem.streamBitrate = internal.streamBitrate
                radioIcon = icon_fill_colored
                radioTitle = title
                player.stop()
                player.source = internal.streamBitrate === "320 kbps"?stream_320:internal.streamBitrate === "128 kbps"?stream_128:stream_64
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
                source: cover_vertical
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
/*        TabView {

            anchors.fill: parent
            header: TabBar {
                model: ["Stations", "Podcasts"]
            }

            model: [stations, podcasts]

            Component {
                id: stations

                TabItem {
                    flickable: true
                    SilicaListView {
                        id: radioView
                        anchors.fill: parent
                        model: stationsList
                        delegate: stationDelegate
                        spacing: Theme.paddingSmall
                        clip: true
                        currentIndex: -1
                        highlight: Rectangle {
                            color: "#b1b1b1"
                            opacity: 0.3
                        }
                        VerticalScrollDecorator { }
                    }
                }
            }
            Component {
                id: podcasts

                TabItem {
                    flickable: true
                    SilicaListView {
                        id: radioView
                        anchors.fill: parent
                        model: podcastsList
                        delegate: podcastDelegate
                        spacing: Theme.paddingSmall
                        clip: true
                        currentIndex: -1
                        highlight: Rectangle {
                            color: "#b1b1b1"
                            opacity: 0.3
                        }
                        VerticalScrollDecorator { }
                    }
                }
            }


        }*/

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
                    text: qsTr("Settings")
                    onClicked: {
                        var dialog = pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))

                        dialog.accepted.connect(function() {
                            console.log("New bitrate", dialog.rate)
                            internal.streamBitrate = dialog.rate
                            if (radioView.currentIndex >= 0) {
                                changeBitrate(internal.streamBitrate)
                            }
                        })
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
                    internal.streamBitrate = bitrate

                    changeBitrate(internal.streamBitrate)
                }
            }
        }
    }
}

