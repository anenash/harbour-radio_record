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
        Label {
            id: secondParagraph
            width: parent.width
            anchors.margins: Theme.paddingLarge
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            text: qsTr("I will be very appreciated if you will support this application.")
        }

        Image {
            source: "https://www.paypalobjects.com/en_US/GB/i/btn/btn_donateCC_LG.gif"
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Qt.openUrlExternally("https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=anenash%40outlook%2ecom&lc=GB&item_name=For%20application%20improving&no_note=0&currency_code=RUB&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHostedGuest")
                }
            }
        }
    }
}

