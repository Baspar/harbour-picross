import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: unzoom
    Rectangle{
        id: unzoomButton
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(game.zoom===1)
//                    game.zoom=((page.height-pageHeader.height-maxSizeIndicTop-outsideBorderSize+insideBorderSize)/game.dimension-insideBorderSize)
//                            /
//                            ((page.width-maxSizeIndicLeft-outsideBorderSize+insideBorderSize)/game.dimension-insideBorderSize)
                        game.zoom=3
                else{
                    game.zoom=1
                    foldTopMode=true
                }
            }
        }

        width: 0.9*(sizeIndicLeft-outsideBorderSize)
        height: 0.9*(sizeIndicTop-outsideBorderSize)
        x: width/18
        y: height/18
        color: Qt.rgba(0, 0, 0, 0)
        border.width: 5
        border.color: Theme.rgba(Theme.highlightColor, 0.3)

        property int unitW : width/12
        property int unitH : height/12
        Rectangle{
            x: 5+2*unzoomButton.unitW
            y: 5+2*unzoomButton.unitH
            width: 3*unzoomButton.unitW
            height: unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+2*unzoomButton.unitW
            y: 5+3*unzoomButton.unitH
            width: unzoomButton.unitW
            height: 2*unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+2*unzoomButton.unitW
            y: 5+7*unzoomButton.unitH
            width: unzoomButton.unitW
            height: 2*unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+2*unzoomButton.unitW
            y: 5+9*unzoomButton.unitH
            width: 3*unzoomButton.unitW
            height: unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+7*unzoomButton.unitW
            y: 5+2*unzoomButton.unitH
            width: 3*unzoomButton.unitW
            height: 1*unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+9*unzoomButton.unitW
            y: 5+3*unzoomButton.unitH
            width: unzoomButton.unitW
            height: 2*unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+9*unzoomButton.unitW
            y: 5+7*unzoomButton.unitH
            width: unzoomButton.unitW
            height: 2*unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+7*unzoomButton.unitW
            y: 5+9*unzoomButton.unitH
            width: 3*unzoomButton.unitW
            height: unzoomButton.unitH
            color: Theme.highlightColor
            opacity:0.3
        }

    }
}
