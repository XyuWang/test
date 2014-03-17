import QtQuick 2.0

Rectangle {
    id: slider
    height: 40
    width: 320

    property real min: -1
    property real max: 1
    property real init: min+(max-min)/2
    property alias handlerVisible: handle.visible
    property alias completeColorVisible: colorCompleteRect.visible
    property bool valueDisplayVisible: true
    property alias handler: handle
    property bool rulerAtEdgeDisplay: false

    color: Qt.rgba(0, 0, 0, 0)

    signal valueConfirmed

    Component.onCompleted: {
        setValue(init, false)
    }

    onInitChanged: {
        setValue(init, false)
    }

    function setValue(v, emit) {
        if(min < max)
        handle.x = (v-min)/(max - min) * (mousearea.drag.maximumX - mousearea.drag.minimumX)
            + mousearea.drag.minimumX
        if(emit){
            valueConfirmed()
        }
    }

    function addRuler(value, label){
        ruler.model.append({
            "rulerValue": value,
            "rulerLabel": label
        })
    }

    property real value: min + (max - min) * mousearea.value
    property int grooveWidth: width - handleWidth + 2
    property int grooveHeight: 8
    property int handleWidth: handle.width

    onValueChanged: {
        if(valueDisplayVisible){
            valueDisplay.showValue()
        }
    }

    DLabel{
        id: valueDisplay
        visible: false
        anchors.bottom: sliderDragArea.top
        x: handle.x + (handle.width - width)/2
        text: {
            var intV = parseInt(slider.value)
            if(intV == slider.value){
                return intV
            }
            else{
                slider.value.toFixed(2)
            }
        }

        function showValue(){
            valueDisplay.visible = true
            valueDisplayTimeoutHide.restart()
        }

        Timer{
            id: valueDisplayTimeoutHide
            running: false
            repeat: false
            interval: 1000
            onTriggered:{
                valueDisplay.visible = false
            }
        }
    }

    Rectangle {
        id: sliderDragArea
        anchors.verticalCenter: parent.verticalCenter
        width: grooveWidth + handleWidth - 2
        height: grooveHeight * 2
        clip: true
        color: Qt.rgba(1, 0, 0, 0)
        z: 10

        Rectangle{
            id: foo
            width: grooveWidth
            height: grooveHeight
            radius: height
            anchors.centerIn: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 1.0; color: "#303132" }
            }

            Rectangle {
                id: realValueRect
                width: parent.width - 2
                height: grooveHeight - 2
                anchors.centerIn: parent
                radius: height
                color: Qt.rgba(15/255, 15/255, 15/255, 1.0)

                Rectangle {
                    id: colorCompleteRect
                    width: parent.width * (slider.value - min)/(max-min)
                    height: parent.height
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    radius: height
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0, 104/255, 170/255, 1.0) }
                        GradientStop { position: 1.0; color: Qt.rgba(91/255, 164/255, 211/255, 1.0) }
                    }
                }
            }

            MouseArea{
                anchors.top: parent.top
                anchors.topMargin: -10
                anchors.left: parent.left
                width: parent.width
                height: parent.height + 20
                hoverEnabled: true

                onReleased: {
                    if(containsMouse){
                        var rulerPos = Object.keys(ruler.xToValueDict)
                        for(var i in rulerPos){
                            if(Math.abs(mouse.x - rulerPos[i]) <= 10){
                                slider.setValue(ruler.xToValueDict[rulerPos[i]], true)
                                return
                            }
                        }
                        handle.x = mouse.x
                        valueConfirmed()
                    }
                }
            }

        }

        Image {
            id: handle
            source: "images/slider_handle.svg"
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: mousearea
                anchors.fill: parent
                anchors.margins: -4
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: 0
                drag.maximumX: realValueRect.width
                property real value: (handle.x - drag.minimumX) / (drag.maximumX - drag.minimumX)

                onReleased: {
                    valueConfirmed()
                }
            }
        }
    }
    
    Rectangle{
        anchors.top: sliderDragArea.bottom
        anchors.topMargin: -4
        width: realValueRect.width
        height: parent.height - sliderDragArea.height
        anchors.horizontalCenter: parent.horizontalCenter
        color: Qt.rgba(1, 0, 0, 0)

        Repeater{
            id: ruler

            property var xToValueDict: {
                var rDict = {}
                for(var i=0; i<model.count; i++){
                    var v = model.get(i).rulerValue
                    var xPos = getXPos(v)
                    rDict[xPos] = v 
                }
                return rDict
            }
            model: ListModel {}

            function getXPos(v){
                return (v-min)/(max - min) * (mousearea.drag.maximumX - mousearea.drag.minimumX)
            }

            delegate: Item{
                width: 1
                height: childrenRect.height
                x: {
                    if(rulerValue == max){
                        return realValueRect.width
                    }
                    else{
                        return ruler.getXPos(rulerValue)
                    }
                }

                Rectangle {
                    id: rulerLine
                    visible: {
                        if(rulerValue == max | rulerValue == min){
                            return rulerAtEdgeDisplay
                        }
                        else{
                            return true
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: dconstants.fgColor
                    width: 1
                    height: 7
                }

                DLabel {
                    anchors.top: parent.top
                    anchors.topMargin: {
                        if(rulerLine.visible){
                            return rulerLine.height
                        }
                        else{
                            return 2
                        }
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: rulerLabel
                }
            }
        }

    }
}
