import QtQuick 2.0
import Sailfish.Silica 1.0
import "../Levels.js" as Levels
import "../DB.js" as DB



Page{
    id: levelInfos
    property int diffSelected
    property int levelSelected

    property string title
    property string hintTitle
    property int dimension
    property ListModel grid

    Component.onCompleted: {
        title = Levels.getTitle(diffSelected, levelSelected)
        hintTitle = Levels.getHintTitle(diffSelected, levelSelected)
        dimension = Levels.getDimension(diffSelected, levelSelected)
        grid = Levels.getGrid(diffSelected, levelSelected)
    }

    Column{
        anchors.fill: parent
        PageHeader{
            title: qsTr("Level details")
        }
        Item{
            anchors.horizontalCenter: parent.horizontalCenter
            height: infoDimension.height
            width: infoDimension.width
            Label{
                color: Theme.highlightColor
                id: infoDimension
                text: "["+dimension+"x"+dimension+"]"
            }
        }
        Rectangle{
            border.color: Theme.rgba(Theme.highlightColor, 0.3)
            border.width: 5
            width: parent.width*3/4
            height: width
            color: Theme.rgba("black", 0.1)
            anchors.horizontalCenter: parent.horizontalCenter
            Grid{
                id: myFinalGrid
                anchors.centerIn: parent
                width: parent.width*0.9
                height: width
                columns: dimension
                spacing: 5
                Repeater{
                    model: grid
                    Rectangle{
                        width: (myFinalGrid.width-(dimension-1)*5)/dimension
                        height: width
                        opacity: 0.2
                        color: myEstate==="full"?Theme.highlightColor:"transparent"
                    }
                }
            }
        }
        Item{
            anchors.horizontalCenter: parent.horizontalCenter
            height: infoTitle.height
            width: infoTitle.width
            Label{
                color: Theme.highlightColor
                id: infoTitle
                text: title
            }
        }
        Item{
            anchors.horizontalCenter: parent.horizontalCenter
            height: infoHintTitle.height
            width: infoHintTitle.width
            Label{
                color: "white"
                font.pixelSize: Theme.fontSizeSmall
                id: infoHintTitle
                text: hintTitle
            }
        }
        Label{
            anchors.topMargin: Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            color: Theme.highlightColor
            text: qsTr("Best time:")
        }
        Label{
            property int time : DB.getTime(diffSelected, levelSelected)
            anchors.horizontalCenter: parent.horizontalCenter
            text: time===0?"xx:xx:xx":new Date(null, null, null, null, null, time).toLocaleTimeString(Qt.locale(), "HH:mm:ss")
        }
    }
}
