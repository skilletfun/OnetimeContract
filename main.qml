import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12


Window {
    id: root
    width: 600
    height: 600
    minimumHeight: 600
    minimumWidth: 600
    visible: true
    title: qsTr("Одновременная подпись контракта")

    color: "#3f3f3f"

    property variant target: ''

    Node {
        id: alice

        Image {
            id: a_icon
            visible: !trent.has_bob || trent.alice_ok
            source: 'warning.png'
            mipmap: true

            height: 50
            width: height
            anchors.right: parent.left
            anchors.bottom: parent.top
            anchors.margins: -10
        }

        property bool has_bob: false

        title: 'Алиса'
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: '#fff524'
        anchors_type: 0
        model_popup: '1"КА" -> (Т)%2"КА" -> (Б)%"КБ" <- (Т)%Подписать "КБ"%Сообщить (Т) о "КБ"'

        onAction: {
            if (index == 0)
            {
                prepare_bubble(alice, trent, 'КА', true, false);
//                trent.has_alice = true;
            }

            else if (index == 1)
            {
                sender.loops = 2;
                prepare_bubble(alice, bob, 'КА', true, false);
                bob.has_alice = true;
            }

            else if (index == 2)
            {
                if (trent.has_bob && !has_bob)
                {
                    for (var i = 0; i < trent.model.count; i++)
                    {
                        if (trent.model.get(i).owner === 'КБ')
                        {
                            trent.model.remove(i);
                            prepare_bubble(trent, alice, 'КБ', false, true);
                            has_bob = true;
                            break;
                        }
                    }
                }
            }

            else if (index == 3)
            {
                for (var i = 0; i < alice.model.count; i++)
                {
                    alice.model.setProperty(i, 'sign_a', true);
                }
            }

            else if (index == 4){ trent.alice_ok = true; a_icon.source = 'ok.png'; }
        }
    }

    Node {
        id: bob

        Image {
            id: b_icon
            visible: !trent.has_alice || trent.bob_ok
            source: 'warning.png'
            mipmap: true
            height: 50
            width: height

            anchors.right: parent.left
            anchors.bottom: parent.top
            anchors.margins: -10
        }

        property bool has_alice: false

        title: 'Боб'
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        color: '#fff524'
        anchors_type: 2
        model_popup: '1"КБ" -> (Т)%Подписать 2"КА"%Сообщить (Т) о "КА"%"КА" -> (A)'

        onAction: {
            if (index == 0)
            {
                prepare_bubble(bob, trent, 'КБ', false, true);
//                trent.has_bob = true;
            }

            else if (index == 1)
            {
                for (var i = 0; i < bob.model.count; i++)
                {
                    bob.model.setProperty(i, 'sign_b', true);
                }
            }

            else if (index == 2)
            {
                trent.bob_ok = true;
                b_icon.source = 'ok.png';
            }

            else if (index == 3)
            {
                var obj = bob.model.get(0);
                prepare_bubble(bob, alice, obj.owner, obj.sign_a, obj.sign_b);
                bob.model.remove(0);
            }
        }
    }

    Node {
        id: trent

        property bool has_alice: false
        property bool has_bob: false

        property bool alice_ok: false
        property bool bob_ok: false

        title: 'Трент'
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        color: '#C6782C'
        anchors_type: 1
        model_popup: 'Уведомить (А) о "КБ"%Уведомить (Б) о "КА"%Уничтожить "К"'

        onAction: {
            if (index == 0)
            {
                trent.has_bob = true;
            }

            else if (index == 1)
            {
                trent.has_alice = true;
            }

            else if (index == 2)
            {
                model.clear();
                if (alice_ok && bob_ok) result.open();
            }
        }
    }

    Popup {
        id: result
        anchors.centerIn: parent
        height: parent.height * 0.8
        width: parent.width * 0.8
        background: Rectangle { color: '#3f3f3f' }

        Text {
            text: 'Успех!'
            anchors.centerIn: parent
            font.pointSize: 24
            color: 'white'
        }
    }

    ParallelAnimation {
        id: sender
        property double to_x: 0
        property double to_y: 0

        PropertyAnimation {
            target: b_target
            duration: 1000
            property: 'x'
            to: sender.to_x
        }

        PropertyAnimation {
            target: b_target
            duration: 1000
            property: 'y'
            to: sender.to_y
        }

        onStopped: {
            for (var i = 0; i < loops; i++)
                root.target.model.append({'owner': b_target.text, sign_a: b_target.b_left, sign_b: b_target.b_right});
            b_target.visible = false;
            loops = 1;
        }
    }


    Bubble {
        id: b_target
        visible: false
    }

    function prepare_bubble(frommer, tooer, msg, sa, sb)
    {
        root.target = tooer;
        b_target.x = frommer.x + frommer.width/2-b_target.width/2;
        b_target.y = frommer.y + frommer.height/2-b_target.height/2;
        b_target.visible = true;
        b_target.text = msg;
        b_target.b_left = sa;
        b_target.b_right = sb;

        sender.to_x = tooer.x + tooer.width/2-b_target.width/2;
        sender.to_y = tooer.y + tooer.height/2-b_target.height/2;

        sender.start();
    }
}
