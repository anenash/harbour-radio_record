import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils
import "../utils"

Dialog {
    id: settingsPage

    property string rate

    Database {
        id: database
    }

    Component.onCompleted: {
        database.initDatabase()
        var savedIndex = database.getSettings("bitrate")
        if (savedIndex) {
            streamBitrate.currentIndex = savedIndex
        }
        savedIndex = database.getSettings("hints")
        if (savedIndex) {
            showHints.currentIndex = savedIndex
        }
    }

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Settings")
        }

        ComboBox {
            id: streamBitrate
            label: qsTr("Stream quality")

            menu: ContextMenu {
                MenuItem { text: "320 kbps" }
                MenuItem { text: "128 kbps" }
                MenuItem { text: "64 kbps" }
            }
        }

        ComboBox {
            id: showHints
            label: qsTr("Show hints on start")

            menu: ContextMenu {
                MenuItem { text: "yes" }
                MenuItem { text: "no" }
            }
        }
    }

    onAccepted: {
        rate = streamBitrate.currentItem.text
        database.storeSettings("bitrate", streamBitrate.currentIndex, streamBitrate.currentItem.text)
        database.storeSettings("hints", showHints.currentIndex, showHints.currentItem.text)
        console.log("Rate", rate)
    }
}
