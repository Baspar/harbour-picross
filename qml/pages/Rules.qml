import QtQuick 2.0
import Sailfish.Silica 1.0

Page{
    id: rules
    Column{
        width: parent.width
        PageHeader{
            title: "Rules"
        }
        SectionHeader{
            text:"General topic"
        }
        Label{
            width: parent.width
            text:"Picross (Also known as Griddlers, Nonogram or Hanjie) are puzzle games, in which you have to represent a picture by coloring cells, or by letting them blank. In this version, grid won't be bigger than 20x20."
        }
        SectionHeader{
            text:"Resolution"
        }
    }
}
