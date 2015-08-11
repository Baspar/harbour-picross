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

    DialogHeader{
        id: pageTitle
        title: "New game"
        MouseArea{
            anchors.fill: parent
            onPressAndHold: cheatMode = !cheatMode
        }
    }

    Column{
        id: decoratorTop
        anchors.top: pageTitle.bottom
        width: dialog.width
        anchors.horizontalCenter: dialog.horizontalCenter
        SilicaListView{
            height: 40
            orientation: ListView.Horizontal
            width: parent.width
            model:ListModel{
                id: diffList
                Component.onCompleted: Levels.getDifficultiesAndLevels(diffList)
            }
            delegate : Rectangle{
                color: "transparent"
                height: parent.height
                width: decoratorTop.width/diffList.count
                Label{
                    anchors.centerIn: parent
                    color: (Levels.isLocked(index))?"grey":"white"
                    text:name
                    font.pixelSize: 20
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked:mySlideShowView.currentIndex=index
                }
            }
        }
        Item{
            y:40
            width: parent.width
            Rectangle{
                x: parent.width/diffList.count*mySlideShowView.currentIndex
                height: Theme.paddingSmall
                color: Theme.highlightColor
                width: parent.width/diffList.count
                Behavior on x {NumberAnimation{duration: 100}}
            }
            Rectangle{
                width: parent.width
                height: Theme.paddingSmall
                color: Theme.rgba(Theme.highlightColor, 0.2)
            }
        }
    }

    SlideshowView{
        interactive: DB.getParameter("slideInteractive")===1 && diffSelected===-1
        id: mySlideShowView
        clip: true
        width: dialog.width
        anchors.top: decoratorTop.bottom
        anchors.bottom: dialog.bottom
        model: ListModel{
            id: difficultyList
            Component.onCompleted: Levels.getDifficultiesAndLevels(difficultyList)
        }
        delegate : Rectangle{
            property int myDiff: index
            width: parent.width
            height: parent.height
            color: Qt.rgba(0, 0, 0, 0.1)
            Column{
                anchors.topMargin: Theme.paddingSmall
                anchors.fill: parent
                spacing: Theme.paddingSmall
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

                Rectangle{
                    id: separatorRect
                    width: parent.width
                    height: Theme.paddingSmall
                    color: Theme.rgba(Theme.highlightColor, 0.2)
                }

                SilicaListView{
                    clip: true
                    VerticalScrollDecorator{}
                    id: levelView
                    height: parent.height - separatorRect.height - diffHeader.height - 2*Theme.paddingMedium
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
                                Levels.arrayToList(index, levelList)
                            else
                                levelList.clear()
                        }
                    }
                    delegate: ListItem{
                        property int myLevel: index
                        id: listItem
                        menu: contextMenu
                        Label{
                            id: levelTitle
                            text:  (myLevel+1)+". "+(DB.isCompleted(myDiff, myLevel)?title:"?????")+ " - ["+dimension+"x"+dimension+"]"
                            x: Theme.paddingMedium
                            color: (listItem.highlighted|| (myLevel==levelSelected && myDiff==diffSelected)) ? Theme.highlightColor
                                                                     : Theme.primaryColor
                        }
                        Label{
                            anchors.top: levelTitle.bottom
                            x: Theme.paddingLarge
                            anchors.topMargin: Theme.paddingSmall
                            text: hintTitle
                            font.pixelSize: Theme.fontSizeSmall
                            color: Theme.secondaryColor
                        }
                        onClicked:{
                            if(cheatMode)
                                DB.setIsCompleted(myDiff, myLevel, 'true')
                            else{
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

                        Component {
                            id: contextMenu
                            ContextMenu {
                                MenuItem {
                                    text: "Play from scratch"
                                    onClicked: {
                                        diffSelected=myDiff
                                        levelSelected=myLevel
                                        save=""
                                    }
                                }
                                MenuItem {
                                    visible: DB.getSave(myDiff, myLevel)!==""
                                    text: "Restore save"
                                    onClicked: {
                                        diffSelected=myDiff
                                        levelSelected=myLevel
                                        save=DB.getSave(myDiff, myLevel)
                                    }
                                }
                                MenuItem {
                                    visible: DB.getSave(myDiff, myLevel)!==""
                                    text: "Erase save"
                                    onClicked: {
                                        DB.eraseSave(myDiff, myLevel)
                                    }
                                }
                                MenuItem {
                                    visible: DB.isCompleted(myDiff, myLevel)
                                    text: "Details"
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

        Component.onCompleted:{
            mySlideShowView.positionViewAtIndex(Levels.getCurrentDiff(), PathView.SnapPosition)
        }
    }


    onAccepted: {
        if(game.diff !== -1 && !Source.checkWin() && !Source.nothingDone())
            DB.save(game.mySolvingGrid, game.diff, game.level)
        game.diff=diffSelected
        game.level=levelSelected
        game.save=save
        Levels.initSolvedGrid(game.solvedGrid, diffSelected, levelSelected)

        game.gridUpdated()
    }
}
