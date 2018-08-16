import QtQuick 2.0
import Sailfish.Silica 1.0

import "Utils.js" as Utils

//import harbour.radiorecord 1.0

Page {
    id: top100page

    property string htmlData: ""
    property string pageHeader: qsTr("Top 100")

    ListModel {
        id: listModel
    }

    Component.onCompleted: {
//        app.radioPlayer.onStatusChanged: {
//            console.log(" the media has played to the end.")
////            radioView.incrementCurrentIndex()
//        }
        Utils.getTop100(htmlData, listModel);
    }

    Component.onDestruction: {
        console.log("top 100 back")
        app.showFullControl = false
    }

    Component {
        id: listModelDelegate
        ListItem {
            contentHeight: Theme.itemSizeLarge
            IconButton {
                id: iconButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                z: 3
                icon.source: "image://theme/icon-m-music"
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
                text: "Track: " + title
                wrapMode: Text.WordWrap
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
            menu: ContextMenu {
                    MenuItem {
                        enabled: true
                        text: qsTr("Download track")
                        onClicked: {
                            downloader.m_fileUrl = listModel.get(index).href
                            console.log("Player source", app.player.source)
                            progressBar.visible = true
                        }
                    }
            }
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
//            onCurrentItemChanged: {
//                console.log("onCurrentItemChanged ", item.title)
//            }
            onCurrentIndexChanged: {
                app.player.stop()
                app.radioFullTitle = "<b>Artist:</b> " + listModel.get(currentIndex).artist + "<br><b>Title:</b> " + listModel.get(currentIndex).title
                app.radioIcon = "RadioRecord.png"
                app.radioTitle = "<b>" + listModel.get(currentIndex).artist + "</b><br>" + listModel.get(currentIndex).title
                app.player.source = listModel.get(currentIndex).href
                app.player.play()
                console.log("is seekable", app.player.seekable)
            }
        }
    }
}

