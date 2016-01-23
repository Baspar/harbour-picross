import QtQuick 2.0
import Sailfish.Silica 1.0
import QtFeedback 5.0
import "../Source.js" as Source

Rectangle {
    property string estate
    property int myID

    property HapticsEffect longBuzz: HapticsEffect {
            attackTime: 50
            fadeTime: 50
            attackIntensity: 0.2
            fadeIntensity: 0.01
            intensity: 0.8
            duration: 100
    }
    property HapticsEffect shortBuzz: HapticsEffect {
            attackTime: 25
            fadeTime: 25
            attackIntensity: 0.2
            fadeIntensity: 0.01
            intensity: 0.8
            duration: 50
    }

    id: thisrect
    width: unitSize
    height: width

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
        anchors.fill: parent

        property real realX: Math.floor((myID%game.dimension*(unitSize+insideBorderSize)+mouseX)/(unitSize+insideBorderSize))
        property real realY: Math.floor((Math.floor(myID/game.dimension)*(unitSize+insideBorderSize)+mouseY)/(unitSize+insideBorderSize))
        property int cellNumber:realX+realY*game.dimension


        onPressAndHold: {
            if(!game.won)
                    if(!game.guessMode || (thisrect.estate!=="hint" && thisrect.estate!=="full")){
                            flick.interactive=false
                            flickUp.interactive=false
                            longBuzz.start()
                    }
        }

        onCellNumberChanged: if(!flick.interactive && realX>=0 && realY>=0 && realX<game.dimension && realY<game.dimension){
                                 if(game.mySolvingGrid.get(cellNumber)!==thisrect.estate){
                                         shortBuzz.start()
                                         Source.slideClick(game.mySolvingGrid, cellNumber, thisrect.estate)
                                 }
                             }

        onReleased:{
            flick.interactive=true
            flickUp.interactive=true
        }

        onClicked: {
            if(!game.won)
                Source.click(game.mySolvingGrid, myID)
        }
    }
}


