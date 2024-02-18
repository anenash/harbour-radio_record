import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    id: coverPage
    CoverPlaceholder {
        id: frame
        anchors.centerIn: parent
        text: app.radioTitle
        icon.source: app.radioIcon
        icon.width: 128 * Theme.pixelRatio
        icon.height: 128 * Theme.pixelRatio
    }

    CoverActionList {
        id: coverAction
        enabled: !app.showFullControl
        CoverAction {
            id: coverActionPlay
            iconSource: app.player.playbackState !== 1?"image://theme/icon-cover-play":"image://theme/icon-cover-pause"
            onTriggered: {
                if (app.player.playbackState === 1) {
                    app.player.stop()
                } else {
                    if(app.player.source !== "") {
                        app.player.play()
                    }
                }
            }
        }
    }
    CoverActionList {
        id: coverActionFullControl
        enabled: app.showFullControl
        CoverAction {
            id: coverActionFullControlPrev
            iconSource: "image://theme/icon-cover-previous-song"
            onTriggered: {
                app.switchToPrev = !app.switchToPrev
            }
        }
        CoverAction {
            id: coverActionFullControlPlay
            iconSource: app.player.playbackState !== 1?"image://theme/icon-cover-play":"image://theme/icon-cover-pause"
            onTriggered: {
                if (app.player.playbackState === 1) {
                    app.player.stop()
                } else {
                    if(app.player.source !== "") {
                        app.player.play()
                    }
                }
            }
        }
        CoverAction {
            id: coverActionFullControlNext
            iconSource: "image://theme/icon-cover-next-song"
            onTriggered: {
                app.switchToNext = !app.switchToNext
            }
        }
    }
}


