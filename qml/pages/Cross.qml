import QtQuick 2.0
import Sailfish.Silica 1.0
Item{
    id: cross
    opacity: (thisrect.estate=="hint")?0.6:0
    Behavior on opacity {NumberAnimation{duration: 100}}
    Rectangle{
        color: Theme.highlightColor
        width: thisrect.width*0.05
        radius: thisrect.width*0.05
        height: Math.sqrt(2*thisrect.width*thisrect.width)*0.9
        transform: [Translate{x: -thisrect.width*0.0; y: height/18}, Rotation{angle: -45}]
    }
    Rectangle{
        color: Theme.highlightColor
        width: thisrect.width*0.05
        radius: thisrect.width*0.05
        height: Math.sqrt(2*thisrect.width*thisrect.width)*0.9
        transform: [Translate{x: -thisrect.width*0.0; y: height/18}, Rotation{angle: 45}, Translate{x: thisrect.width}]
    }
}
