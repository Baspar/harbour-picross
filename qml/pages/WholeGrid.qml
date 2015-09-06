import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Source.js" as Source
import "../DB.js" as DB

Item{
    visible: (game.dimension!==0)
    id: gridPartRectangle

    //Decorations
    Item{
        id: decorations
        // Decorations top-left corner of the grid
        Item{
            Rectangle{
                x:90
                width:10
                height:100
                color: Theme.highlightColor
                opacity:0.3
            }
            Rectangle{
                y:90
                width:90
                height:10
                color: Theme.highlightColor
                opacity:0.3
            }
        }
        // Decoration right of the grid
        Rectangle{
            x:gridPartRectangle.width-10
            width:10
            height: Math.min(gridPartRectangle.height-outsideBorderSize, indicUp.height+flick.contentHeight)
            color: Theme.highlightColor
            opacity:0.3
        }
        // Decoration bottom of the grid
        Rectangle{
            y: Math.min(gridPartRectangle.height-outsideBorderSize, indicUp.height+flick.contentHeight)
            width: gridPartRectangle.width
            height: outsideBorderSize
            color: Theme.highlightColor
            opacity:0.3
        }
    }

    // Un-zoom button
    UnZoomButton{}

    // Top indicator
    Item{
        Rectangle{
            id: topLineIndicUp
            x:100
            y:0
            height:10
            width: gridPartRectangle.width-100-10
            color: Theme.highlightColor
            opacity:0.3
        }
        Item{
            id: indicUp
            width: gridPartRectangle.width-100-10
            height: 100
            x:100
            y:0
            SilicaFlickable{
                clip: true
                width: parent.width
                height: parent.height
                id: indicUpFlick
                contentHeight: height
                contentWidth: flick.contentWidth
                contentX: flick.contentX
                VerticalScrollDecorator {}
                HorizontalScrollDecorator {}
                Row{
                    width: flick.contentWidth
                    Repeater{
                        model: game.indicUp
                        Row{
                            Rectangle{
                                id: indicRectangleUp
                                width: (flick.contentWidth-(game.dimension-1)*insideBorderSize) / (game.dimension+game.nbSelectedCols *(2-1))   *(game.selectedCol !==-1 && Math.abs(index-game.selectedCol)<=game.selectedRadius?2:1)
                                height: indicUpFlick.height
                                color: (game.selectedCol !==-1 && Math.abs(index-game.selectedCol)<=game.selectedRadius)?
                                           Theme.rgba("black", 0.3/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(index-game.selectedCol)))
                                         :"transparent"

                                SilicaFlickable{
                                    id: finalIndicUp
                                    height: parent.height-2*outsideBorderSize
                                    width: parent.width
                                    contentHeight: myIndicUp.height
                                    y: outsideBorderSize
                                    clip: true

                                    Rectangle{
                                        anchors.fill:parent
                                        color: "transparent"
                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked: {
                                                if(completed||toFill)
                                                    Source.completeColX(index, toFill)
                                            }
                                            onPressAndHold:{
                                                if(page.selectedCol === index)
                                                    page.selectedCol = -1
                                                else
                                                    page.selectedCol = index
                                            }
                                        }
                                    }


                                    Column{
                                        id: myIndicUp

                                        Rectangle{
                                            id: adjustUp
                                            color: "transparent"
                                            height: 0
                                            width: indicRectangleUp.width
                                        }
                                        // Indicator
                                        Repeater{
                                            model: loadedIndic
                                            Item{
                                                width: indicRectangleUp.width
                                                height: myLabelIndicUp.height
                                                Label{
                                                    anchors.centerIn: parent
                                                    id: myLabelIndicUp
                                                    text: size
                                                    color: isOk?"green":toFill?"orange":completed?"green":Theme.highlightColor
                                                    font.pixelSize: 14
                                                }
                                            }
                                        }

                                        Component.onCompleted: {
                                            if(myIndicUp.height<finalIndicUp.height){adjustUp.height=finalIndicUp.height-myIndicUp.height}
                                        }
                                    }
                                }
                                Canvas{

                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: topArrow
                                    opacity: finalIndicUp.contentY!==0
                                    Behavior on opacity {NumberAnimation{duration: 100}}
                                    anchors.top: parent.top
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    width: parent.width/2
                                    height: outsideBorderSize
                                    onPaint:{
                                        var ctx = getContext("2d")
                                        ctx.fillStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.strokeStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.lineWidth = 1

                                        ctx.beginPath()
                                        ctx.moveTo(0.5*width,0)
                                        ctx.lineTo(0, height)
                                        ctx.lineTo(width, height)
                                        ctx.closePath()
                                        ctx.stroke()
                                        ctx.fill()
                                    }
                                }
                                Canvas{
                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: bottomArrow
                                    opacity: finalIndicUp.contentY!==finalIndicUp.contentHeight-finalIndicUp.height
                                    anchors.bottom: parent.bottom
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    Behavior on opacity {NumberAnimation{duration: 100}}
                                    width: parent.width/2
                                    height: 10
                                    onPaint:{
                                        var ctx = getContext("2d")
                                        ctx.fillStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.strokeStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.lineWidth = 1

                                        ctx.beginPath()
                                        ctx.moveTo(0.5*width,height)
                                        ctx.lineTo(0, 0)
                                        ctx.lineTo(width, 0)
                                        ctx.closePath()
                                        ctx.stroke()
                                        ctx.fill()
                                    }
                                    onContextChanged: {
                                        if (!context) return;
                                        requestPaint();
                                    }
                                }

                            }
                            Rectangle{
                                y:outsideBorderSize
                                width: insideBorderSize
                                height: finalIndicUp.height
                                color: Theme.highlightColor
                                opacity: 0.1
                            }
                        }
                    }
                }
            }
        }
        Rectangle{
            id: bottomLineIndicUp
            x:100
            y:90
            height:10
            width: gridPartRectangle.width-100-10
            color: Theme.highlightColor
            opacity:0.3
        }
    }
    // Left indicator
    Item{
        Rectangle{
            id: leftLineIndicLeft
            x:0
            y:100
            height: Math.min(game.zoom*(gridPartRectangle.width-100-10), gridPartRectangle.height-100-10)
            width: 10
            color: Theme.highlightColor
            opacity:0.3
        }
        Item{
            id: indicLeft
            height: Math.min(game.zoom*(gridPartRectangle.width-100-10), gridPartRectangle.height-100-10)
            width: 100
            y:100
            SilicaFlickable{
                clip:true
                width: parent.width
                height: parent.height
                id: indicLeftFlick
                contentHeight: flick.contentHeight
                contentWidth: width
                contentY: flick.contentY
                VerticalScrollDecorator {}
                HorizontalScrollDecorator {}
                Column{
                    height: flick.contentHeight
                    Repeater{
                        model: game.indicLeft
                        Column{
                            Rectangle{
                                id: indicRectangleLeft
                                height: (flick.contentHeight-(game.dimension-1)*insideBorderSize) / (game.dimension+game.nbSelectedLines*(2-1))   *(game.selectedLine!==-1 && Math.abs(index-game.selectedLine)<=game.selectedRadius?2:1)
                                width: indicLeftFlick.width
                                color:(game.selectedLine !==-1 && Math.abs(index-game.selectedLine)<=game.selectedRadius)?
                                          Theme.rgba("black", 0.3/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(index-game.selectedLine)))
                                        :"transparent"
                                SilicaFlickable{
                                    id: finalIndicLeft
                                    height: parent.height
                                    width: parent.width-2*outsideBorderSize
                                    x: outsideBorderSize
                                    contentWidth: myIndicLeft.width
                                    clip: true
                                    Rectangle{
                                        anchors.fill:parent
                                        color: "transparent"
                                        MouseArea{
                                            anchors.fill: parent
                                            onClicked:{
                                                if(completed||toFill)
                                                    Source.completeLineX(index, toFill)
                                            }
                                            onPressAndHold: page.selectedLine=index
                                        }
                                    }

                                    Row{
                                        id: myIndicLeft
                                        spacing: insideBorderSize


                                        Rectangle{
                                            id: adjustLeft
                                            color: "transparent"
                                            width: 0
                                            height: indicRectangleLeft.height
                                        }

                                        // Indicators
                                        Repeater{
                                            model: loadedIndic
                                            Item{
                                                height: indicRectangleLeft.height
                                                width: myLabelIndicLeft.width
                                                Label{
                                                    anchors.centerIn: parent
                                                    id: myLabelIndicLeft
                                                    text: model.size
                                                    color: isOk?"green":toFill?"orange":completed?"green":Theme.highlightColor
                                                    font.pixelSize: 14
                                                }
                                            }
                                        }

                                        Component.onCompleted: {
                                            if(myIndicLeft.width+insideBorderSize<finalIndicLeft.width){adjustLeft.width=finalIndicLeft.width-myIndicLeft.width-insideBorderSize}
                                        }
                                    }
                                }
                                Canvas{
                                    id: leftArrow
                                    opacity: finalIndicLeft.contentX!==0
                                    Behavior on opacity {NumberAnimation{duration: 100}}
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: parent.height/2
                                    width: outsideBorderSize
                                    onPaint:{
                                        var ctx = getContext("2d")
                                        ctx.fillStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.strokeStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.lineWidth = 1

                                        ctx.beginPath()
                                        ctx.moveTo(0, 0.5*height)
                                        ctx.lineTo(width, 0)
                                        ctx.lineTo(width, height)
                                        ctx.closePath()
                                        ctx.stroke()
                                        ctx.fill()
                                    }
                                    onContextChanged: {
                                        if (!context) return;
                                        requestPaint();
                                    }
                                }
                                Canvas{
                                    id: rightArrow
                                    opacity: finalIndicLeft.contentX!==Math.floor(finalIndicLeft.contentWidth)-finalIndicLeft.width
                                    Behavior on opacity {NumberAnimation{duration: 100}}
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter
                                    height: parent.height/2
                                    width: outsideBorderSize
                                    onPaint:{
                                        var ctx = getContext("2d")
                                        ctx.fillStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.strokeStyle= Theme.rgba(Theme.highlightColor, 1)
                                        ctx.lineWidth = 1

                                        ctx.beginPath()
                                        ctx.moveTo(width, 0.5*height)
                                        ctx.lineTo(0, 0)
                                        ctx.lineTo(0, height)
                                        ctx.closePath()
                                        ctx.stroke()
                                        ctx.fill()
                                    }
                                    onContextChanged: {
                                        if (!context) return;
                                        requestPaint();
                                    }
                                }
                            }
                            Rectangle{
                                height: insideBorderSize
                                width: finalIndicLeft.width
                                x: outsideBorderSize
                                color: Theme.highlightColor
                                opacity: 0.1
                            }
                        }
                    }
                }
            }
        }
        Rectangle{
            id: rightLineIndicLeft
            x:100-10
            y:100
            height: Math.min(game.zoom*(gridPartRectangle.width-100-10), gridPartRectangle.height-100-10)
            width: 10
            color: Theme.highlightColor
            opacity:0.3
        }
    }
    // Grid
    Item{
        id: grid
        y:100
        x:100
        width: gridPartRectangle.width-100-10
        height: Math.min(game.zoom*(gridPartRectangle.width-100-10), gridPartRectangle.height-100-10)
        SilicaFlickable {
            clip:true
            anchors.fill:parent
            pressDelay: 0
            id: flick
            contentWidth: column.width
            contentHeight: column.height
            contentX: indicUpFlick.contentX
            contentY: indicLeftFlick.contentY
            VerticalScrollDecorator {}
            HorizontalScrollDecorator {}

            Column {
                id: column
                width: game.zoom*(grid.width)
                spacing: Theme.paddingLarge
                Grille{}
            }
        }
    }
}
