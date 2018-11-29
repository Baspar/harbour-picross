import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Source.js" as Source
import "../DB.js" as DB

Item{
    visible: game.dimension !== 0
    enabled: game.dimension !== 0
    id: gridPartRectangle

    property int sizeIndicLeft: maxSizeIndicLeft
    property int sizeIndicTop: foldTopMode?maxSizeIndicTop:Math.max(maxSizeIndicTop, (maxHeight+1)*insideBorderSize + (maxHeight+1)*Math.min(
                                                                        0.9*(flick.contentWidth-(game.dimension-1)*insideBorderSize) / game.dimension
                                                                        ,
                                                                        maxSizeIndicTop/5))
    property int maxSizeIndicLeft: width/4
    property int maxSizeIndicTop: width/4

    property real unitSize: game.zoom*(width-maxSizeIndicLeft-(game.dimension-1)*insideBorderSize-outsideBorderSize)/game.dimension


    Behavior on sizeIndicLeft {NumberAnimation{duration: 100}}
    Behavior on sizeIndicTop {NumberAnimation{duration: 100}}

    //Decorations
    Item{
        id: decorations
        // Decorations top-left corner of the grid
        Item{
            Rectangle{
                x:sizeIndicLeft-10
                width:10
                height:sizeIndicTop
                color: Theme.highlightColor
                opacity:0.3
            }
            Rectangle{
                y:sizeIndicTop-10
                width:sizeIndicLeft-10
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
            color: "red"
            opacity:0.3
        }
    }

    // Un-zoom button
    UnZoomButton{}

    // Top indicator
    Item{
        id: topIndicator
        Rectangle{
            id: topLineIndicUp
            x:sizeIndicLeft
            y:0
            height:10
            width: gridPartRectangle.width-sizeIndicLeft-10
            color: Theme.highlightColor
            opacity:0.3
        }
        Item{
            id: indicUp
            width: gridPartRectangle.width-sizeIndicLeft-10
            height: sizeIndicTop
            x:sizeIndicLeft
            y:0
            //Slider part
            Rectangle{
                id: sliderUp
                color: Theme.highlightColor
                opacity: !game.zoomIndic && game.zoom>1 ?0.2:0
                height: parent.height-2*outsideBorderSize
                width: indicUpFlick.contentWidth*indicUpFlick.contentWidth/flick.contentWidth
                x:flick.contentX*indicUpFlick.contentWidth/flick.contentWidth
                y:outsideBorderSize
                z:2
            }

            //Horizontal part
            SilicaFlickable{
                clip: true
                width: parent.width
                height: parent.height
                id: indicUpFlick
                contentHeight: height
                contentWidth: game.zoomIndic?flick.contentWidth:parent.width
                contentX: game.zoomIndic?flick.contentX:0
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
                                width: game.zoomIndic?unitSize:unitSize/game.zoom
                                height: indicUpFlick.height
                                color: "transparent"

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(completed||toFill)
                                            Source.completeColX(index, toFill)
                                    }
                                    onPressAndHold: foldTopMode=!foldTopMode
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
                                        //                                                                                onPressAndHold: if(game.zoom!==1)foldTopMode=!foldTopMode
                                        onPressAndHold: foldTopMode=!foldTopMode
                                    }


                                    Column{
                                        id: myIndicUp

                                        Component.onCompleted: if(loadedIndic.count>maxHeight)maxHeight=loadedIndic.count

                                        // Indicator
                                        Repeater{
                                            model: loadedIndic
                                            Item{
                                                width: indicRectangleUp.width
                                                height: myLabelIndicUp.height * 0.85
                                                Label{
                                                    anchors.centerIn: parent
                                                    id: myLabelIndicUp
                                                    text: size
                                                    color: hasError?"red":isOk?"green":toFill?"orange":completed?"green":Theme.highlightColor
                                                    font.pixelSize: Math.min(0.9*finalIndicUp.width, maxSizeIndicTop/5)
                                                }
                                            }
                                        }
                                    }
                                }
                                Canvas{

                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: topArrow
                                    opacity: finalIndicUp.atYBeginning||!foldTopMode?0:1
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
                                    opacity: finalIndicUp.atYEnd||!foldTopMode?0:1
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
                                MouseArea{
                                    anchors.fill: parent
                                    onClicked: {
                                        if(completed||toFill)
                                            Source.completeColX(index, toFill)
                                    }
                                    onPressAndHold: foldTopMode=!foldTopMode
                                }
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
            x:sizeIndicLeft
            y:sizeIndicTop-10
            height:10
            width: gridPartRectangle.width-sizeIndicLeft-10
            color: Theme.highlightColor
            opacity:0.3
        }
    }
    // Left indicator
    Item{
        Rectangle{
            id: leftLineIndicLeft
            x:0
            y:sizeIndicTop
            height: Math.min(game.dimension*unitSize+(game.dimension-1)*insideBorderSize, page.height-pageHeader.height-sizeIndicTop-outsideBorderSize)

            width: 10
            color: Theme.highlightColor
            opacity:0.3
        }
        Item{
            id: indicLeft
            height: Math.min(game.dimension*unitSize+(game.dimension-1)*insideBorderSize, page.height-pageHeader.height-sizeIndicTop-outsideBorderSize)
            width: sizeIndicLeft
            y:sizeIndicTop
            //Slider part
            Rectangle{
                id: sliderLeft
                color: Theme.highlightColor
                opacity: !game.zoomIndic && indicLeftFlick.contentHeight!==flick.contentHeight ?0.2:0
                height: indicLeftFlick.contentHeight*indicLeftFlick.contentHeight/flick.contentHeight
                width: parent.width-2*outsideBorderSize
                y:flick.contentY*indicLeftFlick.contentHeight/flick.contentHeight
                x: outsideBorderSize
                z:2
            }
            //Vertical part
            SilicaFlickable{
                clip:true
                width: parent.width
                height: parent.height
                id: indicLeftFlick
                contentHeight: game.zoomIndic?flick.contentHeight:parent.height
                contentWidth: width
                contentY: game.zoomIndic?flick.contentY:0
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
                                height: game.zoomIndic?unitSize:(indicLeftFlick.height+insideBorderSize)/game.dimension-insideBorderSize
                                width: indicLeftFlick.width
                                color:"transparent"

                                MouseArea{
                                    anchors.fill: parent
                                    onClicked:{
                                        if(completed||toFill)
                                            Source.completeLineX(index, toFill)
                                    }
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
                                    }
                                    Row{
                                        id: myIndicLeft
                                        spacing: insideBorderSize

                                        onWidthChanged: if(width>maxWidth)maxWidth=width

                                        // Indicators
                                        Repeater{
                                            model: loadedIndic
                                            Item{
                                                height: indicRectangleLeft.height
                                                width: myLabelIndicLeft.width + myLabelIndicLeft.height/5
                                                Label{
                                                    anchors.centerIn: parent
                                                    id: myLabelIndicLeft
                                                    text: model.size
                                                    color: hasError?"red":isOk?"green":toFill?"orange":completed?"green":Theme.highlightColor
                                                    font.pixelSize: Math.min(0.9*finalIndicLeft.height, sizeIndicLeft/5)
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
                                }
                                Canvas{
                                    property bool appActive: game.applicationActive
                                    onAppActiveChanged: requestPaint()

                                    id: rightArrow
                                    opacity: finalIndicLeft.atXEnd?0:1
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
                                    }                                                                }
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
            x:sizeIndicLeft-10
            y:sizeIndicTop
            height: Math.min(game.dimension*unitSize+(game.dimension-1)*insideBorderSize, page.height-pageHeader.height-sizeIndicTop-outsideBorderSize)
            width: 10
            color: Theme.highlightColor
            opacity:0.3
        }
    }

    // Grid
    Item{
        id: grid
        y:sizeIndicTop
        x:sizeIndicLeft
        width: gridPartRectangle.width-sizeIndicLeft-outsideBorderSize
        height: Math.min(game.dimension*unitSize+(game.dimension-1)*insideBorderSize, page.height-pageHeader.height-sizeIndicTop-outsideBorderSize)

        SilicaFlickable {
            clip:true
            anchors.fill:parent
            pressDelay: 0
            id: flick
            contentWidth: game.dimension*unitSize+(game.dimension-1)*insideBorderSize
            contentHeight: column.height
            contentX: game.zoomIndic?indicUpFlick.contentX:0
            contentY: game.zoomIndic?indicLeftFlick.contentX:0
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
    Rectangle {
        id: bottomRect
        anchors.top: grid.bottom
        width: parent.width
        height: 10
        color: Theme.highlightColor
        opacity:0.3
    }
    Rectangle {
        id: rightRect
        anchors.bottom: bottomRect.top
        anchors.top: gridPartRectangle.top
        anchors.right: bottomRect.right
        width: 10
        color: Theme.highlightColor
        opacity:0.3
    }
}
