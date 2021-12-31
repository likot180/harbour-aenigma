import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0
import "pages"

import org.nubecula.aenigma 1.0

import "."

ApplicationWindow {
    id: app

    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-aenigma"
        synchronous: true

        property bool autoCleanupNotes: false
        property bool autoNotes: false
        property bool highlighting: true
        property int highlightMode: HighlightMode.Complete
        property int lastDifficulty: Difficulty.Medium
        property bool preventDisplayBlanking: true
        property int style: Styles.Default

        onAutoCleanupNotesChanged: Sudoku.autoCleanupNotes = autoCleanupNotes
        onAutoNotesChanged: Sudoku.autoNotes = autoNotes
        onStyleChanged: BoardStyles.setStyle(style)
    }

    initialPage: Component { GamePage { } }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
