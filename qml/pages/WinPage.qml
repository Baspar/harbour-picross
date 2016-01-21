import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB
import "../Levels.js" as Levels


Dialog{
    id: winPage
    property int nextDiff: Levels.getNextDiff()
    property int nextLevel: Levels.getNextLevel()

    property ListModel modelcpy : ListModel{}
    property int dimensioncpy
    property string titlecpy
    property int time

    Component.onCompleted:{
        dimensioncpy=game.dimension
        titlecpy=game.title
        time=DB.getTime(game.diff, game.level)
        for(var i=0; i<game.solvedGrid.count; i++)
                modelcpy.append(game.solvedGrid.get(i))
    }

    canAccept: nextLevel !== -1 && nextDiff !== -1

    Column{
        anchors.fill: parent
        DialogHeader{
            title: qsTr("Level completed!")
            acceptText: qsTr("Next level")
            cancelText: qsTr("Back")
        }
        SectionHeader{
            text: qsTr("Solution")
        }
        Rectangle{
            border.width: 5
            border.color: Theme.rgba(Theme.highlightColor, 0.3)
            width: parent.width*3/4
            height: width
            color: Theme.rgba("black", 0.1)
            anchors.horizontalCenter: parent.horizontalCenter
            Grid{
                id: myFinalGrid
                anchors.centerIn: parent
                width: parent.width*0.9
                height: width
                columns: dimensioncpy
                spacing: 5
                Repeater{
                    model: modelcpy
                    Rectangle{
                        width: (myFinalGrid.width-(dimensioncpy-1)*5)/dimensioncpy
                        height: width
                        opacity: 0.2
                        color: myEstate==="full"?Theme.highlightColor:"transparent"
                    }
                }
            }
        }
        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text: titlecpy
        }
        Label{
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Best time")+":"
        }
        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text: time===0?"xx:xx:xx":time>=60*60*23?"24:00:00+":new Date(null, null, null, null, null, time).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
        }
        Label{
            visible: nextLevel === -1 && nextDiff === -1
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Congratulations, you solve every level !")
        }
    }
    onAccepted: {
        game.diff=nextDiff
        game.level=nextLevel
        game.save=DB.getSave(game.diff, game.level)

        Levels.initSolvedGrid(game.solvedGrid, game.diff, game.level)

        game.gridUpdated()
    }
}
