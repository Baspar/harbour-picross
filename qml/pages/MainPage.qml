/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source
import "../DB.js" as DB

Page {
    RemorsePopup{ id: remorseMain }

    property int insideBorderSize: 5
    property int outsideBorderSize: 10

    id: page
    PinchArea {
        property real initialZoom
        anchors.fill: parent
        onPinchStarted: initialZoom = game.zoom
        onPinchUpdated: game.zoom = (initialZoom*pinch.scale>3)?3:(initialZoom*pinch.scale<1)?1:initialZoom*pinch.scale
        Rectangle{
            color: "transparent"
            anchors.fill: parent
        }
    }

    SilicaFlickable {
        id: flickUp
        anchors.fill: parent
        PullDownMenu {
            /*MenuItem {
    text: qsTr("Rules")
    onClicked: {
    pageStack.push(Qt.resolvedUrl("Rules.qml"))
    }
    }*/
            MenuItem {
                text: qsTr("Settings")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("Settings.qml"))
                }
            }
            MenuItem {
                visible: game.dimension!==0
                text: qsTr("Clear grid")
                onClicked: remorseMain.execute("Clearing the grid", function(){Source.clear()})
            }
            MenuItem {
                text: qsTr("New game")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NewGame.qml"))
                }
            }
        }

        Column{
            // Fixed top part
            Item{
                id: topPartRectangle
                width: page.width
                height: (game.dimension===0)?page.height:pageHeader.height

                PageHeader {
                    id: pageHeader
                    title: game.hintTitle===""?"Picross":game.hintTitle
                    description: game.dimension===0?"":game.dimension+"x"+game.dimension//+" - "+game.nbSolvingFullCell+"/"+game.nbSolvedFullCell
                }
                ViewPlaceholder {
                    enabled: (game.dimension===0)
                    text: qsTr("Welcome to Picross")
                    hintText: qsTr("Please choose a level from the pulley menu")
                }

            }
            // Grid part
            Item{
                visible: (game.dimension!==0)
                id: gridPartRectangle
                width: page.width
                height: page.height-topPartRectangle.height

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
                        height: Math.min(gridPartRectangle.height-10, bottomLineIndicUp.height+topLineIndicUp.height+indicUp.height+flick.contentHeight)
                        color: Theme.highlightColor
                        opacity:0.3
                    }
                    // Decoration bottom of the grid
                    Rectangle{
                        y: Math.min(gridPartRectangle.height-10, bottomLineIndicUp.height+topLineIndicUp.height+indicUp.height+flick.contentHeight)
                        width: gridPartRectangle.width
                        height: 10
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
                                            color:"transparent"/*(game.selectedCol !==-1 && Math.abs(index-game.selectedCol)<=game.selectedRadius)?
          Theme.rgba("black", 0.3/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(index-game.selectedCol)))
        :"transparent"*/


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
                                                        onClicked: if(completed)Source.completeColX(index)
                                                        /*onPressAndHold: {
        if(game.selectedCol === index)
        game.selectedCol=-1
        else
        game.selectedCol=index
        }*/
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
                                                                color: completed?"green":Theme.highlightColor
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
                        width: 100-20
                        y:100
                        x:10
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
                                            color:"transparent" /*(game.selectedLine !==-1 && Math.abs(index-game.selectedLine)<=game.selectedRadius)?
          Theme.rgba("black", 0.3/(game.selectedRadius+1)*(game.selectedRadius+1-Math.abs(index-game.selectedLine)))
        :"transparent"*/
                                            SilicaFlickable{
                                                id: finalIndicLeft
                                                height: parent.height
                                                width: parent.width
                                                contentWidth: myIndicLeft.width
                                                clip: true
                                                Rectangle{
                                                    anchors.fill:parent
                                                    color: "transparent"
                                                    MouseArea{
                                                        anchors.fill: parent
                                                        onClicked: if(completed)Source.completeLineX(index)
                                                        /*onPressAndHold: {
                if(game.selectedLine === index)
                game.selectedLine=-1
                else
                game.selectedLine=index
                }*/
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
                                                                color: completed?"green":Theme.highlightColor
                                                                font.pixelSize: 14
                                                            }
                                                        }
                                                    }

                                                    Component.onCompleted: {
                                                        if(myIndicLeft.width+insideBorderSize<indicLeftFlick.width){adjustLeft.width=indicLeftFlick.width-myIndicLeft.width-insideBorderSize}
                                                    }
                                                }
                                            }
                                            Canvas{
                                                id: leftArrow
                                                opacity: finalIndicLeft.contentX!==0
                                                Behavior on opacity {NumberAnimation{duration: 100}}
                                                anchors.left: parent.left
                                                anchors.leftMargin: Theme.paddingSmall
                                                anchors.verticalCenter: parent.verticalCenter
                                                height: parent.height/2
                                                width: height
                                                onPaint:{
                                                    var ctx = getContext("2d")
                                                    ctx.fillStyle= Theme.rgba(Theme.highlightColor, 1)
                                                    ctx.strokeStyle= Theme.rgba(Theme.highlightColor, 1)
                                                    ctx.lineWidth = 1

                                                    ctx.beginPath()
                                                    ctx.moveTo(0, 0.5*width)
                                                    ctx.lineTo(width, 0)
                                                    ctx.lineTo(width, height)
                                                    ctx.closePath()
                                                    ctx.stroke()
                                                    ctx.fill()
                                                }
                                            }
                                            Canvas{
                                                id: rightArrow
                                                opacity: finalIndicLeft.contentX!==finalIndicLeft.contentWidth-indicRectangleLeft.width
                                                Behavior on opacity {NumberAnimation{duration: 100}}
                                                anchors.right: parent.right
                                                anchors.rightMargin: Theme.paddingSmall
                                                anchors.verticalCenter: parent.verticalCenter
                                                height: parent.height/2
                                                width: height
                                                onPaint:{
                                                    var ctx = getContext("2d")
                                                    ctx.fillStyle= Theme.rgba(Theme.highlightColor, 1)
                                                    ctx.strokeStyle= Theme.rgba(Theme.highlightColor, 1)
                                                    ctx.lineWidth = 1

                                                    ctx.beginPath()
                                                    ctx.moveTo(width, 0.5*width)
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
                                            width: indicLeftFlick.width
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
        }
    }
}
