import QtQuick 2.0

DTextInput {
    property int min: 0
    property int max: 100
    property int step: 1

    property int value: parseInt(textInput.text)

    function setValue(i){
        textInput.text = i
    }

    textInput.validator: IntValidator{bottom: min; top: max;}

    textInput.anchors.rightMargin: 3 + buttonBox.width

    Component.onCompleted: setValue(0)

    Connections{
        target: textInput
        onTextChanged: {
            if(textInput.text == ""){
                textInput.text = min
            }
        }
    }

    Connections {
        target: increaseButton.mouseArea
        onPressAndHold: {
            holdTimer.isIncrease = true
            holdTimer.restart()
        }
        onReleased: {
            holdTimer.stop()
        }
    }

    Connections {
        target: decreaseButton.mouseArea
        onPressAndHold: {
            holdTimer.isIncrease = false
            holdTimer.restart()
        }
        onReleased: {
            holdTimer.stop()
        }
    }

    Timer {
        id: holdTimer
        repeat: true
        interval: 50
        property bool isIncrease: true
        onTriggered: {
            if(isIncrease){
                increase()
            }
            else{
                decrease()
            }
        }
    }

    function increase(){
        if(value <= max - step){
            setValue(value + step)
        }
        else{
            setValue(max)
        }
    }

    function decrease(){
        if(value >= min + step){
            setValue(value - step)
        }
        else{
            setValue(min)
        }
    }

    Row {
        id: buttonBox
        parent: textInputBox
        height: parent.height
        anchors.right: parent.right

        DOpacityImageButton {
            id: increaseButton
            anchors.verticalCenter: parent.verticalCenter
            source: "images/spinner_increase.png"
            onClicked: increase()
        }

        DOpacityImageButton {
            id: decreaseButton
            anchors.verticalCenter: parent.verticalCenter
            source: "images/spinner_decrease.png"
            onClicked: decrease()
        }
    }
}
