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
import "pages"
import "Source.js" as Source
import "DB.js" as DB


ApplicationWindow
{
    id: game
    initialPage: Component { MainPage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")

    signal gridUpdated
    signal checkWin
    signal win

    property int level: -1
    property int diff: -1

    property int selectedRadius: 2
    property int selectedCol: -1
    property int selectedLine: -1
    property int nbSelectedCols : (game.selectedCol===-1?0:1+Math.min(game.selectedRadius, game.selectedCol)+Math.min(game.selectedRadius, game.dimension-1-game.selectedCol))
    property int nbSelectedLines : (game.selectedLine===-1?0:1+Math.min(game.selectedRadius, game.selectedLine)+Math.min(game.selectedRadius, game.dimension-1-game.selectedLine))
    property bool guessMode: false


    property int dimension: 0
    property real zoom: 1
    property string hintTitle: ""
    property string title: ""
    property ListModel mySolvingGrid:ListModel{}
    property ListModel solvedGrid: ListModel{}
    property ListModel indicUp: ListModel{}
    property ListModel indicLeft: ListModel{}

    property int space
    property string save: ""
    property int nbSolvingFullCell
    property int nbSolvedFullCell

    Component.onCompleted: {
        DB.initialize()
        space = DB.getParameter("space")
    }
    Component.onDestruction: {
        if(game.diff !== -1 && !Source.checkWin() && !Source.nothingDone())
            DB.save(game.mySolvingGrid, game.diff, game.level)
    }

    onGridUpdated: {
        Source.genIndicCol(game.indicUp, game.solvedGrid)
        Source.genIndicLine(game.indicLeft, game.solvedGrid)
        if(save!=="")
            Source.loadSave(save)
        else
            Source.initVoid(game.mySolvingGrid)
        selectedCol=-1
        selectedLine=-1
    }

    onCheckWin: {
        if(Source.checkWin())
            win()
    }

    onWin: {
        pageStack.push(Qt.resolvedUrl("pages/WinPage.qml"))
        DB.setIsCompleted(diff, level, 'true')
        DB.eraseSave(diff, level)
    }
}
