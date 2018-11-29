import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source
import "../DB.js" as DB

Page {
        RemorsePopup{ id: remorseMain }

        onStatusChanged: {
            // Prepare the next level
            if(status == PageStatus.Active) {
                pageStack.pop(Qt.resolvedUrl("pages/ScorePage.qml"))
            }
        }

        property int insideBorderSize: 5
        property int outsideBorderSize: 10
        property variant difficulties: [
            qsTr("Tutorial"),
            qsTr("Easy"),
            qsTr("Medium"),
            qsTr("Hard"),
            qsTr("Expert"),
            qsTr("Insane")
        ]
        property string hintTitleCp: game.hintTitle
        onHintTitleCpChanged: {
                pageHeader.title=qsTr("Dimension")+": "+game.dimension+"x"+game.dimension
                pageHeader.description=qsTr("Good luck!")
                resetPageHeader.start()
        }

        id: page

        // PopUp Zoom
        Rectangle{
                id: popupZoom
                z:3
                opacity: 0
                color: Theme.rgba("black", 0.5)
                anchors.fill: page
                Rectangle{
                        color: Theme.rgba("black", 0.2)
                        width: page.width/2
                        height: popupZoomText.height
                        anchors.centerIn: parent
                        Column{
                                id: popupZoomText
                                anchors.horizontalCenter: parent.horizontalCenter
                                Label{
                                        text: qsTr("Zoom")
                                        color: Theme.highlightColor
                                        font.pixelSize: Theme.fontSizeLarge
                                        anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Label{
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: "x"+Math.floor(pinchArea.zoomTmp===-1?10*game.zoom:10*pinchArea.zoomTmp)/10
                                }
                                ProgressBar{
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        width: page.width/2
                                        maximumValue: 3
                                        minimumValue: 1
                                        value:Math.floor(pinchArea.zoomTmp===-1?10*game.zoom:10*pinchArea.zoomTmp)/10
                                }
                        }

                }

                Behavior on opacity{NumberAnimation{duration: 200}}
        }

        // PopUp Flash
        Rectangle {
                id: flash
                anchors.fill:parent
                opacity:0
                color: "white"
                signal flash()
                onFlash: anim.running=true

                SequentialAnimation {
                        id: anim
                        NumberAnimation {
                                target: flash
                                property: "opacity"
                                to: 0.5
                                duration: 0
                        }
                        NumberAnimation {
                                target: flash
                                property: "opacity"
                                to: 0
                                duration: 500
                        }
                }
        }

        // Set pinch area
        PinchArea {
                id: pinchArea
                property real initialZoom
                property real zoomTmp : -1
                anchors.fill: parent
                onPinchStarted: {
                        if(game.dimension!==0)
                                popupZoom.opacity = 1
                        initialZoom = game.zoom
                        zoomTmp = game.zoom
                }
                onPinchUpdated: {
                        zoomTmp = (initialZoom*pinch.scale>3)?3:(initialZoom*pinch.scale<1)?1:initialZoom*pinch.scale
                }
                onPinchFinished:{
                        popupZoom.opacity = 0
                        if(game.dimension!==0)
                                game.zoom = zoomTmp
                        zoomTmp = -1
                }

                Rectangle{
                        color: "transparent"
                        anchors.fill: parent
                }
        }

        // Everything else
        SilicaFlickable {
                id: flickUp
                    interactive: game.slideMode===""
                anchors.fill: parent

                // Hidden controls for guess mode
                SilicaFlickable{
                        clip:true
                        contentHeight: pageHeader.height
                        contentWidth: page.width
                        height: pageHeader.height
                        width: rectPageHeader.x
                        MouseArea{
                                id: leftMouseArea
                                enabled: game.guessMode
                                width: page.width/2
                                height: pageHeader.height
                                x:0
                                onClicked: if(Source.noGuessDone()){
                                                   Source.acceptGuesses()
                                                   goDefault.start()
                                           }else{
                                                   remorseMain.execute(qsTr("Accepting guesses"), function(){
                                                           Source.acceptGuesses()
                                                           goDefault.start()
                                                   }, 3000)
                                           }
                        }
                        MouseArea{
                                id: rightMouseArea
                                enabled: game.guessMode
                                width: page.width/2
                                height: pageHeader.height
                                x: page.width/2
                                onClicked: if(Source.noGuessDone()){
                                                   Source.rejectGuesses()
                                                   goDefault.start()
                                           }else{
                                                   remorseMain.execute(qsTr("Rejecting guesses"), function(){
                                                           Source.rejectGuesses()
                                                           goDefault.start()
                                                   }, 3000)
                                           }
                        }

                        // Buttons accept/reject
                        Rectangle{
                                width: page.width
                                height: pageHeader.height
                                color: Theme.rgba(Theme.highlightColor, 0.3)
                                Row{
                                        anchors.centerIn: parent
                                        spacing: Theme.paddingSmall
                                        Label{
                                                text: qsTr("Accept\nguesses")
                                                color: leftMouseArea.pressed||acceptIcon.pressed?Theme.highlightColor:Theme.primaryColor
                                        }
                                        IconButton{
                                                id: acceptIcon
                                                icon.source: "image://theme/icon-m-add"
                                                highlighted: leftMouseArea.pressed
                                                onClicked: if(Source.noGuessDone()){
                                                                   Source.acceptGuesses()
                                                                   goDefault.start()
                                                           }else{
                                                                   remorseMain.execute(qsTr("Accepting guesses"), function(){
                                                                           Source.acceptGuesses()
                                                                           goDefault.start()
                                                                   }, 3000)
                                                           }
                                        }
                                        IconButton {
                                                id: rejectIcon
                                                icon.source: "image://theme/icon-m-clear"
                                                highlighted: rightMouseArea.pressed
                                                onClicked: if(Source.noGuessDone()){
                                                                   Source.rejectGuesses()
                                                                   goDefault.start()
                                                           }else{
                                                                   remorseMain.execute(qsTr("Rejecting guesses"), function(){
                                                                           Source.rejectGuesses()
                                                                           goDefault.start()
                                                                   }, 3000)
                                                           }
                                        }
                                        Label{
                                                text: qsTr("Reject\nguesses")
                                                color: rightMouseArea.pressed||rejectIcon.pressed?Theme.highlightColor:Theme.primaryColor
                                                horizontalAlignment: Text.AlignLeft
                                        }

                                }
                        }

                        // Shadow
                        Rectangle {
                                width: page.width
                                height: pageHeader.height/6
                                y: pageHeader.height - height
                                gradient: Gradient {
                                        GradientStop { position: 0.0; color: Theme.rgba("black", 0) }
                                        GradientStop { position: 1.0; color: Theme.rgba("black", 0.5) }
                                }
                        }
                }

                // Dragable pageHeader
                Rectangle{
                        property bool gameGuessMode: game.guessMode

                        onGameGuessModeChanged: {
                                if(gameGuessMode && !goOpen.running)
                                        goOpen.start()
                                if(!gameGuessMode && !goDefault.running)
                                        goDefault.start()
                        }

                        id: rectPageHeader
                        color: "transparent"
                        width: page.width
                        height: pageHeader.height
                        NumberAnimation {
                                id: goDefault
                                target: rectPageHeader
                                properties: "x"
                                to: 0
                                onRunningChanged: {
                                        if(running)
                                                game.guessMode=false
                                }
                        }
                        NumberAnimation {
                                id: goOpen
                                target: rectPageHeader
                                properties: "x"
                                to:page.width
                                onRunningChanged: {
                                        if(running)
                                                game.guessMode=true
                                }
                        }
                        MouseArea{
                                enabled: game.dimension!==0
                                anchors.fill: parent
                                drag.target: parent
                                drag.axis: Drag.XAxis
                                drag.minimumX: 0
                                drag.maximumX: page.width
                                drag.onActiveChanged: {
                                        if(!drag.active){
                                                if(rectPageHeader.x<page.width/3)
                                                        goDefault.start()
                                                else{
                                                        goOpen.start()
                                                }
                                        }
                                }
                                onClicked:{
                                    if(!resetPageHeader.running){
                                        pageHeader.title=qsTr("Dimension")+": "+game.dimension+"x"+game.dimension
                                        pageHeader.description="Elapsed time: "+time===0?"xx:xx:xx":game.time>=60*60*23?"24:00:00+":new Date(null, null, null, null, null, time).toLocaleTimeString(Qt.locale(), "HH:mm:ss");
                                        resetPageHeader.start()
                                    }else
                                        resetPageHeader.restart()
                                }
                        }

                        PageHeader {
                                id: pageHeader
                                title: qsTr("Picross")
                                description: " "
                                Behavior on title{
                                            SequentialAnimation {
                                                NumberAnimation { target: pageHeader; property: "opacity"; to: 0 }
                                                PropertyAction {}
                                                NumberAnimation { target: pageHeader; property: "opacity"; to: 1 }
                                            }
                                        }
                                Behavior on description{
                                            SequentialAnimation {
                                                NumberAnimation { target: pageHeader; property: "opacity"; to: 0 }
                                                PropertyAction {}
                                                NumberAnimation { target: pageHeader; property: "opacity"; to: 1 }
                                            }
                                        }
                                Timer{
                                        id: resetPageHeader
                                        interval: 2000
                                        onTriggered: {
                                            pageHeader.title = qsTr("Picross") + (game.hintTitle==="" ? "" : ": "+difficulties[game.diff]+" "+qsTr("Level")+" "+(game.level+1))
                                            pageHeader.description = (game.hintTitle==="" ? " " : game.hintTitle)
                                        }
                                }
                        }
                }

                // PullDown
                PullDownMenu {
                        enabled: game.slideMode===""
                        MenuItem {
                                id: menuSettings
                                text: qsTr("Settings")
                                onClicked: {
                                        game.pause=true
                                        pageStack.push(Qt.resolvedUrl("Settings.qml"))
                                }
                        }
                        MenuItem {
                                id: menuGuess
                                visible: game.dimension!==0 && !game.guessMode
                                text: qsTr("Guess mode")
                                onClicked: {
                                        goOpen.start()
                                }
                        }
                        MenuItem {
                                id: menuClear
                                visible: game.dimension!==0 && !game.guessMode
                                text: qsTr("Clear grid")
                                onClicked: remorseMain.execute(qsTr("Clearing the grid"), function(){Source.clear()}, 3000)
                        }
                        MenuItem {
                                id: menuNewGame
                                text: qsTr("Level select")
                                onClicked: {
                                        game.pause=true
                                        pageStack.push(Qt.resolvedUrl("NewGame.qml"))
                                }
                        }
                }

                // Grid part
                Column{
                        anchors.top: rectPageHeader.bottom
                        anchors.bottom: parent.bottom
                        width: parent.width

                        // Hint
                        ViewPlaceholder {
                                enabled: (game.dimension===0)
                                text: qsTr("Welcome to Picross")
                                hintText: qsTr("Please choose a level from the pulley menu")
                        }

                        // Whole grid
                        WholeGrid{
                                width: parent.width
                        }
                }
        }
}
