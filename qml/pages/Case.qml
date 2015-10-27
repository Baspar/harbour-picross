import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source

Rectangle {
    property string estate
    property int myID
    property int k: 2

    id: thisrect
    width:  (rectGrille.width-(game.dimension-1)*insideBorderSize) / game.dimension
    height: (rectGrille.width-(game.dimension-1)*insideBorderSize) / game.dimension

    opacity: game.guessMode && thisrect.estate==="full"?0.25:1
    color: thisrect.estate==="full"||thisrect.estate=="guess_full"?Theme.rgba(Theme.highlightColor, 0.6):Theme.rgba("black", 0.1)

    Canvas{
        property bool appActive: game.applicationActive
        onAppActiveChanged: requestPaint()

        id: canvas
        opacity: thisrect.estate==="hint"?game.guessMode?0.15:0.6:thisrect.estate==="guess_hint"?0.6:0
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
//        hoverEnabled: true

        anchors.fill: parent
//        onPressAndHold: {
//            game.slideMode=thisrect.estate
//            console.log("Debut slid")
//        }
//        onReleased: {
//            game.slideMode=""
//            console.log("Fin slid")
//        }

//        onEntered:{
//            console.log(myID+" survolé!")
//        }

        onClicked: {
            if(!game.won)
                Source.click(game.mySolvingGrid, myID)
        }
    }
}


