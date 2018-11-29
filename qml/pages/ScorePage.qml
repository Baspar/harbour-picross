import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB
import "../Levels.js" as Levels


Page {
    id: winPage
    property int nextDiff: Levels.getNextDiff()
    property int nextLevel: Levels.getNextLevel()

    property ListModel gGridModel : ListModel{}
    property int gDimension
    property string gTitle
    property int gLevel
    property int gDiff
    property int bTime
    property int gTime

    // High score page or level complete page?
    property bool highScorePage: false

    Component.onCompleted:{

        // Prepare high score screen
        if(highScorePage) {
            // gDiff from calling page
            // gLevel from calling page
            gDimension = Levels.getDimension(gDiff, gLevel)
            gTitle = Levels.getTitle(gDiff, gLevel)
            bTime = DB.getTime(gDiff, gDiff)
            gGridModel = Levels.getGrid(gDiff, gLevel)
        }
        // Prepare winning screen
        else {
            gLevel     = game.level
            gDiff      = game.diff
            gDimension = game.dimension
            gTitle     = game.title
            gTime      = game.time
            bTime      = DB.getTime(game.diff, game.level)
            gGridModel = Levels.getGrid(gDiff, gLevel)
        }
    }
    onStatusChanged: {
        // Prepare the next level
        if(!highScorePage && status == PageStatus.Active) {

            // Prepare the next level
            if(!game.allLevelsCompleted) {
                game.diff=nextDiff
                game.level=nextLevel
                game.save=DB.getSave(game.diff, game.level)
                Levels.initSolvedGrid(game.solvedGrid, game.diff, game.level)
                game.gridUpdated()
                if(nextDiff == -1 && nextLevel == -1)
                    game.dimension = 0
            }

            // Clear loaded level
            else {
                game.clearData()
            }
        }
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: bestTimeLabel2.y + bestTimeLabel2.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                id: nextLevelMenuItem
                enabled: !highScorePage && (nextDiff != -1 && nextLevel != -1 || game.allLevelsCompleted)
                visible: enabled
                text: qsTr("Next level")
                onClicked: {
                    game.pause = false
                    pageStack.replace(Qt.resolvedUrl("MainPage.qml"))
                }
            }
        }

        PageHeader {
            id: pageHeader
            title: highScorePage ? qsTr("Level details") : qsTr("Level completed!")
        }
        Label {
            id: solution
            anchors.top: pageHeader.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("Level")+" "+(gDiff+1)+"-"+(gLevel+1)
            font.pixelSize: Theme.fontSizeMedium
        }
        Rectangle{
            id: myFinalRect
            border.width: Theme.paddingSmall
            border.color: Theme.rgba(Theme.highlightColor, 0.3)
            width: parent.width*3/4
            height: width
            color: Theme.rgba("black", 0.25)
            radius: width * 0.025
            anchors.top: solution.bottom
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            Grid{
                id: myFinalGrid
                anchors.centerIn: parent
                width: parent.width*0.90
                height: width
                columns: gDimension
                spacing: Theme.paddingLarge / gDimension
                property int rectSize: (myFinalGrid.width-(gDimension-1)*myFinalGrid.spacing)/gDimension
                Repeater{
                    model: gGridModel
                    Rectangle{
                        width: myFinalGrid.rectSize
                        height: myFinalGrid.rectSize
                        radius: width * 0.1
                        opacity: 0.5
                        color: myEstate==="full"?Theme.highlightColor:"transparent"
                    }
                }
            }
        }

        Label{
            id: titleLabel
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: myFinalRect.bottom
            anchors.topMargin: Theme.paddingLarge
            font.pixelSize: Theme.fontSizeLarge
            text: gTitle
        }
        Label{
            id: yourTimeLabel1
            enabled: !highScorePage
            visible: enabled
            anchors.top: titleLabel.bottom
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Your time")+":"
        }
        Label{
            id: yourTimeLabel2
            enabled: !highScorePage
            visible: enabled
            anchors.top: highScorePage ? titleLabel.bottom : yourTimeLabel1.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: gTime===0?"--:--:--":gTime>=60*60*24?"24:00:00+":new Date(null, null, null, null, null, gTime).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
        }
        Label{
            id: bestTimeLabel1
            anchors.top: yourTimeLabel2.bottom
            anchors.topMargin: Theme.paddingMedium
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Best time")+":"
        }
        Label{
            id: bestTimeLabel2
            anchors.top: bestTimeLabel1.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            text: bTime===0?"--:--:--":bTime>=60*60*24?"24:00:00+":new Date(null, null, null, null, null, bTime).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
        }
    }
}
