import QtQuick 2.0

DTextInput {
    id: fileChooseInput

    signal fileChooseClicked

    textInput.anchors.rightMargin: 3 + buttonBox.width
    Item {
        id: buttonBox
        parent: textInputBox
        width: childrenRect.width
        height: parent.height
        anchors.right: parent.right
        z: 10

        Rectangle {
            width: 1
            height: parent.height
            color: Qt.rgba(1, 1, 1, 0.1)
        }

        Rectangle {
            width: parent.width - 1
            height: parent.height
            anchors.right: parent.right
            radius: 3
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: increaseButton.pressed ? Qt.rgba(0, 0, 0, 0.05) : Qt.rgba(1, 1, 1, 0.05)
                }
                GradientStop {
                    position: 1.0
                    color: increaseButton.pressed ? Qt.rgba(0, 0, 0, 0) : Qt.rgba(1, 1, 1, 0)
                }
            } 
        }

        DImageButton {
            id: increaseButton
            anchors.verticalCenter: parent.verticalCenter
            normal_image: "images/file_choose.png"
            hover_image: normal_image
            press_image: normal_image
            onClicked: fileChooseInput.fileChooseClicked()
        }
    }
}
