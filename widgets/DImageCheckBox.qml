import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

CheckBox {
    property int fontSize: 12
    property url imageSource
    property int spacing: 2

    text: "hello"
    style: CheckBoxStyle {
        spacing: control.spacing
        background: Item {}
        indicator: Image {
            source: control.checked ? control.hovered ? "images/checkbox_checked_hover.png" : "images/checkbox_checked.png"
                                    : control.hovered ? "images/checkbox_unchecked_hover.png" : "images/checkbox_unchecked.png"
        }
        label: Image {
            source: control.imageSource
        }
    }
}