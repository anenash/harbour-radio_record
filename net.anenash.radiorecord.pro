# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = net.anenash.radiorecord

CONFIG += sailfishapp
QT += sql

SOURCES += \
    src/filedownloader.cpp \
    src/net.anenash.radiorecord.cpp

OTHER_FILES += \
    qml/cover/CoverPage.qml \
    translations/*.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/net.anenash.radiorecord-ru.ts

DISTFILES += \
    net.anenash.radiorecord.desktop \
    qml/net.anenash.radiorecord.qml \
    qml/pages/Utils.js \
    qml/pages/RadioRecord.png \
    qml/pages/StationsList.qml \
    qml/cover/RadioRecord.png \
    qml/pages/PlayerItem.qml \
    qml/pages/AboutPage.qml \
    qml/pages/Top100_history.qml \
    qml/pages/PodcastPage.qml \
    qml/pages/SettingsPage.qml \
    qml/utils/Database.qml \
    rpm/net.anenash.radiorecord.spec \
    rpm/net.anenash.radiorecord.yaml

HEADERS += \
    src/filedownloader.h

