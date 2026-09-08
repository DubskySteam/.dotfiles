import QtQuick 2.15
import QtQuick.XmlListModel 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#1a1b26"

    property int sessionIndex: sessionModel.lastIndex
    property string selectedProfile: "waybar"

    TextConstants { id: textConstants }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        anchors.fill: parent
        color: "#0f111a"
        opacity: 0.58
    }

    // The installer writes this readable mirror so SDDM can show the same
    // profile that the user selected during the previous session.
    XmlListModel {
        id: savedProfile
        source: "file:///var/lib/dotfiles/profile.xml"
        query: "/profile"
        XmlRole { name: "profileName"; query: "string(@name)" }
        onCountChanged: {
            if (count > 0)
                chooseProfile(get(0).profileName)
        }
    }

    function profileIndex(profile) {
        var wanted = profile === "quickshell" ? "Quickshell" : "Waybar"
        for (var index = 0; index < sessionModel.rowCount(); index++) {
            var name = sessionModel.data(sessionModel.index(index, 0), Qt.DisplayRole)
            if (String(name).indexOf(wanted) >= 0)
                return index
        }
        return sessionModel.lastIndex
    }

    function chooseProfile(profile) {
        if (profile !== "waybar" && profile !== "quickshell")
            profile = "waybar"
        selectedProfile = profile
        sessionIndex = profileIndex(profile)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            password.text = ""
            errorMessage.text = "Login failed. Try again."
        }
        function onLoginSucceeded() {
            errorMessage.text = "Starting " + selectedProfile + "..."
        }
    }

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 58
        anchors.topMargin: 48
        text: "DUBSKY / HYPRLAND"
        color: "#7aa2f7"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 15
        font.bold: true
    }

    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 58
        anchors.topMargin: 48
        text: Qt.formatDateTime(new Date(), "dddd, dd MMMM yyyy  HH:mm")
        color: "#a9b1d6"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 14
    }

    Rectangle {
        id: card
        width: 450
        height: 570
        anchors.centerIn: parent
        color: "#161821"
        opacity: 0.96
        radius: 18
        border.color: "#2f3549"
        border.width: 1

        Column {
            anchors.fill: parent
            anchors.margins: 38
            spacing: 18

            Text {
                text: "Welcome back"
                color: "#c0caf5"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 28
                font.bold: true
            }

            Text {
                text: "Choose a shell profile, then sign in."
                color: "#565f89"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
            }

            Text {
                text: "USER"
                color: "#7dcfff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.bold: true
            }

            TextBox {
                id: username
                width: parent.width
                height: 48
                text: userModel.lastUser
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                KeyNavigation.tab: password
            }

            Text {
                text: "PASSWORD"
                color: "#7dcfff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.bold: true
            }

            PasswordBox {
                id: password
                width: parent.width
                height: 48
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 14
                KeyNavigation.backtab: username
                KeyNavigation.tab: loginButton
                Keys.onPressed: {
                    if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                        sddm.login(username.text, password.text, sessionIndex)
                        event.accepted = true
                    }
                }
            }

            Text {
                text: "SHELL PROFILE"
                color: "#7dcfff"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 11
                font.bold: true
            }

            Row {
                width: parent.width
                height: 62
                spacing: 10

                Rectangle {
                    width: (parent.width - 10) / 2
                    height: parent.height
                    radius: 10
                    color: selectedProfile === "waybar" ? "#2f3549" : "#24283b"
                    border.color: selectedProfile === "waybar" ? "#7aa2f7" : "#2f3549"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "WAYBAR"
                        color: selectedProfile === "waybar" ? "#7aa2f7" : "#a9b1d6"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                    }
                    MouseArea { anchors.fill: parent; onClicked: chooseProfile("waybar") }
                }

                Rectangle {
                    width: (parent.width - 10) / 2
                    height: parent.height
                    radius: 10
                    color: selectedProfile === "quickshell" ? "#2f3549" : "#24283b"
                    border.color: selectedProfile === "quickshell" ? "#bb9af7" : "#2f3549"
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "QUICKSHELL"
                        color: selectedProfile === "quickshell" ? "#bb9af7" : "#a9b1d6"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 13
                        font.bold: true
                    }
                    MouseArea { anchors.fill: parent; onClicked: chooseProfile("quickshell") }
                }
            }

            Text {
                id: errorMessage
                width: parent.width
                height: 28
                text: ""
                color: "#f7768e"
                horizontalAlignment: Text.AlignHCenter
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
            }

            Button {
                id: loginButton
                width: parent.width
                height: 50
                text: "SIGN IN"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                onClicked: sddm.login(username.text, password.text, sessionIndex)
                KeyNavigation.backtab: password
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 22

                Button { text: "REBOOT"; onClicked: sddm.reboot() }
                Button { text: "SHUTDOWN"; onClicked: sddm.powerOff() }
            }
        }
    }

    Component.onCompleted: {
        chooseProfile("waybar")
        if (username.text === "") username.focus = true
        else password.focus = true
    }
}
