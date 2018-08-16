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
TARGET = harbour-radiorecord

CONFIG += sailfishapp

SOURCES += src/harbour-radiorecord.cpp \
    src/systemimei.cpp \
    src/filedownloader.cpp \
    src/network.cpp

OTHER_FILES += qml/harbour-radiorecord.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-radiorecord.changes.in \
    rpm/harbour-radiorecord.spec \
    rpm/harbour-radiorecord.yaml \
    translations/*.ts \
    harbour-radiorecord.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/harbour-radiorecord-ru.ts

DISTFILES += \
    qml/pages/Database.js \
    qml/pages/Utils.js \
    qml/pages/RadioRecord.png \
    qml/pages/StationsList.qml \
    qml/cover/RadioRecord.png \
    qml/Advert/adFunctions.js \
    qml/Advert/AdInterface.qml \
    qml/Advert/AdItem.qml \
    qml/Advert/AdParameters.qml \
    qml/pages/StartPage.qml \
    qml/pages/PlayerItem.qml \
    qml/pages/AboutPage.qml \
    qml/pages/Top100_history.qml

HEADERS += \
    src/systemimei.h \
    src/filedownloader.h \
    src/network.h

