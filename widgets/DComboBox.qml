import QtQuick 2.1
import QtQuick.Window 2.1

Item {
    id: combobox
    width: Math.max(minMiddleWidth, parent.width)
    height: background.height

    property bool hovered: false
    property bool pressed: false

    // text property is deprecated, use value instead
    property var text: ""
    property alias value: combobox.text
    property alias menu: menu
    // labels property is deprecated, use itemModel instead
    property alias labels: menu.labels

    property var parentWindow
    property alias selectIndex: menu.currentIndex

    property Component delegate: Component {
        DssH2 { text: combobox.value; elide: Text.ElideRight }
    }
    property alias itemDelegate: menu.delegate
    property alias itemModel: menu.labels

    signal clicked
    signal menuSelect(int index)

    function select(index) {
        if(index != -1 && itemModel){
            value = itemModel[index]
        }
    }

    onSelectIndexChanged: select(selectIndex)

    Component.onCompleted: select(selectIndex)

    DMenu {
        id: menu
        parentWindow: combobox.parentWindow
        onMenuSelect: {
            combobox.select(index)
            combobox.menuSelect(index)
        }
    }

    function showMenu(x, y, w) {
        menu.x = x - menu.frameEdge + 1
        menu.y = y - menu.frameEdge - combobox.height
        menu.width = w + menu.frameEdge * 2 -2
        menu.showMenu()
    }

    onClicked: {
        var pos = mapToItem(null, 0, 0)
        var x = parentWindow.x + pos.x
        var y = parentWindow.y + pos.y + height
        var w = width
        showMenu(x, y, w)
    }

    QtObject {
        id: buttonImage
        property string status: "normal"
        property string header: "images/button_left_%1.png".arg(status)
        property string middle: "images/button_center_%1.png".arg(status)
        property string tail: "images/button_right_%1.png".arg(status)
    }

    property int minMiddleWidth: buttonHeader.width + downArrow.width + buttonTail.width

    Row {
        id: background
        height: buttonHeader.height
        width: parent.width

        Image{
            id: buttonHeader
            source: buttonImage.header
        }

        Image {
            id: buttonMiddle
            source: buttonImage.middle
            width: parent.width - buttonHeader.width - buttonTail.width
        }

        Image{
            id: buttonTail
            source: buttonImage.tail
        }
    }

    Rectangle {
        id: content
        width: buttonMiddle.width
        height: background.height
        anchors.left: parent.left
        anchors.leftMargin: buttonHeader.width
        anchors.verticalCenter: parent.verticalCenter
        color: Qt.rgba(1, 0, 0, 0)

        Loader {
            id: button_loader
            sourceComponent: combobox.delegate
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            onLoaded: {
                item.width = Qt.binding(function() { return content.width - downArrow.width })
            }
        }

        Image {
            id: downArrow
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            source: hovered ? "images/arrow_down_hover.png" : "images/arrow_down_normal.png"
        }

    }

    MouseArea{
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            parent.hovered = true
        }

        onExited: {
            parent.hovered = false
        }

        onPressed: {
            parent.pressed = true
            buttonImage.status = "press"
        }
        onReleased: {
            parent.pressed = false
            parent.hovered = containsMouse
            buttonImage.status = "normal"
        }

        onClicked: {
            combobox.clicked()
        }
    }
}
