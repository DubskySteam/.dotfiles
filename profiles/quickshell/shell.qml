import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Scope {
    id: root

    property string loadAverage: "--"
    property string memoryUsage: "--"

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    // One low-frequency process serves every monitor instead of one process
    // per bar. Hyprland state itself is event-driven through the native module.
    Process {
        id: stats
        command: ["sh", "-c", "load=$(cut -d' ' -f1 /proc/loadavg); mem=$(awk '/^MemTotal:/ { total=$2 } /^MemAvailable:/ { available=$2 } END { printf \"%d%%\", (total-available)*100/total }' /proc/meminfo); printf '%s %s' \"$load\" \"$mem\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                var values = this.text.trim().split(" ")
                if (values.length >= 2) {
                    root.loadAverage = values[0]
                    root.memoryUsage = values[1]
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: stats.running = true
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }
            margins: [20, 20, 0, 20]
            implicitHeight: 38
            exclusiveZone: 58

            Rectangle {
                anchors.fill: parent
                color: "#1a1b26"
                border.color: "#2f3549"
                border.width: 1
                radius: 11

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 8

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Repeater {
                            model: Hyprland.workspaces

                            Rectangle {
                                required property var modelData
                                Layout.preferredWidth: Math.max(26, workspaceLabel.implicitWidth + 18)
                                Layout.fillHeight: true
                                radius: 8
                                color: modelData.focused ? "#7aa2f7" : (modelData.urgent ? "#f7768e" : "transparent")

                                Text {
                                    id: workspaceLabel
                                    anchors.centerIn: parent
                                    text: modelData.name
                                    color: modelData.focused || modelData.urgent ? "#1a1b26" : "#565f89"
                                    font.family: "JetBrainsMono Nerd Font"
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: modelData.activate()
                                }
                            }
                        }

                        Text {
                            Layout.leftMargin: 10
                            Layout.fillWidth: true
                            text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : "Desktop"
                            color: "#c0caf5"
                            elide: Text.ElideRight
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.bold: true
                        }
                    }

                    Text {
                        text: "󰻠 " + root.loadAverage + "   󰍛 " + root.memoryUsage
                        color: "#9ece6a"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 11
                        font.bold: true
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "ddd dd MMM  HH:mm")
                        color: "#bb9af7"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                        font.bold: true
                    }

                    Rectangle {
                        Layout.preferredWidth: profileLabel.implicitWidth + 22
                        Layout.fillHeight: true
                        radius: 8
                        color: profileMouse.containsMouse ? "#2f3549" : "transparent"

                        Text {
                            id: profileLabel
                            anchors.centerIn: parent
                            text: "QS  ⚙"
                            color: "#7dcfff"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 12
                            font.bold: true
                        }

                        MouseArea {
                            id: profileMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: profileMenu.startDetached()
                        }

                        Process {
                            id: profileMenu
                            command: ["sh", "-c", "$HOME/.local/bin/dotfiles-profile menu"]
                        }
                    }
                }
            }
        }
    }
}
