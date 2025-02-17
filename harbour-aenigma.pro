# VERSION
VERSION = 0.1.3
DEFINES += APP_VERSION=\\\"$$VERSION\\\"

TARGET = harbour-aenigma
DEFINES += APP_TARGET=\\\"$$TARGET\\\"

CONFIG += sailfishapp c++11

SOURCES += src/harbour-aenigma.cpp \
    src/generator.cpp \
    src/helper.cpp \
    src/sudoku.cpp

DISTFILES += qml/harbour-aenigma.qml \
    qml/Global.qml \
    qml/components/Controls.qml \
    qml/components/GameBlock.qml \
    qml/components/GameBoard.qml \
    qml/components/IconSwitch.qml \
    qml/components/NoteBlock.qml \
    qml/cover/CoverPage.qml \
    qml/dialogs/NewGameDialog.qml \
    qml/pages/GamePage.qml \
    qml/pages/SettingsPage.qml \
    rpm/harbour-aenigma.changes \
    rpm/harbour-aenigma.changes.run.in \
    rpm/harbour-aenigma.spec \
    rpm/harbour-aenigma.yaml \
    translations/*.ts \
    harbour-aenigma.desktop

SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172 512x512

include(translations/translations.pri)

HEADERS += \
    src/enums.h \
    src/generator.h \
    src/global.h \
    src/helper.h \
    src/sudoku.h

RESOURCES += \
    ressources.qrc

images.files = images/*.*
images.path = $$INSTALL_ROOT/usr/share/harbour-aenigma/images

INSTALLS += images
