import QtQuick 2.12

Rectangle {
    id: root
    width: 40
    height: width
    radius: height/2
    border.width: 1
    clip: true

    property string text: ''
    property bool b_left: false
    property bool b_right: false

    Rectangle {
        clip: true
        height: parent.height
        width: parent.width/2
        anchors.left: parent.left
        anchors.top: parent.top
        color: 'transparent'

        Rectangle {
            visible: root.b_left
            height: parent.height
            width: height
            radius: height/2
            color: 'green'
            anchors.left: parent.left
            anchors.top: parent.top
        }
    }

    Rectangle {
        clip: true
        height: parent.height
        width: parent.width/2
        anchors.right: parent.right
        anchors.top: parent.top
        color: 'transparent'

        Rectangle {
            visible: root.b_right
            height: parent.height
            width: height
            radius: height/2
            color: 'green'
            anchors.right: parent.right
            anchors.top: parent.top
        }
    }

    Text {
        text: root.text
        font.pointSize: 12
        anchors.centerIn: parent
    }
}
