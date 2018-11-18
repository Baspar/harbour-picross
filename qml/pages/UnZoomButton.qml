import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: unzoom
    Rectangle{
        id: unzoomButton
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(game.zoom===1) {
//                    game.zoom=((page.height-pageHeader.height-maxSizeIndicTop-outsideBorderSize+insideBorderSize)/game.dimension-insideBorderSize)
//                                                                                 /
//                            ((page.width-maxSizeIndicLeft-outsideBorderSize+insideBorderSize)/game.dimension-insideBorderSize)
                        //game.zoom=3
                    if(game.dimension < 6)
                        zoom = 2
                    else if(game.dimension < 16)
                        zoom = 3
                    else
                        zoom = 4
                }
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

        Image {
            source: "image://theme/icon-m-search"
            width: 4 * parent.width / 5
            height: 4 * parent.height / 5
            anchors.centerIn: parent
        }
    }
}
