import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source
import "../DB.js" as DB

Page {
    RemorsePopup{ id: remorseMain }

    property int insideBorderSize: 5
    property int outsideBorderSize: 10
    property int selectedCol:-1
    property int selectedLine:-1


    id: page

    // PopUp Zoom
    Rectangle{
        id: popupZoom
        z:2
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
                    text: "Zoom"
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

    /*Rectangle{
    z:3
    visible: selectedLine!==-1
    color: Theme.rgba("black", selectedLine!==-1?0.5:0)
    Behavior on color{ColorAnimation{duration: 100}}
    anchors.fill: parent
    MouseArea{
    enabled: selectedLine!==-1
    anchors.fill: parent
    onClicked:selectedLine=-1
    }
    Row{
    spacing: 2
    x: 0
    y: pageHeader.height+100+ selectedLine*(page.width-outsideBorderSize-100+insideBorderSize)/game.dimension*game.zoom-flick.contentY
    height: ((page.width-outsideBorderSize-100+insideBorderSize)/game.dimension-insideBorderSize)*game.zoom
    Rectangle{
    color: Theme.rgba(Theme.highlightColor, 0.3)
    height: parent.height
    width: outsideBorderSize
    }
    Repeater{
    model: selectedLine!==-1?game.indicLeft.get(selectedLine).loadedIndic:0
    Label{
    color: game.indicLeft.get(selectedLine).toFill?"red":game.indicLeft.get(selectedLine).completed?"green":Theme.highlightColor
    text: size
    }
    }
    Rectangle{
    color: Theme.rgba(Theme.highlightColor, 0.3)
    height: parent.height
    width: outsideBorderSize
    }
    }
    }*/

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
                           remorseMain.execute("Accepting guesses", function(){
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
                           remorseMain.execute("Rejecting guesses", function(){
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
                        text: "Accept\nguesses"
                        color: leftMouseArea.pressed||acceptIcon.pressed?Theme.highlightColor:Theme.primaryColor
                    }
                    IconButton{
                        id: acceptIcon
                        icon.source: "image://theme/icon-header-accept"
                        highlighted: leftMouseArea.pressed
                        onClicked: if(Source.noGuessDone()){
                                   Source.acceptGuesses()
                                   goDefault.start()
                               }else{
                                   remorseMain.execute("Accepting guesses", function(){
                                       Source.acceptGuesses()
                                       goDefault.start()
                                   }, 3000)
                               }
                    }
                    IconButton {
                        id: rejectIcon
                        icon.source: "image://theme/icon-header-cancel"
                        highlighted: rightMouseArea.pressed
                        onClicked: if(Source.noGuessDone()){
                                   Source.rejectGuesses()
                                   goDefault.start()
                               }else{
                                   remorseMain.execute("Rejecting guesses", function(){
                                       Source.rejectGuesses()
                                       goDefault.start()
                                   }, 3000)
                               }
                    }
                    Label{
                        text: "Reject\nguesses"
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
            }

            PageHeader {
                id: pageHeader
                title: game.hintTitle===""?"Picross":game.hintTitle
                description: game.dimension===0?"":game.dimension+"x"+game.dimension//+" - "+game.nbSolvingFullCell+"/"+game.nbSolvedFullCell
            }
        }

        // PullDown
        PullDownMenu {
            MenuItem {
                id: menuSettings
                text: qsTr("Settings")
                onClicked: {
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
                onClicked: remorseMain.execute("Clearing the grid", function(){Source.clear()}, 3000)
            }
            MenuItem {
                id: menuNewGame
                text: qsTr("New game")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("NewGame.qml"))
                }
            }
        }

        // Grid part
        Column{
            y: pageHeader.height
            width: parent.width


            // Hint
            ViewPlaceholder {
                enabled: (game.dimension===0)
                text: qsTr("Welcome to Picross")
                hintText: qsTr("Please choose a level from the pulley menu")
            }

            // Grid part
            Item{
                visible: (game.dimension!==0)
                id: gridPartRectangle
                width: page.width
                height: page.height-pageHeader.height

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
                                                opacity: finalIndicLeft.contentX!==finalIndicLeft.contentWidth-finalIndicLeft.width
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
        }
    }
}
