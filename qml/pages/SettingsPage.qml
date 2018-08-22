import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils

Dialog {
    id: settingsPage

    property string rate

    Column {
        width: parent.width

        DialogHeader {
            title: qsTr("Settings")
        }

        ComboBox {
            id: sreamBitrateLabel
            label: qsTr("Stream quality")

            menu: ContextMenu {
                MenuItem { text: "320 kbps" }
                MenuItem { text: "128 kbps" }
                MenuItem { text: "64 kbps" }
            }
        }
    }

    onAccepted: {
        rate = sreamBitrateLabel.currentItem.text
    }
}
