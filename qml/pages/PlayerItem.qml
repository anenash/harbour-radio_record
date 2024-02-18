import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.0

Item {
    id: playerControl

    property alias stationLogo: currentRadioLogo.source
    property alias streamBitrate: sreamBitrateLabel.value

    property bool showFullControl: false

    property int statusPlayer: app.player.status
    property bool nextTrack: app.switchToNext
    property bool prevTrack: app.switchToPrev

    signal bitrateQuality(var bitrate)
    signal prevSong()
    signal nextSong()
    signal endOfSong()

    property int position: app.player.position

    function getTime(value) {
        var seconds = parseInt((value/1000)%60)
            , minutes = parseInt((value/(1000*60))%60)
            , hours = parseInt((value/(1000*60*60))%24)

        var _hours = (hours < 10) ? "0" + hours : hours
        minutes = (minutes < 10) ? "0" + minutes : minutes
        seconds = (seconds < 10) ? "0" + seconds : seconds

        if (hours > 0) {
            return _hours + ":" + minutes + ":" + seconds
        } else {
            return minutes + ":" + seconds
        }
    }

    onStatusPlayerChanged: {
        switch (statusPlayer) {
        case Audio.EndOfMedia:
            endOfSong()
            break
        case Audio.Stalled:
            if (app.player.playbackState !== Audio.StoppedState && app.player.playbackState !== Audio.PausedState) {
                app.player.pause()
            }
            break
        case Audio.Buffered:
            if (app.player.playbackState !== Audio.StoppedState && app.player.playbackState === Audio.PausedState) {
                app.player.play()
            }
            break
        }
    }

    onNextTrackChanged: {
        nextSong()
    }

    onPrevTrackChanged: {
        prevSong()
    }

    onPositionChanged: {
        playerScroll.value = position
    }

    anchors.fill: parent

    Timer {
        id: updateSlider

        repeat: true
        interval: 1000
        onTriggered: {
            playerScroll.value = position
        }
    }

    Image {
        id: currentRadioLogo

        height: !showFullControl?175 * Theme.pixelRatio:0
        width: !showFullControl?175 * Theme.pixelRatio:0
        fillMode: Image.PreserveAspectFit
        source: app.radioIcon        
        visible: !showFullControl
        onStatusChanged: {
            if(status === Image.Error) {
                console.error("Can not load image")
                source = "RadioRecord.png"
                app.radioIcon = source
            }
        }
        onSourceChanged: {
            update()
        }
    }

    Label {
        id: currentStationName

        anchors.left: currentRadioLogo.right
        anchors.leftMargin: 5 * Theme.pixelRatio
        anchors.right: parent.right
        anchors.rightMargin: 5 * Theme.pixelRatio
        anchors.top: currentRadioLogo.top
        font.pixelSize: Theme.fontSizeExtraSmall
        text:  app.radioFullTitle
    }

    Slider {
        id: playerScroll

        anchors.top: currentStationName.bottom
        width: parent.width
        visible: showFullControl
        enabled: app.player.seekable
        minimumValue: 0
        maximumValue: app.player.duration
        label: getTime(value)
        onReleased: {
            app.player.seek(value)
        }
    }

    IconButton {
        id: prevButton

        anchors.verticalCenter: playButton.verticalCenter
        anchors.right: playButton.left
        anchors.rightMargin: Theme.paddingLarge
        z: 3
        icon.source: "image://theme/icon-m-previous"
        visible: showFullControl
        onClicked: {
            prevSong()
        }
    }

    IconButton {
        id: playButton

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: !showFullControl ? Theme.paddingLarge : 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30 * Theme.pixelRatio
        z: 3
        icon.source: app.player.playbackState !== 1
                     ? "image://theme/icon-l-play"
                     : "image://theme/icon-l-pause"
        width: 50 * Theme.pixelRatio
        height: 50 * Theme.pixelRatio
        onClicked: {
            if (app.player.playbackState === 1) {
                app.player.stop()
                app.coverButtonIcon = "image://theme/icon-cover-play"
            } else {
                app.player.play()
                app.coverButtonIcon = "image://theme/icon-cover-pause"
            }
        }
    }

    IconButton {
        id: nextButton

        anchors.verticalCenter: playButton.verticalCenter
        anchors.left: playButton.right
        anchors.leftMargin: Theme.paddingLarge
        z: 3
        icon.source: "image://theme/icon-m-next"
        visible: showFullControl
        onClicked: {
            nextSong()
        }
    }

    ValueButton {
        id: sreamBitrateLabel

        anchors.right: parent.right
        anchors.rightMargin: 10 * Theme.pixelRatio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * Theme.pixelRatio
        width: parent.width * 0.3

        onClicked: {
            var dialog = pageStack.push(Qt.resolvedUrl("SettingsPage.qml"))

            dialog.accepted.connect(function() {
                console.log("New bitrate", dialog.rate)
                value = dialog.rate
                bitrateQuality(value)
            })
        }
    }
}

