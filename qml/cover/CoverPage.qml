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
import "../pages"

CoverBackground {
    Label{
        visible: game.dimension !== 0
        anchors.horizontalCenter: parent.horizontalCenter
        text: Math.floor(game.time/3600)%216000+":"+Math.floor(game.time/60)%3600+":"+game.time%60
    }
    Rectangle {

        transform: [Rotation {angle: 33}, Scale { xScale: 2; yScale: 2}, Translate {x: width/3; y: width/5}]
        id: rectGrille
        color: Qt.rgba(0, 0, 0, 0.1)
        width: parent.width*0.9
        height: width
        radius: width*0.01

        Grid {
            id: grille
            width: parent.width*0.95
            height: width
            anchors.centerIn: parent
            spacing: 2
            columns: game.dimension
            Repeater {
                id: myRepeat
                model: game.mySolvingGrid
                Rectangle {
                    property string estate:myEstate
                    id: thisrect
                    width: (rectGrille.width-(game.dimension-1)*2)/game.dimension
                    height: width
                    color: thisrect.estate=="full"?Theme.highlightColor:Qt.rgba(0, 0, 0, 0.1)
                    opacity: thisrect.estate=="full"?0.6:1
                    radius: rectGrille.radius
                    Item{
                        id: cross
                        opacity: (thisrect.estate=="hint")?0.6:0
                        Behavior on opacity {NumberAnimation{duration: 100}}
                        Rectangle{
                            color: Theme.highlightColor
                            width: thisrect.width*0.05
                            radius: thisrect.width*0.05
                            height: Math.sqrt(2*thisrect.width*thisrect.width)*0.9
                            transform: [Translate{x: -thisrect.width*0.025; y: height/18}, Rotation{angle: -45}]
                        }
                        Rectangle{
                            color: Theme.highlightColor
                            width: thisrect.width*0.05
                            radius: thisrect.width*0.05
                            height: Math.sqrt(2*thisrect.width*thisrect.width)*0.9
                            transform: [Translate{x: -thisrect.width*0.025; y: height/18}, Rotation{angle: 45}, Translate{x: thisrect.width}]
                        }
                    }
                }
            }
        }
    }

    Label {
        id: label
        anchors.centerIn: parent
        text: qsTr("Picross")
    }


    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                if (!game.applicationActive) {
                    game.activate()
                }
                pageStack.push(Qt.resolvedUrl("../pages/NewGame.qml"))
                game.pause=true
            }
        }
    }

}


