import QtQuick 2.0
import Sailfish.Silica 1.0

Item{
    id: unzoom
    Rectangle{
        id: unzoomButton
        NumberAnimation{
            id: animateUnZoom
            target: game
            properties: "zoom"
            to: 1
            duration: 500
            easing {type: Easing.OutBounce}
        }
        NumberAnimation{
            id: animateZoom
            target: game
            properties: "zoom"
            to: (page.height-pageHeader.height/2)/page.width
            duration: 500
            easing {type: Easing.OutBounce}
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if(game.zoom===1)
                    animateZoom.start()
                else
                    animateUnZoom.start()
            }

        }

        width: 100 - 30
        height: 100 - 30
        x: 10
        y: x
        color: Qt.rgba(0, 0, 0, 0)
        border.width: 5
        border.color: Theme.rgba(Theme.highlightColor, 0.3)
        property int unit : width/12
        Rectangle{
            x: 5+2*unzoomButton.unit
            y: 5+2*unzoomButton.unit
            width: 3*unzoomButton.unit
            height: unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+2*unzoomButton.unit
            y: 5+3*unzoomButton.unit
            width: unzoomButton.unit
            height: 2*unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+2*unzoomButton.unit
            y: 5+7*unzoomButton.unit
            width: unzoomButton.unit
            height: 2*unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+2*unzoomButton.unit
            y: 5+9*unzoomButton.unit
            width: 3*unzoomButton.unit
            height: unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+7*unzoomButton.unit
            y: 5+2*unzoomButton.unit
            width: 3*unzoomButton.unit
            height: 1*unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+9*unzoomButton.unit
            y: 5+3*unzoomButton.unit
            width: unzoomButton.unit
            height: 2*unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+9*unzoomButton.unit
            y: 5+7*unzoomButton.unit
            width: unzoomButton.unit
            height: 2*unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }
        Rectangle{
            x: 5+7*unzoomButton.unit
            y: 5+9*unzoomButton.unit
            width: 3*unzoomButton.unit
            height: unzoomButton.unit
            color: Theme.highlightColor
            opacity:0.3
        }

    }
}
