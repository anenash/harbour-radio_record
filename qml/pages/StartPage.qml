import QtQuick 2.0
import Sailfish.Silica 1.0

import "Utils.js" as Utils

import "../Advert"

Page {
    id: startPage
    //"http://air2.radiorecord.ru:805/rr_320"
    property string _streamUrl: "http://air2.radiorecord.ru:805/"
    property string _streamBitrate: "_320"

    //http://www.radiorecord.ru/player/img/logos/rr.jpg
    property string _radioLogo: "http://www.radiorecord.ru/player/img/logos/"

    //https://www.radiorecord.ru/xml/ps_online_v8.txt
    property string trackStartUrl: "https://www.radiorecord.ru/xml/"
    property string trackEndUrl: "_online_v8.txt"

    property string currentStationId

    AdParameters {
        id: params
        applicationId: "anenash_anenash_Aviasales_UbuntuTouch_other"
        appName: "RadioRecord"
        keywords: "music,radio,club"
        usePositioning: false
        category: "music"
    }

    PageHeader {
        id: header
        title: qsTr("Radio Record")
    }

    SilicaGridView {
        id: gridView
        anchors.top: header.bottom
        anchors.bottom: advertBanner.top
        anchors.left: parent.left
        anchors.right: parent.right
        model: ListModel {
            ListElement { fruit: "orange" }
            ListElement { fruit: "lemon" }
        }
        delegate: ListItem {
//            width: GridView.view.width
//            height: Theme.itemSizeSmall

            Label { text: fruit }
            onClicked: {
                pageStack.push(Qt.resolvedUrl("StationsList.qml"));
            }
        }
    }

    Item {
        id: advertBanner
//        anchors.top: gridView.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
//        width: parent.width
        height: 30 * Theme.pixelRatio
        AdItem {
            anchors.fill: parent
            retryOnError: true
            reloadInterval: 100
            parameters: params
//            anchors.bottom: parent.bottom
//            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}

