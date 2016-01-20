import QtQuick 2.0
import Sailfish.Silica 1.0
import "../DB.js" as DB

Page{
    id: settingsPage
    RemorsePopup{ id: remorseSettings }
    Column{
        width: parent.width
        PageHeader{
            title: qstr("Settings")
        }
        TextSwitch{
            checked: DB.getParameter("autoLoadSave")===1
            text: qstr("Load saves by default")
            description: checked?qstr("Saves will be loaded by default"):qstr("Load them by a long press")
            onClicked:{
                if(checked)
                    DB.setParameter("autoLoadSave", 1)
                else
                    DB.setParameter("autoLoadSave", 0)
            }
        }
        TextSwitch{
            checked: DB.getParameter("slideInteractive")===1
            text: qstr("Swipe throught difficulty")
            description: checked?qstr("Swipe is enabled"):qstr("Swipe disable. Click on a difficulty name to load it")
            onClicked:{
                if(checked)
                    DB.setParameter("slideInteractive", 1)
                else
                    DB.setParameter("slideInteractive", 0)
            }
        }
        Slider {
            id: slider
            width: parent.width
            label: qstr("Space between separators")
            minimumValue: 0
            maximumValue: 10
            stepSize: 1
            value: DB.getParameter("space")
            valueText: value
            onValueChanged: {
                game.space = slider.value
                DB.setParameter("space", slider.value)
            }
        }
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text: qstr("Clear ALL databases (saves & progress)")

            onClicked:{
                remorseSettings.execute(qstr("Clearing ALL Databases"), function(){
                    DB.destroyData()
                    DB.initialize()})
            }
        }
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text: qstr("Clear only saves database")
            onClicked:{
                remorseSettings.execute(qstr("Clearing only saves database"), function(){
                    DB.destroySaves()
                    DB.initializeSaves()})
            }
        }
        Button{
            anchors.horizontalCenter: parent.horizontalCenter
            text: qstr("Reset settings")
            onClicked:{
                remorseSettings.execute(qstr("Resetting settings"), function(){
                    DB.destroySettings()
                    pageStack.pop()
                })
            }
        }
    }
    Component.onDestruction:{
        game.pause=false
    }
}
