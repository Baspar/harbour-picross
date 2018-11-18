import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Source.js" as Source
import "../Levels.js" as Levels
import "../DB.js" as DB

Dialog{
    property int diffSelected: -1
    property int levelSelected: -1
    property string save: ""
    property bool cheatMode: false

    id: dialog
    canAccept: diffSelected!=-1

    // Title: New game
    DialogHeader{
        id: pageTitle
        title: cheatMode?qsTr("Cheat..."):qsTr("New game")
        MouseArea{
            anchors.fill: parent
//            onPressAndHold: cheatMode = !cheatMode
        }
    }

    // Difficulty list
    Column{
        id: decoratorTop
        anchors.top: pageTitle.bottom
        width: dialog.width
        anchors.horizontalCenter: dialog.horizontalCenter
        SilicaListView{
            id: silicaDiffList
            height: Theme.fontSizeHuge
            orientation: ListView.Horizontal
            width: parent.width
            model:ListModel{
                id: diffList
                Component.onCompleted: Levels.getDifficultiesAndLevels(diffList)
            }
            // Difficulty item (bounding box)
            delegate : Rectangle{
                color: Theme.highlightDimmerColor
                height: parent.height
                width: decoratorTop.width/diffList.count
                // Difficulty text
                Label{
                    anchors.centerIn: parent
                    color: (Levels.isLocked(index))?"grey":"white"
                    text:name
                    font.pixelSize: Theme.fontSizeTiny
                    font.bold: true
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:mySlideShowView.currentIndex=index
                    onPressed: parent.color = Theme.highlightColor
                    onReleased: parent.color = Theme.highlightDimmerColor
                }
            }
        }
        Item{
            width: parent.width
            // Difficulty highlight rectangle...
            Rectangle{
                x: parent.width/diffList.count*mySlideShowView.currentIndex-silicaDiffList.contentY
                height: Theme.paddingSmall
                color: Theme.highlightColor
                width: parent.width/diffList.count
                Behavior on x {NumberAnimation{duration: 100}}
            }
            /// ...and its background
            Rectangle{
                width: parent.width
                height: Theme.paddingSmall
                color: Theme.rgba(Theme.highlightColor, 0.2)
            }
        }
    }

    // Level list
    SlideshowView{
        interactive: DB.getParameter("slideInteractive")===1 && diffSelected===-1
        id: mySlideShowView
        clip: true
        width: parent.width
        anchors.top: decoratorTop.bottom
        anchors.bottom: parent.bottom
        model: ListModel{
            id: difficultyList
            Component.onCompleted: Levels.getDifficultiesAndLevels(difficultyList)
        }
        delegate : Rectangle{
            property int myDiff: index
            width: parent.width
            height: parent.height
            color: "transparent"
            Column{
                anchors.topMargin: Theme.paddingSmall
                anchors.fill: parent
                spacing: Theme.paddingSmall
                // Diff details
                Item{
                    height: diffHeader.height
                    width: parent.width
                    Label{
                        id: diffHeader
                        anchors.centerIn: parent
                        text: name+" ["+DB.getNbCompletedLevel(myDiff)+"/"+levelList.count+"]"
                        color: Theme.highlightColor
                        Component.onCompleted: {
                            if(Levels.isLocked(myDiff))
                                text = name+" [?/?]"
                        }
                    }
                }

                // Separator
                Rectangle{
                    id: separatorRect
                    width: parent.width
                    height: Theme.paddingSmall
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }

                // Level list
                SilicaListView{
                    clip: true
                    VerticalScrollDecorator{}
                    id: levelView
                    height: parent.height - separatorRect.height - diffHeader.height - Theme.paddingMedium
                    width: parent.width

                    ViewPlaceholder{
                        verticalOffset: -pageTitle.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        enabled : Levels.isLocked(myDiff)
                        text: qsTr("Locked")
                        hintText: qsTr("Complete all previous levels to unlock this difficulty")
                    }

                    model: ListModel{
                        id: levelList
                        Component.onCompleted: {
                            if(!Levels.isLocked(myDiff))
                                Levels.arrayToList(myDiff, levelList)
                            else
                                levelList.clear()
                        }
                    }
                    delegate: ListItem{
                        property int myLevel: index
                        id: listItem
                        menu: contextMenu
                        Rectangle{
                            anchors.fill: parent
                            visible: (listItem.highlighted || (myLevel==levelSelected && myDiff==diffSelected))
                            color: Theme.highlightBackgroundColor
                            opacity: Theme.highlightBackgroundOpacity
                        }

                        // Draw empty level completex checkbox
                        Image {
                            id: levelCheckbox
                            source: "image://theme/icon-m-tabs"
                            width: 2*Theme.paddingLarge
                            height: 2*Theme.paddingLarge
                            x: Theme.paddingMedium
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // If the level is completed, draw the tick in the box
                        Image {
                            id: levelCheckboxTick
                            visible: DB.isCompleted(myDiff, myLevel)
                            source: "image://theme/icon-m-dismiss"
                            width: Theme.paddingLarge*1.6
                            height: Theme.paddingLarge*1.6
                            x: Theme.paddingMedium + 0.2 * Theme.paddingLarge
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        // First row, e.g. "[3x3] Box"
                        Label{
                            id: levelTitle
                            text: (myLevel+1)+". ["+dimension+"x"+dimension+"] " + (DB.isCompleted(myDiff, myLevel)?title:"?????")
                            font.pixelSize: Theme.fontSizeMedium
                            anchors.left: levelCheckbox.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.right: parent.right
                        }
                        // Second row, e.g. "Numbers = size of the groups"
                        Label{
                            id: levelDescription
                            anchors.top: levelTitle.bottom
                            anchors.left: levelCheckbox.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.right: parent.right
                            text: hintTitle
                            font.pixelSize: Theme.fontSizeSmall
                        }
                        onClicked:{
                            if(cheatMode){
                                DB.setIsCompleted(myDiff, myLevel, 'true')
                                levelTitle.text= (myLevel+1)+". ["+dimension+"x"+dimension+"] " + (DB.isCompleted(myDiff, myLevel)?title:"?????")
                                levelTitle.color= (listItem.highlighted || (myLevel==levelSelected && myDiff==diffSelected)) ? Theme.highlightColor
                                                                     : DB.isCompleted(myDiff, myLevel)? Theme.primaryColor:"grey"
                            }else{
                                if(diffSelected !== myDiff || levelSelected !== myLevel){
                                    diffSelected=myDiff
                                    levelSelected=myLevel
                                    save=DB.getParameter("autoLoadSave")===0?"":DB.getSave(myDiff, myLevel)
                                } else {
                                    diffSelected=-1
                                    levelSelected=-1
                                }
                            }
                        }

                        // Context menu
                        Component {
                            id: contextMenu
                            ContextMenu {
                                MenuItem {
                                    text: qsTr("Play from scratch")
                                    onClicked: {
                                        diffSelected=myDiff
                                        levelSelected=myLevel
                                        save=""
                                    }
                                }
                                MenuItem {
                                    visible: DB.getSave(myDiff, myLevel)!==""
                                    text: qsTr("Restore save")
                                    onClicked: {
                                        diffSelected=myDiff
                                        levelSelected=myLevel
                                        save=DB.getSave(myDiff, myLevel)
                                    }
                                }
                                MenuItem {
                                    visible: DB.getSave(myDiff, myLevel)!==""
                                    text: qsTr("Erase save")
                                    onClicked: {
                                        DB.eraseSave(myDiff, myLevel)
                                    }
                                }
                                MenuItem {
                                    visible: DB.isCompleted(myDiff, myLevel)
                                    text: qsTr("Details")
                                    onClicked: {
                                        pageStack.push(Qt.resolvedUrl("LevelInfos.qml"), {"diffSelected":myDiff, "levelSelected":myLevel})
                                    }
                                }
                            }
                        }
                    }

                }
            }
        }
    }


    // Load last diff
    Component.onCompleted:{
        if(!cheatMode)
            mySlideShowView.positionViewAtIndex(Levels.getCurrentDiff(), PathView.SnapPosition)
    }

    onAccepted: {
        Source.save()
        game.diff=diffSelected
        game.level=levelSelected
        game.save=save
        Levels.initSolvedGrid(game.solvedGrid, diffSelected, levelSelected)

        game.gridUpdated()
    }
    onRejected: {
        game.pause=false
    }
}
