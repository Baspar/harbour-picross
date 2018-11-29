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
TARGET = harbour-picross

CONFIG += sailfishapp_qml

QT += sql core

DISTFILES += \
    qml/cover/CoverPage.qml \
    qml/pages/Case.qml \
    qml/pages/NewGame.qml \
    qml/pages/Grille.qml \
    qml/pages/UnZoomButton.qml \
    qml/pages/MainPage.qml \
    qml/Source.js \
    qml/Levels.js \
    qml/DB.js \
    qml/pages/Settings.qml \
    qml/pages/Rules.qml \
    qml/harbour-picross.qml \
    qml/pages/WholeGrid.qml \
    rpm/harbour-picross.changes \
    rpm/harbour-picross.spec \
    rpm/harbour-picross.yaml \
    harbour-picross.desktop \
    scripts/genPicross.sh \
    qml/pages/ScorePage.qml

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

TRANSLATIONS += \
    translations/harbour-picross-fr.ts \
    translations/harbour-picross-it.ts \
    translations/harbour-picross-fi.ts
