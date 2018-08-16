import QtQuick 2.0
import Sailfish.Silica 1.0

import "Utils.js" as Utils

Page {
    id: stationsPage
    //"http://air2.radiorecord.ru:805/rr_320"
    property string _streamUrl: "http://air2.radiorecord.ru:805/"
    property string _streamBitrate: "_320"

    //http://www.radiorecord.ru/player/img/logos/rr.jpg
    property string _radioLogo: "http://www.radiorecord.ru/player/img/logos/"

    //https://www.radiorecord.ru/xml/ps_online_v8.txt
    property string trackStartUrl: "https://www.radiorecord.ru/xml/"
    property string trackEndUrl: "_online_v8.txt"

    property string currentStationId

    property string nextPageTitle: qsTr("Top 100")

    property bool showHint: true

    anchors.margins: 5 * Theme.pixelRatio

    signal playNext();

    Component.onCompleted: {
        tapHint.start()
    }

    Timer {
        id: updateTrack
        repeat: true
        interval: 7000
        onTriggered: {
            var url = trackStartUrl + currentStationId + trackEndUrl;
            Utils.sendHttpRequest("GET", url, getTrackInfo);
        }
    }

    function getTrackInfo(data) {
        if(data === "error") {
            console.debug("getTrackInfo: Source does not found.")
            return;
        }
        var json = JSON.parse(data);
        var source = json.image600
        if(source) {
//            console.log("getTrackInfo: radio icon", source)
            playerItem.stationLogo = source;
            app.radioIcon = source;
        } else {
            playerItem.stationLogo = "RadioRecord.png";
            app.radioIcon = "RadioRecord.png";
        }

        app.radioFullTitle = "Artist: " + json.artist + "\nTitle: " + json.title
        app.radioTitle = "<b>" + json.artist + "</b><br>" + json.title
    }
    InteractionHintLabel {
        anchors.bottom: parent.bottom
        z: 3
        opacity: showHint
        Behavior on opacity { FadeAnimation {} }
        text: qsTr("Tap and hold to open context menu")
    }
    
    TapInteractionHint {
        id: tapHint
        loops: Animation.Infinite
        anchors.centerIn: parent        
    }

    ListModel {
        id: stationsList
        ListElement { stationId: "rr"; stationName: "Radio Record" }
        ListElement { stationId: "mix"; stationName: "Megamix" }
        ListElement { stationId: "deep"; stationName: "Record Deep" }
        ListElement { stationId: "club"; stationName: "Record Club" }
        ListElement { stationId: "fut"; stationName: "Future House" }
        ListElement { stationId: "tm"; stationName: "Trancemission" }
        ListElement { stationId: "chil"; stationName: "Record Chill-Out" }
        ListElement { stationId: "mini"; stationName: "Minimal/Tech" }
        ListElement { stationId: "ps"; stationName: "Pirate Station" }
        ListElement { stationId: "rus"; stationName: "Russian Mix" }
        ListElement { stationId: "vip"; stationName: "Vip House" }
        ListElement { stationId: "sd90"; stationName: "Супердиско 90-х" }
        ListElement { stationId: "brks"; stationName: "Record Breaks" }
        ListElement { stationId: "dub"; stationName: "Record Dubstep" }
        ListElement { stationId: "dc"; stationName: "Record Dancecore" }
        ListElement { stationId: "techno"; stationName: "Record Techno" }
        ListElement { stationId: "teo"; stationName: "Record Hardstyle" }
        ListElement { stationId: "trap"; stationName: "Record Trap" }
        ListElement { stationId: "pump"; stationName: "Pump" }
        ListElement { stationId: "rock"; stationName: "Record Rock" }
        ListElement { stationId: "mdl"; stationName: "Медляк FM" }
        ListElement { stationId: "gop"; stationName: "Гоп FM" }
        ListElement { stationId: "yo"; stationName: "Yo! FM" }
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
                source: _radioLogo + stationId + ".jpg"
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
                text: stationName
            }

            menu: ContextMenu {
                MenuItem {
                    text: "Show top 100"
                    onClicked: {
                        console.debug("Show top 100")
                        updateTrack.stop();
                        playerItem.stationLogo = "RadioRecord.png"
                        nextPageTitle = qsTr("Top 100 ") + stationName
                        var url = trackStartUrl + "top100/" + stationId + ".txt";
                        Utils.sendHttpRequest("GET", url, processData);                        ;
                    }
                }
                MenuItem {
                    text: "Show history"
                    onClicked: {
                        console.debug("Show history")
                        ////history.radiorecord.ru/index-flat.php?station='+radio+'&day=today'
                        var url = "http://history.radiorecord.ru/index-flat.php?station=" + stationId + "&day=today"
                        updateTrack.stop();
                        nextPageTitle = stationName + qsTr(" history")
                        playerItem.stationLogo = "RadioRecord.png"
                        Utils.sendHttpRequest("GET", url, processData);
                    }
                }
            }

            function processData(data) {
                app.showFullControl = true
                pageStack.push(Qt.resolvedUrl("Top100_history.qml"), {htmlData: data, pageHeader: nextPageTitle});
            }

            onPressed: {
                showHint = false
                tapHint.stop()
            }

            onClicked: {
                radioView.currentIndex = index;
                currentStationId = stationId;
                playerItem.streamBitrate = _streamBitrate === "_320"?"320 kbps":_streamBitrate === "_128"?"128 kbps":"32 kbps"

                radioIcon = _radioLogo + stationId + ".jpg";
                radioTitle = stationName
                player.stop()
                player.source = _streamUrl + stationId + _streamBitrate
                player.play()
                var url = trackStartUrl + currentStationId + trackEndUrl;
                Utils.sendHttpRequest("GET", url, getTrackInfo);
                updateTrack.start()
                drawer.open = true
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
            PullDownMenu {
                id: pullDownMenu
                MenuItem {
                    text: qsTr("About")
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                    }
                }
                MenuItem {
                    text: qsTr("Stream quality 32 kbps")
                    font.bold: _streamBitrate === "_aac?type=.flv"?true:false
                    onClicked: {
                        //http://air2.radiorecord.ru:805/rr_aac?type=.flv
                        _streamBitrate = "_aac?type=.flv"
                        playerItem.streamBitrate = "32 kbps"
                        playerItem.player.stop()
                        playerItem.player.source = _streamUrl + currentStationId + _streamBitrate
                        playerItem.player.play()
//                        app.endOfSong.connect();
                    }
                }
                MenuItem {
                    text: qsTr("Stream quality 128 kbps")
                    font.bold: _streamBitrate === "128 kbps"?true:false
                    onClicked: {
                        _streamBitrate = "_128"
                        playerItem.streamBitrate = "128 kbps"
                        playerItem.player.stop()
                        playerItem.player.source = _streamUrl + currentStationId + _streamBitrate
                        playerItem.player.play()
                    }
                }
                MenuItem {
                    text: qsTr("Stream quality 320 kbps")
                    font.bold: _streamBitrate === "320 kbps"?true:false
                    onClicked: {
                        _streamBitrate = "_320"
                        playerItem.streamBitrate = "320 kbps"
                        playerItem.player.stop()
                        playerItem.player.source = _streamUrl + currentStationId + _streamBitrate
                        playerItem.player.play()
                    }
                }
            }
        }
    }
}

