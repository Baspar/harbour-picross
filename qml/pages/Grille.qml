import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB


Rectangle {
    id: rectGrille
    color: Qt.rgba(255, 255, 255, 0.1)
    width: game.dimension*unitSize+(game.dimension-1)*insideBorderSize
    height: width
    Grid {
        id: grille
        anchors.fill: parent
        spacing: insideBorderSize
        columns: game.dimension
        Repeater {
            id: myRepeat
            model: game.mySolvingGrid
            Case{
                estate:myEstate
                myID: index
            }
        }
    }

    // Horizontal separators
    Repeater{
        model: (game.dimension-1)/game.space
        Rectangle{
            x: (game.space*(index+1)-1)*insideBorderSize+game.space*(index+1)*unitSize
            y:0
            width: insideBorderSize
            height: rectGrille.height
            color: Theme.rgba(Theme.highlightColor, 0.1)
        }
    }

    // Vertical separators
    Repeater{
        model: (game.dimension-1)/game.space
        Rectangle{
            x: 0
            y: (game.space*(index+1)-1)*insideBorderSize+game.space*(index+1)*unitSize
            width: rectGrille.height
            height: insideBorderSize
            color: Theme.rgba(Theme.highlightColor, 0.1)
        }
    }
}
