import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.folderlistmodel

Window {
    id: root

    width: 360
    height: Math.min(900, Screen.height - 40)
    x: 24
    y: (Screen.height - height) / 2
    minimumWidth: 0
    minimumHeight: 0
    visible: panelOpen
    color: "transparent"
    flags: Qt.Tool | Qt.FramelessWindowHint | Qt.WindowDoesNotAcceptFocus
    title: "Wallpapers"

    property bool panelOpen: false
    property color accent: "#65c9b8"
    property color accentAlt: "#e7ad68"
    property color textColor: "#eff3f7"
    property color mutedColor: "#94a3b1"
    property color backgroundColor: "#10151b"
    property color surfaceColor: "#18212a"
    property color borderColor: "#303a44"
    property string statusText: "Elige un fondo para actualizar tu entorno"
    property bool applying: false
    property string currentWallpaper: ""

    Timer {
        id: closeTimer
        interval: 120
        onTriggered: root.panelOpen = false
    }

    HoverHandler {
        onHoveredChanged: {
            if (hovered)
                closeTimer.stop()
            else if (root.panelOpen)
                closeTimer.start()
        }
    }

    PanelWindow {
        id: edgeSensor
        anchors {
            left: true
            top: true
            bottom: true
        }
        implicitWidth: 3
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: {
                closeTimer.stop()
                root.panelOpen = true
            }
        }
    }

    PanelWindow {
        id: notificationEdgeSensor
        anchors {
            right: true
            top: true
            bottom: true
        }
        implicitWidth: 3
        margins {
            top: Screen.height * 0.3
            bottom: Screen.height * 0.3
        }
        exclusiveZone: 0
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            acceptedButtons: Qt.NoButton
            onEntered: swayncToggle.running = true
        }
    }

    Process {
        id: swayncToggle
        command: ["swaync-client", "-t"]
    }

    IpcHandler {
        target: "wallpaperSelector"

        function toggle() {
            closeTimer.stop()
            root.panelOpen = !root.panelOpen
        }
    }

    FolderListModel {
        id: wallpaperModel
        folder: "file:///home/skl4vier/Imágenes/Wallpapers"
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp", "*.PNG", "*.JPG", "*.JPEG", "*.WEBP"]
        showDirs: false
        showFiles: true
        sortField: FolderListModel.Name
    }

    Process {
        id: paletteProcess
        command: ["cat", "/home/skl4vier/.cache/wallpaper-theme/palette.json"]
        stdout: StdioCollector {
            id: paletteOutput
        }

        onExited: function(exitCode, exitStatus) {
            if (exitCode !== 0)
                return
            try {
                const palette = JSON.parse(paletteOutput.text)
                root.accent = palette.accent
                root.accentAlt = palette.accent_alt
                root.textColor = palette.text
                root.mutedColor = palette.dim
                root.backgroundColor = palette.background
                root.surfaceColor = palette.surface
                root.borderColor = palette.border
                root.currentWallpaper = palette.wallpaper
                root.statusText = "Actual: " + palette.wallpaper.split("/").pop()
            } catch (error) {
                root.statusText = "Elige un fondo para actualizar tu entorno"
            }
        }
    }

    Process {
        id: themeProcess
        stdout: StdioCollector {
            id: processOutput
        }
        command: []

        onExited: function(exitCode, exitStatus) {
            root.applying = false
            if (exitCode !== 0) {
                root.statusText = "No se pudo aplicar el tema. Comprueba awww y la imagen."
                return
            }

            try {
                const palette = JSON.parse(processOutput.text)
                root.accent = palette.accent
                root.accentAlt = palette.accent_alt
                root.textColor = palette.text
                root.mutedColor = palette.dim
                root.backgroundColor = palette.background
                root.surfaceColor = palette.surface
                root.borderColor = palette.border
                root.currentWallpaper = palette.wallpaper
                root.statusText = "Tema aplicado: " + palette.wallpaper.split("/").pop()
            } catch (error) {
                root.statusText = "Wallpaper aplicado"
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        radius: 10
        color: root.backgroundColor
        clip: true

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            height: 3
            color: root.accent
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 28
            spacing: 18

            RowLayout {
                Layout.fillWidth: true
                spacing: 14

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    Text {
                        text: "Temas de escritorio"
                        color: root.textColor
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 22
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: wallpaperModel.count + " fondos"
                        color: root.mutedColor
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 12
                    }
                }

            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: root.borderColor
            }

            GridView {
                id: wallpaperGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: wallpaperModel
                cellWidth: width / 2
                cellHeight: 190
                boundsBehavior: Flickable.StopAtBounds
                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                }

                delegate: Item {
                    property int wallpaperIndex: index
                    property string wallpaperPath: wallpaperModel.get(wallpaperIndex, "filePath")
                    property string wallpaperName: wallpaperModel.get(wallpaperIndex, "fileName")
                    width: wallpaperGrid.cellWidth
                    height: wallpaperGrid.cellHeight

                    Rectangle {
                        id: tile
                        anchors.fill: parent
                        anchors.margins: 7
                        radius: 8
                        color: root.surfaceColor
                        clip: true

                        Behavior on scale { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
                        scale: hoverArea.containsMouse ? 1.015 : 1

                        Image {
                            anchors.fill: parent
                            source: wallpaperPath
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: true
                        }

                        Rectangle {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            height: 66
                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "transparent" }
                                GradientStop { position: 1.0; color: Qt.alpha(root.backgroundColor, 0.92) }
                            }
                        }

                        RowLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.margins: 12
                            spacing: 8

                            Text {
                                Layout.fillWidth: true
                                text: wallpaperName
                                color: root.textColor
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 12
                                elide: Text.ElideMiddle
                            }

                            Rectangle {
                                visible: root.currentWallpaper === wallpaperPath
                                width: 9
                                height: 9
                                radius: 5
                                color: root.accentAlt
                            }
                        }

                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (root.applying)
                                    return
                                root.applying = true
                                root.statusText = "Analizando colores y aplicando wallpaper…"
                                themeProcess.command = ["python3", "/home/skl4vier/.config/scripts/wallpaper_theme.py", wallpaperPath]
                                themeProcess.running = true
                            }
                        }

                        Rectangle {
                            anchors.fill: parent
                            radius: 8
                            color: "transparent"
                            border.width: 2
                            border.color: root.accent
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: wallpaperModel.count === 0
                    text: "No hay imágenes en ~/Imágenes/Wallpapers"
                    color: root.mutedColor
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 14
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: root.borderColor
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12

                Row {
                    spacing: 6
                    Repeater {
                        model: [root.accent, root.accentAlt, root.surfaceColor]
                        delegate: Rectangle {
                            required property color modelData
                            width: 16
                            height: 16
                            radius: 5
                            color: modelData
                            border.width: 1
                            border.color: Qt.alpha(root.textColor, 0.16)
                        }
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: root.statusText
                    color: root.mutedColor
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    elide: Text.ElideRight
                }

                Text {
                    text: "SUPER  SHIFT  W"
                    color: root.accent
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                }
            }
        }
    }

    Shortcut {
        sequence: "Escape"
        onActivated: root.panelOpen = false
    }

    Component.onCompleted: paletteProcess.running = true
}
