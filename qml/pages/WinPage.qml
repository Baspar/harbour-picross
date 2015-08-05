import QtQuick 2.0
import Sailfish.Silica 1.0


Page{
    id: winPage

    Column{
        anchors.fill: parent
        PageHeader{
            title: "Level completed!"
        }
        SectionHeader{
            text: "Solution"
        }
        Rectangle{
            border.width: 5
            border.color: Theme.rgba(Theme.highlightColor, 0.3)
            width: parent.width*3/4
            height: width
            color: Theme.rgba("black", 0.1)
            anchors.horizontalCenter: parent.horizontalCenter
            Grid{
                id: myFinalGrid
                anchors.centerIn: parent
                width: parent.width*0.9
                height: width
                columns: game.dimension
                spacing: 5
                Repeater{
                    model: game.solvedGrid
                    Rectangle{
                        width: (myFinalGrid.width-(game.dimension-1)*5)/game.dimension
                        height: width
                        opacity: 0.2
                        color: myEstate==="full"?Theme.highlightColor:"transparent"
                    }
                }
            }
        }
        Item{
            anchors.horizontalCenter: parent.horizontalCenter
            height: winTitle.height
            width: winTitle.width
            Label{
                id: winTitle
                text: game.title
            }
        }
    }
}
