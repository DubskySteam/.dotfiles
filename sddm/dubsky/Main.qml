import QtQuick 2.15
import QtQuick.XmlListModel 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "#090d18"

    property int sessionIndex: sessionModel.lastIndex
    property string selectedProfile: "waybar"
    property string uiFont: "JetBrainsMono Nerd Font"

    property color textPrimary: "#f4f7ff"
    property color textSecondary: "#bec9dc"
    property color textMuted: "#8b98af"
    property color blue: "#9bc5ff"
    property color lilac: "#c9b8ff"
    property color glass: "#a6172238"
    property color glassRaised: "#b8212e49"
    property color glassInput: "#321c2b45"
    property color glassLine: "#55ffffff"

    // Keep the complete card visible on smaller greeter resolutions.
    property real cardScale: Math.max(0.72, Math.min(1,
        Math.min((width - 48) / 460, (height - 80) / 590)))

    TextConstants { id: textConstants }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
    }

    // The dark wash keeps the high-contrast wallpaper from competing with the
    // translucent controls while preserving its blue highlights.
    Rectangle {
        anchors.fill: parent
        opacity: 0.54
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#d9081020" }
            GradientStop { position: 0.5; color: "#b8091020" }
            GradientStop { position: 1.0; color: "#ed050812" }
        }
    }

    // Soft color pools add depth behind the glass without requiring an
    // optional QtGraphicalEffects package in the SDDM environment.
    Rectangle {
        width: root.width * 0.58
        height: width * 0.58
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: -width * 0.28
        anchors.bottomMargin: -height * 0.34
        radius: width
        opacity: 0.34
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3e83d61c" }
            GradientStop { position: 0.58; color: "#1e5a8fd0" }
            GradientStop { position: 1.0; color: "#00101930" }
        }
    }

    Rectangle {
        width: root.width * 0.52
        height: width
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: -width * 0.24
        anchors.topMargin: -height * 0.34
        radius: width
        opacity: 0.27
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#3c9bb7ff" }
            GradientStop { position: 0.58; color: "#1f5c6ca4" }
            GradientStop { position: 1.0; color: "#00101930" }
        }
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
            password.focus = true
            errorMessage.text = "Login failed. Try again."
        }
        function onLoginSucceeded() {
            errorMessage.text = "Starting " + selectedProfile + "..."
        }
    }

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: Math.max(28, root.width * 0.03)
        anchors.topMargin: Math.max(28, root.height * 0.045)
        text: "DUBSKY"
        color: root.textPrimary
        font.family: root.uiFont
        font.pixelSize: 15
        font.bold: true
        font.letterSpacing: 2.8
    }

    Text {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: Math.max(28, root.width * 0.03)
        anchors.topMargin: Math.max(52, root.height * 0.07)
        text: "HYPRLAND / SECURE LOGIN"
        color: root.blue
        font.family: root.uiFont
        font.pixelSize: 10
        font.letterSpacing: 1.5
    }

    Text {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: Math.max(28, root.width * 0.03)
        anchors.topMargin: Math.max(30, root.height * 0.045)
        text: Qt.formatDateTime(new Date(), "dddd, dd MMMM yyyy   HH:mm")
        color: root.textSecondary
        font.family: root.uiFont
        font.pixelSize: 13
    }

    Rectangle {
        id: cardShadow
        width: card.width + 30
        height: card.height + 30
        anchors.centerIn: card
        radius: card.radius + 15
        color: "#000000"
        opacity: 0.38
    }

    Rectangle {
        id: card
        width: 460
        height: 590
        scale: root.cardScale
        anchors.centerIn: parent
        color: root.glass
        radius: 28
        border.color: "#66ffffff"
        border.width: 1
        clip: true

        // A bright upper wash creates the characteristic glass edge highlight.
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: parent.height * 0.42
            radius: parent.radius
            opacity: 0.7
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#25ffffff" }
                GradientStop { position: 0.34; color: "#0dffffff" }
                GradientStop { position: 1.0; color: "#00ffffff" }
            }
        }

        Column {
            anchors.fill: parent
            anchors.margins: 34
            spacing: 12

            Text {
                text: "Welcome back"
                color: root.textPrimary
                font.family: root.uiFont
                font.pixelSize: 29
                font.bold: true
            }

            Text {
                text: "Choose a shell profile, then sign in."
                color: root.textSecondary
                font.family: root.uiFont
                font.pixelSize: 12
            }

            Item { width: 1; height: 2 }

            Text {
                text: "USER"
                color: root.blue
                font.family: root.uiFont
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.4
            }

            TextBox {
                id: username
                width: parent.width
                height: 50
                text: userModel.lastUser
                color: root.glassInput
                borderColor: "#3dffffff"
                focusColor: root.blue
                hoverColor: "#75ffffff"
                textColor: root.textPrimary
                radius: 15
                font.family: root.uiFont
                font.pixelSize: 13
                KeyNavigation.tab: password
            }

            Text {
                text: "PASSWORD"
                color: root.blue
                font.family: root.uiFont
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.4
            }

            PasswordBox {
                id: password
                width: parent.width
                height: 50
                color: root.glassInput
                borderColor: "#3dffffff"
                focusColor: root.blue
                hoverColor: "#75ffffff"
                textColor: root.textPrimary
                radius: 15
                font.family: root.uiFont
                font.pixelSize: 13
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
                color: root.blue
                font.family: root.uiFont
                font.pixelSize: 10
                font.bold: true
                font.letterSpacing: 1.4
            }

            Row {
                width: parent.width
                height: 58
                spacing: 10

                Rectangle {
                    id: waybarProfile
                    width: (parent.width - 10) / 2
                    height: parent.height
                    radius: 16
                    color: selectedProfile === "waybar" ? root.glassRaised : root.glassInput
                    border.color: selectedProfile === "waybar" ? root.blue : "#35ffffff"
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 180 } }
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    Text {
                        anchors.centerIn: parent
                        text: "WAYBAR"
                        color: selectedProfile === "waybar" ? root.textPrimary : root.textSecondary
                        font.family: root.uiFont
                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 1.2
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: chooseProfile("waybar")
                    }
                }

                Rectangle {
                    id: quickshellProfile
                    width: (parent.width - 10) / 2
                    height: parent.height
                    radius: 16
                    color: selectedProfile === "quickshell" ? root.glassRaised : root.glassInput
                    border.color: selectedProfile === "quickshell" ? root.lilac : "#35ffffff"
                    border.width: 1

                    Behavior on color { ColorAnimation { duration: 180 } }
                    Behavior on border.color { ColorAnimation { duration: 180 } }

                    Text {
                        anchors.centerIn: parent
                        text: "QUICKSHELL"
                        color: selectedProfile === "quickshell" ? root.textPrimary : root.textSecondary
                        font.family: root.uiFont
                        font.pixelSize: 12
                        font.bold: true
                        font.letterSpacing: 0.6
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: chooseProfile("quickshell")
                    }
                }
            }

            Text {
                id: errorMessage
                width: parent.width
                height: 28
                text: ""
                color: "#ff9eaf"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.family: root.uiFont
                font.pixelSize: 11
                wrapMode: Text.WordWrap
            }

            Button {
                id: loginButton
                width: parent.width
                height: 52
                radius: 16
                color: root.blue
                activeColor: "#b7dbff"
                pressedColor: "#78aaf0"
                borderColor: "#e5f3ff"
                textColor: "#101829"
                text: "SIGN IN"
                font.family: root.uiFont
                font.pixelSize: 12
                font.bold: true
                onClicked: sddm.login(username.text, password.text, sessionIndex)
                KeyNavigation.backtab: password
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 12

                Button {
                    width: 104
                    height: 32
                    radius: 12
                    color: "#1affffff"
                    activeColor: "#32ffffff"
                    pressedColor: "#4affffff"
                    borderColor: "#62ffffff"
                    textColor: root.textSecondary
                    text: "REBOOT"
                    font.family: root.uiFont
                    font.pixelSize: 10
                    font.bold: true
                    onClicked: sddm.reboot()
                }

                Button {
                    width: 104
                    height: 32
                    radius: 12
                    color: "#1affffff"
                    activeColor: "#32ffffff"
                    pressedColor: "#4affffff"
                    borderColor: "#62ffffff"
                    textColor: root.textSecondary
                    text: "SHUTDOWN"
                    font.family: root.uiFont
                    font.pixelSize: 10
                    font.bold: true
                    onClicked: sddm.powerOff()
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 1
            radius: parent.radius - 1
            color: "transparent"
            border.color: "#26ffffff"
            border.width: 1
        }
    }

    Component.onCompleted: {
        chooseProfile("waybar")
        if (username.text === "") username.focus = true
        else password.focus = true
    }
}
