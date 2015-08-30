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
            acceptText: "Next level ("+nextDiff+"-"+nextLevel+")"
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
        Item{
            anchors.horizontalCenter: parent.horizontalCenter
            height: winTitle.height
            width: winTitle.width
            Label{
                id: winTitle
                text: game.title
            }
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
