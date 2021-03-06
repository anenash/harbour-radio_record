import QtQuick 2.6
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0

import "Utils.js" as Utils
import "../utils"

Dialog {
    id: settingsPage

    property string rate
    property string selectedFile

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

//        ValueButton {
//            id: downloadFolder

//            label: qsTr("Download directory")
//            value: selectedFile ? selectedFile : "None"
//            onClicked: pageStack.push(contentPickerPage)
//        }

//        Component {
//            id: contentPickerPage
//            ContentPickerPage {
//                title: "Select file"
//                onSelectedContentPropertiesChanged: {
//                    settingsPage.selectedFile = selectedContentProperties.filePath
//                }
//            }
//        }
    }

    onAccepted: {
        rate = streamBitrate.currentItem.text
        database.storeSettings("bitrate", streamBitrate.currentIndex, streamBitrate.currentItem.text)
        database.storeSettings("hints", showHints.currentIndex, showHints.currentItem.text)
        console.log("Rate", rate)
    }
}
