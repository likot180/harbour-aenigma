import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2

import org.nubecula.aenigma 1.0

import "../."
import "../components"

Page {    
    id: page

    allowedOrientations: Orientation.Portrait

    function reset() {
        Sudoku.reset()
        Global.selectedNumber = -1
        Global.resetCells()
        Global.refrechCells()
    }

    DisplayBlanking {
        preventBlanking: Sudoku.gameState === GameState.Playing && settings.preventDisplayBlanking && app.visible
    }

    PageBusyIndicator {
        anchors.centerIn: parent
        running: Sudoku.gameState === GameState.Generating
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                //% "About"
                text: qsTrId("id-about")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                //% "Settings"
                text: qsTrId("id-settings")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("SettingsPage.qml"))
            }
            MenuItem {
                //% "Statistics"
                text: qsTrId("id-statistics")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("StatisticsPage.qml"))
            }
            MenuItem {
                //% "New game"
                text: qsTrId("id-new-game")
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("../dialogs/NewGameDialog.qml"), { "difficulty": settings.lastDifficulty })

                    dialog.accepted.connect(function() {
                        reset()
                        Sudoku.difficulty = dialog.difficulty
                        settings.lastDifficulty = dialog.difficulty
                        Sudoku.generate()
                    })
                }
            }
        }

        PushUpMenu {
            visible: Sudoku.gameState >= GameState.Playing
            MenuItem {
                //% "Reset"
                text: qsTrId("id-reset")
                //% "Reset game"
                onClicked: remorse.execute(qsTrId("id-reset-game"), function() { reset() })
            }
        }

        RemorsePopup { id: remorse }

        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                //% "Sudoku board"
                title: qsTrId("id-sudoku-board")
                description: {
                    switch (Sudoku.gameState) {
                    case GameState.Empty:
                        return ''

                    case GameState.Generating:
                        //% "Generating"
                        return qsTrId("id-generating") + "..."

                    case GameState.Ready:
                    case GameState.Pause:
                    case GameState.Playing:
                        //% "%n cell(s) unsolved"
                        return qsTrId("id-cells-unsolved", Sudoku.unsolvedCellCount)

                    case GameState.NotCorrect:
                        //% "There are errors"
                        return qsTrId("id-has-errors")

                    case GameState.Solved:
                        //% "Solved"
                        return qsTrId("id-solved")

                    default:
                        return ""
                    }
                }

                Label {
                    visible: Sudoku.gameState >= GameState.Playing
                    anchors{
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        bottom: parent.bottom
                        bottomMargin: Theme.paddingMedium
                    }
                    color: Theme.highlightColor
                    text: new Date(Sudoku.elapsedTime * 1000).toISOString().substr(11, 8);
                }
            }

            Item {
                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
                height: width

                GameBoard {
                    visible: Sudoku.gameState >= GameState.Ready
                    id: gameBoard
                    anchors.fill: parent


                    opacity: Sudoku.gameState === GameState.Solved ? 0.1 : 1.0
                    Behavior on opacity { FadeAnimator {} }

                    cellSize: Math.floor((width - 2*spacing) / 9)

                    layer.enabled: true
                }

                ResultBoard {
                    visible: Sudoku.gameState === GameState.Solved
                    anchors.fill: parent

                    elapsedTime: Sudoku.elapsedTime
                    hints: Sudoku.hintsCount
                    steps: Sudoku.stepsCount
                    difficulty: Sudoku.difficulty
                }
            }

            Controls {
                visible: Sudoku.gameState >= GameState.Ready
                id: controlsPanel

                x: Theme.horizontalPageMargin
                width: parent.width - 2*x
            }
        }

        ViewPlaceholder {
            enabled: Sudoku.gameState === GameState.Empty
            //% "Want to play?"
            text: qsTrId("id-placeholder-text")
            //% "Pull down to start a new game"
            hintText: qsTrId("id-placeholder-hint")
        }
    }

    Connections {
        target: Sudoku
        onGameStateChanged: if (Sudoku.gameState === GameState.Solved) DB.addGame(Sudoku.difficulty, Sudoku.stepsCount, Sudoku.hintsCount, Sudoku.elapsedTime)
    }

    onVisibleChanged: {
        if (visible && Sudoku.gameState === GameState.Pause) {
            Sudoku.start()
        } else if (!visible && Sudoku.gameState === GameState.Playing){
            Sudoku.stop()
        }
    }

    Component.onCompleted: if (settings.gameStateData.length > 0) Sudoku.fromBase64(settings.gameStateData)

    Component.onDestruction: {
        if ( Sudoku.gameState === GameState.Ready
                || Sudoku.gameState === GameState.Playing
                || Sudoku.gameState === GameState.Pause
                || Sudoku.gameState === GameState.NotCorrect ) {

            settings.gameStateData = Sudoku.toBase64()
        } else {
            settings.gameStateData = ""
        }
    }
}
