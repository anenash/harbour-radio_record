import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils

import harbour.radiorecord 1.0

Page {
    id: podcastPage

    property string id

    QtObject {
        id: internal

        property string coverLink: "RadioRecord.png"
        property string pageHeader: qsTr("Podcasts")
    }

    Component.onCompleted: {
        var url = Utils.pocaststracsUrl + id
        Utils.sendHttpRequest("GET", url, getPodcastTracks)
    }

    function getPodcastTracks(data) {
        if(data === "error") {
            var url = Utils.pocaststracsUrl + id
            Utils.sendHttpRequest("GET", url, getPodcastTracks)
            return;
        }
        var json = JSON.parse(data)
        internal.coverLink = json.result.cover
        for (var i in json.result.items) {
            podcastsModel.append(json.result.items[i])
        }
    }

    ListModel {
        id: podcastsModel
    }

    Component {
        id: podcastsModelDelegate
        ListItem {
            contentHeight: Theme.itemSizeLarge
            Image {
                id: iconButton
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                z: 3
                height: parent.height
                fillMode: Image.PreserveAspectFit
                source: internal.coverLink
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
                text: "Track: " + song
                wrapMode: Text.WordWrap
            }
            ProgressBar {
                id: progressBar
                visible: false
                anchors.verticalCenter: parent.bottom
                width: parent.width
                indeterminate: true
            }
            FileDownloader {
                id: downloader
                onDownloaded: {
                    progressBar.visible = false
                }
            }
            onClicked: {
                podcastsView.currentIndex = index;
            }
            menu: ContextMenu {
                    MenuItem {
                        enabled: true
                        text: qsTr("Download podcast")
                        onClicked: {
                            downloader.m_fileUrl = podcastsModel.get(index).link
                            console.log("Player source", app.player.source)
                            progressBar.visible = true
                        }
                    }
            }
        }
    }

    Drawer {
        id: podacstsDrawer

        anchors.fill: parent
        dock: Dock.Bottom
        open: true

        background: PlayerItem {
            id: playerItem
            anchors.fill: parent
            showFullControl: true
            onNextSong: {
                podcastsView.incrementCurrentIndex()
            }
            onPrevSong: {
                podcastsView.decrementCurrentIndex()
            }
            onEndOfSong: {
                podcastsView.incrementCurrentIndex()
            }
        }

        backgroundSize: 250 * Theme.pixelRatio
        SilicaListView {
            id: podcastsView
            anchors.fill: parent
            header: PageHeader { id: viewHeader; title: internal.pageHeader}
            model: podcastsModel
            delegate: podcastsModelDelegate
            spacing: Theme.paddingLarge
            clip: true
            highlight: Rectangle {
                color: "#b1b1b1"
                opacity: 0.3
            }

            VerticalScrollDecorator { }

            onCurrentIndexChanged: {
                app.player.stop()
                app.radioFullTitle = "<b>Artist:</b> " + podcastsModel.get(currentIndex).artist + "<br><b>Title:</b> " + podcastsModel.get(currentIndex).song
                app.radioIcon = internal.coverLink
                app.radioTitle = "<b>" + podcastsModel.get(currentIndex).artist + "</b><br>" + podcastsModel.get(currentIndex).song
                app.player.source = podcastsModel.get(currentIndex).link
                app.player.play()
                console.log("is seekable", app.player.seekable)
            }
        }
    }
}
