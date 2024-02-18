import QtQuick 2.6
import Sailfish.Silica 1.0

import "Utils.js" as Utils

Page {
    id: aboutPage
    orientation: Orientation.Portrait
    allowedOrientations: Orientation.Portrait
    anchors.margins: Theme.paddingLarge

    Column {
        id: column

        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.margins: Theme.paddingLarge
        spacing: Theme.paddingLarge

        PageHeader {
            title: qsTr("About")
        }
        Label {
            id: firstParagraph
            width: parent.width
            anchors.margins: Theme.paddingLarge
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("Media player for the ") + "<a href=\"http://www.radiorecord.ru/\">Record Dance radio/</a>"
            onLinkActivated: {
                Qt.openUrlExternally(link);
            }
        }
    }
}

