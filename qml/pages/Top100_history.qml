import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils

import harbour.radiorecord 1.0

Page {
    id: top100page

    property string htmlData: ""
    property string modelData: ""
    property string pageHeader: qsTr("Top 100")

    ListModel {
        id: listModel
    }

    Component.onCompleted: {
//        app.radioPlayer.onStatusChanged: {
//            console.log(" the media has played to the end.")
////            radioView.incrementCurrentIndex()
//        }
//        Utils.getTop100(htmlData, listModel)
        var historyData = JSON.parse(modelData)
        for(var i in historyData.result.history) {
            listModel.append(historyData.result.history[i])
        }
    }

    Component.onDestruction: {
        console.log("top 100 back")
        app.showFullControl = false
    }

    Component {
        id: listModelDelegate
        ListItem {
            contentHeight: Theme.itemSizeLarge
            Image {
                id: iconButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                fillMode: Image.PreserveAspectFit
                height: Theme.itemSizeLarge
                z: 3
                source: image600?image600:"image://theme/icon-m-music"
            }

            Label {
                anchors.left: iconButton.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMedium
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingSmall
                text: artist
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
            }
            Label {
                anchors.left: iconButton.right
                anchors.leftMargin: Theme.paddingMedium
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingMediu
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.paddingSmall
                font.pixelSize: Theme.fontSizeExtraSmall
                text: song
                wrapMode: Text.WordWrap
            }
            Text {
                id: trackime
                anchors.right: parent.right
                anchors.rightMargin: Theme.horizontalPageMargin
                anchors.top: parent.top
                anchors.topMargin: Theme.paddingMedium
                text: time_formatted
            }
            ProgressBar {
                id: progressBar
                visible: false
                anchors.verticalCenter: parent.bottom
                width: parent.width
                indeterminate: true
            }
//            FileDownloader {
//                id: downloader
//                onDownloaded: {
//                    progressBar.visible = false
//                }
//            }
            onClicked: {
                radioView.currentIndex = index;
            }
//            menu: ContextMenu {
//                    MenuItem {
//                        enabled: true
//                        text: qsTr("Download track")
//                        onClicked: {
//                            downloader.m_fileUrl = listModel.get(index).href
//                            console.log("Player source", app.player.source)
//                            progressBar.visible = true
//                        }
//                    }
//            }
        }
    }


    Drawer {
        id: top100drawer

        anchors.fill: parent
        dock: Dock.Bottom
        open: true

        background: PlayerItem {
            id: playerItem
            anchors.fill: parent
            showFullControl: true
            onNextSong: {
                radioView.incrementCurrentIndex()
            }
            onPrevSong: {
                radioView.decrementCurrentIndex()
            }
            onEndOfSong: {
                radioView.incrementCurrentIndex()
            }
        }

        backgroundSize: 250 * Theme.pixelRatio
        SilicaListView {
            id: radioView
            anchors.fill: parent
            header: PageHeader { id: viewHeader; title: pageHeader}
            model: listModel
            delegate: listModelDelegate
            spacing: Theme.paddingLarge
            clip: true
            highlight: Rectangle {
                color: "#b1b1b1"
                opacity: 0.3
            }

            VerticalScrollDecorator { }

            onCurrentIndexChanged: {
                if(listModel.get(currentIndex).listenUrl){
                    app.player.stop()
                    app.radioFullTitle = "<b>Artist:</b> " + listModel.get(currentIndex).artist + "<br><b>Song:</b> " + listModel.get(currentIndex).song
                    app.radioIcon = "RadioRecord.png"
                    app.radioTitle = "<b>" + listModel.get(currentIndex).artist + "</b><br>" + listModel.get(currentIndex).song
                    app.player.source = listModel.get(currentIndex).listenUrl
                    app.player.play()
                    console.log("is seekable", app.player.seekable)
                }
            }
        }
    }
}

