import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Source.js" as Source
import "../DB.js" as DB

Item{
    visible: (game.dimension!==0)
    id: gridPartRectangle
    property int sizeIndic: page.width/4

    //Decorations
    Item{
        id: decorations
        // Decorations top-left corner of the grid
        Item{
            Rectangle{
                x:sizeIndic-10
                width:10
                height:sizeIndic
                color: Theme.highlightColor
                opacity:0.3
            }
            Rectangle{
                y:sizeIndic-10
                width:sizeIndic-10
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
            x:sizeIndic
            y:0
            height:10
            width: gridPartRectangle.width-sizeIndic-10
            color: Theme.highlightColor
            opacity:0.3
        }
        Item{
            id: indicUp
            width: gridPartRectangle.width-sizeIndic-10
            height: sizeIndic
            x:sizeIndic
            y:0
            //Horizontal part
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
                            //Vertical part
                            Rectangle{
                                id: indicRectangleUp
                                width: (flick.contentWidth-(game.dimension-1)*insideBorderSize) / (game.dimension+game.nbSelectedCols *(2-1))   *(game.selectedCol !==-1 && Math.abs(index-game.selectedCol)<=game.selectedRadius?2:1)
                                height: indicUpFlick.height
                                color: (game.selectedCol !==-1 && Math.abs(index-game.selectedCol)<=game.selectedRadius)?
                                           Theme.rgba("black", 0.3/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(index-game.selectedCol)))
                                         :"transparent"


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
                                SilicaFlickable{
                                    id: finalIndicUp
                                    y: outsideBorderSize+Math.max(0, parent.height-2*outsideBorderSize-myIndicUp.height)
                                    height: Math.min(parent.height-2*outsideBorderSize, myIndicUp.height)
                                    width: parent.width
                                    contentHeight: myIndicUp.height
                                    clip: true

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


                                    Column{
                                        id: myIndicUp

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
                                                    font.pixelSize: 0.9*finalIndicUp.width*game.zoom
                                                }
                                            }
                                        }
                                    }
                                }
                                Canvas{

                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: topArrow
                                    opacity: finalIndicUp.atYBeginning?0:1
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
                                    opacity: finalIndicUp.atYEnd?0:1
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
                                height: indicUpFlick.height-2*outsideBorderSize
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
            x:sizeIndic
            y:sizeIndic-10
            height:10
            width: gridPartRectangle.width-sizeIndic-10
            color: Theme.highlightColor
            opacity:0.3
        }
    }
    // Left indicator
    Item{
        Rectangle{
            id: leftLineIndicLeft
            x:0
            y:sizeIndic
            height: Math.min(game.zoom*(gridPartRectangle.width-sizeIndic-10), gridPartRectangle.height-sizeIndic-10)
            width: 10
            color: Theme.highlightColor
            opacity:0.3
        }
        Item{
            id: indicLeft
            height: Math.min(game.zoom*(gridPartRectangle.width-sizeIndic-10), gridPartRectangle.height-sizeIndic-10)
            width: sizeIndic
            y:sizeIndic
            //Vertical part
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
                            //Vertical part
                            Rectangle{
                                id: indicRectangleLeft
                                height: (flick.contentHeight-(game.dimension-1)*insideBorderSize) / (game.dimension+game.nbSelectedLines*(2-1))   *(game.selectedLine!==-1 && Math.abs(index-game.selectedLine)<=game.selectedRadius?2:1)
                                width: indicLeftFlick.width
                                color:(game.selectedLine !==-1 && Math.abs(index-game.selectedLine)<=game.selectedRadius)?
                                          Theme.rgba("black", 0.3/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(index-game.selectedLine)))
                                        :"transparent"
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked:{
                                    if(completed||toFill)
                                        Source.completeLineX(index, toFill)
                                    }
                                    onPressAndHold: page.selectedLine=index
                                }
                                SilicaFlickable{
                                    id: finalIndicLeft
                                    height: parent.height
                                    width: Math.min(parent.width-2*outsideBorderSize, myIndicLeft.width)
                                    x: outsideBorderSize+Math.max(0, parent.width-2*outsideBorderSize-myIndicLeft.width)
                                    contentWidth: myIndicLeft.width
                                    clip: true

                                    MouseArea{
                                        anchors.fill: parent
                                        onClicked:{
                                    if(completed||toFill)
                                    Source.completeLineX(index, toFill)
                                    }
                                        onPressAndHold: page.selectedLine=index
                                    }
                                    Row{
                                        id: myIndicLeft
                                        spacing: insideBorderSize

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
                                                    font.pixelSize: 0.9*finalIndicLeft.height*game.zoom
                                                }
                                            }
                                        }
                                    }
                                }
                                Canvas{
                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: leftArrow
                                    opacity: finalIndicLeft.atXBeginning?0:1
                                    Behavior on opacity {NumberAnimation{duration: sizeIndic}}
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
                                }
                                Canvas{
                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: rightArrow
                                    opacity: finalIndicLeft.atXEnd?0:1
                                    Behavior on opacity {NumberAnimation{duration: sizeIndic}}
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
                                }
                            }
                            Rectangle{
                                height: insideBorderSize
                                width: indicLeftFlick.width-2*outsideBorderSize
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
            x:sizeIndic-10
            y:sizeIndic
            height: Math.min(game.zoom*(gridPartRectangle.width-sizeIndic-10), gridPartRectangle.height-sizeIndic-10)
            width: 10
            color: Theme.highlightColor
            opacity:0.3
        }
    }
    // Grid
    Item{
        id: grid
        y:sizeIndic
        x:sizeIndic
        width: gridPartRectangle.width-sizeIndic-10
        height: Math.min(game.zoom*(gridPartRectangle.width-sizeIndic-10), gridPartRectangle.height-sizeIndic-10)
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
