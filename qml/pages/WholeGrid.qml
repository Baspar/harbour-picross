import QtQuick 2.0
import Sailfish.Silica 1.0

import "../Source.js" as Source
import "../DB.js" as DB

Item{
        visible: (game.dimension!==0)
        id: gridPartRectangle

        property int sizeIndicLeft: maxSizeIndicLeft
        property int sizeIndicTop: foldTopMode?maxSizeIndicTop:Math.max(maxSizeIndicTop, (maxHeight+1)*insideBorderSize + (maxHeight+1)*Math.min(
                                                                            0.9*(flick.contentWidth-(game.dimension-1)*insideBorderSize) / game.dimension
                                                                            ,
                                                                            maxSizeIndicTop/5))
        property int maxSizeIndicLeft: page.width/4
        property int maxSizeIndicTop: page.width/4


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
                                                                width: (flick.contentWidth-(game.dimension-1)*insideBorderSize) / game.dimension
                                                                height: indicUpFlick.height
                                                                color: "transparent"

                                                                MouseArea{
                                                                        anchors.fill: parent
                                                                        onClicked: {
                                                                                if(completed||toFill)
                                                                                        Source.completeColX(index, toFill)
                                                                        }
                                                                        onPressAndHold: if(game.zoom!==1)foldTopMode=!foldTopMode
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
                                                                                onPressAndHold: if(game.zoom!==1)foldTopMode=!foldTopMode
                                                                        }


                                                                        Column{
                                                                                id: myIndicUp

//                                                                                onHeightChanged: if(height>maxHeight)maxHeight=height
                                                                                Component.onCompleted: if(loadedIndic.count>maxHeight)maxHeight=loadedIndic.count

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
                        height: Math.min(game.zoom*(gridPartRectangle.width -10)-sizeIndicTop, gridPartRectangle.height-sizeIndicTop-10)
                        width: 10
                        color: Theme.highlightColor
                        opacity:0.3
                }
                Item{
                        id: indicLeft
                        height: Math.min(game.zoom*(gridPartRectangle.width -10)-sizeIndicTop, gridPartRectangle.height-sizeIndicTop-10)
                        width: sizeIndicLeft
                        y:sizeIndicTop
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
                                                                height: (flick.contentHeight-(game.dimension-1)*insideBorderSize) / game.dimension
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
                                                                                                width: myLabelIndicLeft.width
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
                        x:sizeIndicLeft-10
                        y:sizeIndicTop
                        height: Math.min(game.zoom*(gridPartRectangle.width -10)-sizeIndicTop, gridPartRectangle.height-sizeIndicTop-10)
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
                width: gridPartRectangle.width-sizeIndicLeft-10
                height: Math.min(game.zoom*(gridPartRectangle.height-sizeIndicTop-10), gridPartRectangle.height-sizeIndicTop-10)
                SilicaFlickable {
                        clip:true
                        anchors.fill:parent
                        pressDelay: 0
                        interactive: game.slideMode===""
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
