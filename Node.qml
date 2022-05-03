import QtQuick 2.12
import QtQuick.Controls 2.12

Rectangle {
    id: root
    radius: height / 2
    width: height
    height: 100 + add_h
    anchors.margins: 100 - add_h/2
    border.width: 4

    property alias model: model_contract

    property int add_h: area.containsMouse ? 15 : 0

    property string title: ''

    property string model_popup: ''
    property int anchors_type: 0

    signal action(var index)

    Behavior on height { NumberAnimation { easing.type: Easing.InCubic; duration: 150; } }
    Behavior on anchors.margins { NumberAnimation { easing.type: Easing.InCubic; duration: 150; } }

    Text {
        text: root.title
        font.pixelSize: parent.height/3.5
        anchors.centerIn: parent
        color: 'black'
    }

    MouseArea {
        id: area
        hoverEnabled: true
        anchors.fill: parent
        onReleased: { actions.open(); }
    }

    Row {
        spacing: 10
        anchors.left: parent.right
        anchors.bottom: parent.top
        anchors.margins: -10

        Repeater {
            model: model_contract
            delegate: Bubble {
                b_left: sign_a
                b_right: sign_b
                text: owner
            }
        }
    }

    Rectangle {
        id: rect_actions
        color: 'transparent'
        height: 240
        width: 300
        x: anchors_type == 0 ? root.width/2 + 50 : anchors_type == 1 ? -width/2+root.width/2 : -width
        y: anchors_type == 1 ? root.height : -150

        Popup {
            id: actions
            modal: true
            height: parent.height
            width: parent.width
            anchors.centerIn: parent

            background: Rectangle { color: '#3f3f3f' }

            enter: Transition {
                PropertyAnimation { property: 'opacity'; from: 0; to: 1 }
            }

            exit: Transition {
                PropertyAnimation { property: 'opacity'; from: 1; to: 0 }
            }

            ListView {
                id: view
                spacing: 5
                anchors.fill: parent
                clip: true
                model: root.model_popup.split('%')

                delegate: Button {
                    width: view.width
                    height: 50
                    text: modelData
                    font.pointSize: 14
                    onReleased: { root.action(index); actions.close(); }
                }
            }
        }
    }

    ListModel {
        id: model_contract
    }
}
