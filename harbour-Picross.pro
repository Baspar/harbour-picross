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
TARGET = harbour-Picross

CONFIG += sailfishapp

SOURCES += src/harbour-Picross.cpp

QT += sql \
        core


OTHER_FILES += \
    qml/cover/CoverPage.qml \
    translations/*.ts \
    qml/pages/Case.qml \
    qml/pages/NewGame.qml \
    qml/pages/Grille.qml \
    qml/pages/UnZoomButton.qml \
    qml/pages/MainPage.qml \
    qml/Source.js \
    qml/Levels.js \
    qml/pages/WinPage.qml \
    qml/pages/LevelInfos.qml \
    qml/DB.js \
    qml/pages/Settings.qml \
    qml/pages/Rules.qml \
    harbour-Picross.desktop \
    harbour-Picross.png \
    rpm/harbour-Picross.changes \
    rpm/harbour-Picross.spec \
    rpm/harbour-Picross.yaml \
    qml/harbour-Picross.qml \
    scripts/genPicross.sh

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
#TRANSLATIONS += translations/Picross-de.ts

