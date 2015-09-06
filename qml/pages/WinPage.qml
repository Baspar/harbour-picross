import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB
import "../Levels.js" as Levels


Dialog{
    id: winPage
    property int nextDiff: Levels.getNextDiff()
    property int nextLevel: Levels.getNextLevel()

    canAccept: nextLevel !== -1 && nextDiff !== -1

    Column{
        anchors.fill: parent
        DialogHeader{
            title: "Level completed!"
            acceptText: "Next level"
            cancelText: "Back"
        }
        SectionHeader{
            text: "Solution"
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
                columns: game.dimension
                spacing: 5
                Repeater{
                    model: game.solvedGrid
                    Rectangle{
                        width: (myFinalGrid.width-(game.dimension-1)*5)/game.dimension
                        height: width
                        opacity: 0.2
                        color: myEstate==="full"?Theme.highlightColor:"transparent"
                    }
                }
            }
        }
        Label{
            anchors.horizontalCenter: parent.horizontalCenter
            text: game.title
        }
        Label{
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: "Best time:"
        }
        Label{
            property int time : DB.getTime(game.diff, game.level)
            anchors.horizontalCenter: parent.horizontalCenter
            text: time===0?"xx:xx:xx":Math.floor(time/3600)%216000+":"+Math.floor(time/60)%3600+":"+time%60
        }
        Label{
            visible: nextLevel === -1 && nextDiff === -1
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: "Congratulations, you solve every level !"
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
