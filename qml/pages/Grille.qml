import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB


Rectangle {
    id: rectGrille
    property int newSpace: calculateGridSize()

    function calculateGridSize() {
        var gridSize = 0
        // Set spacer size automatically?
        if(game.space == -1) {
            switch(game.dimension) {
            case 12:
            case 17:
                gridSize = 3
                break
            case 8:
            case 19:
                gridSize = 4
                break
            case 15:
            case 20:
            case 25:
                gridSize = 5
                break
            case 14:
                gridSize= 7
                break
            case 3:
            case 5:
            default:
                gridSize = 0
            }
        }
        else {
            gridSize = game.space
        }
        return gridSize
    }

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
        enabled: newSpace > 0
        visible: enabled
        model: (game.dimension-1)/newSpace
        Rectangle{
            x: (newSpace*(index+1)-1)*insideBorderSize+newSpace*(index+1)*unitSize
            y:0
            width: insideBorderSize
            height: rectGrille.height
            color: Theme.rgba(Theme.highlightColor, 0.1)
        }
    }

    // Vertical separators
    Repeater{
        enabled: newSpace > 0
        visible: enabled
        model: (game.dimension-1)/newSpace
        Rectangle{
            x: 0
            y: (newSpace*(index+1)-1)*insideBorderSize+newSpace*(index+1)*unitSize
            width: rectGrille.height
            height: insideBorderSize
            color: Theme.rgba(Theme.highlightColor, 0.1)
        }
    }
}
