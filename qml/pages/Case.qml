import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source

Rectangle {
    property string estate
    property int myID
    property int k: 2

    id: thisrect
    width:  (rectGrille.width-(game.dimension-1)*insideBorderSize) / (game.dimension+game.nbSelectedCols *(k-1))   *(game.selectedCol !==-1 && Math.abs(myID%game.dimension-game.selectedCol)<=game.selectedRadius?k:1)
    height: (rectGrille.width-(game.dimension-1)*insideBorderSize) / (game.dimension+game.nbSelectedLines*(k-1))   *(game.selectedLine!==-1 && Math.abs(Math.floor(myID/game.dimension)-selectedLine)<=game.selectedRadius?k:1)

    color:
        thisrect.estate==="full"?
               Theme.rgba(Theme.highlightColor,0.6)
          :(game.selectedCol !==-1 && Math.abs(myID%game.dimension-game.selectedCol)<=game.selectedRadius)||(game.selectedLine!==-1 && Math.abs(Math.floor(myID/game.dimension)-selectedLine)<=game.selectedRadius)?
                (game.selectedCol === -1)?
                    Theme.rgba("black", 0.2+0.2/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(Math.floor(myID/game.dimension)-game.selectedLine)))
                :(game.selectedLine === -1)?
                        Theme.rgba("black", 0.2+0.2/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(myID%game.dimension-game.selectedCol)))
                :Theme.rgba("black", 0.2+0.2/(game.selectedRadius+1)*(game.selectedRadius+1-Math.min(Math.abs(myID%game.dimension-game.selectedCol), Math.abs(Math.floor(myID/game.dimension)-game.selectedLine))))
        :Qt.rgba(0, 0, 0, 0.1)

    Canvas{
        id: canvas
        opacity: (thisrect.estate==="hint")?0.6:0
        Behavior on opacity {NumberAnimation{duration: 100}}
        width: parent.width
        height: parent.height
        onPaint:{
                var ctx = getContext("2d")
                ctx.strokeStyle = Theme.highlightColor
                ctx.lineWidth = 2

                ctx.beginPath()
                ctx.moveTo(0.1*width,0.1*height)
                ctx.lineTo(0.9*width, 0.9*height)
                ctx.stroke()
                ctx.closePath()

                ctx.beginPath()
                ctx.moveTo(0.1*width, 0.9*height)
                ctx.lineTo(0.9*width, 0.1*height)
                ctx.stroke()
                ctx.closePath()
        }
    }

    Behavior on color {ColorAnimation{duration: 100}}
    Behavior on opacity {NumberAnimation{duration: 100}}

    MouseArea{
        anchors.fill: parent
        onPressAndHold: {
            Source.longClick(game.mySolvingGrid, index)
        }
        onClicked: {
            Source.click(game.mySolvingGrid, index)
        }
    }
}


