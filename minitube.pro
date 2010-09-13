CONFIG += qt debug
TEMPLATE = app
VERSION = 1.1
DEFINES += APP_VERSION="$$VERSION"
INCLUDEPATH += /usr/include/phonon

# TODO Saner string behaviour
# DEFINES += QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII QT_STRICT_ITERATORS
TARGET = minitube
QT += network \
    xml \
    phonon

include(src/qtsingleapplication/qtsingleapplication.pri)

HEADERS += src/MainWindow.h \
    src/SearchView.h \
    src/MediaView.h \
    src/AboutView.h \
    src/youtubesearch.h \
    src/youtubeinforeader.h\
    src/video.h \
    src/youtubestreamreader.h \
    src/View.h \
    src/searchlineedit.h \
    src/urllineedit.h \
    src/spacer.h \
    src/constants.h \
    src/iconloader/qticonloader.h \
    src/faderwidget/FaderWidget.h \
    src/ListModel.h \
    src/playlist/PrettyItemDelegate.h \
    src/networkaccess.h \
    src/videomimedata.h \
    src/global.h \
    src/updatechecker.h \
    src/playlistwidget.h \
    src/searchparams.h \
    src/minisplitter.h \
    src/loadingwidget.h \
    src/videoareawidget.h \
    src/googlesuggest.h \
    src/videowidget.h \
    src/flickcharm.h \
    src/videodefinition.h \
    src/fontutils.h \
    src/thlibrary/thblackbar.h \
    src/globalshortcuts.h \
    src/globalshortcutbackend.h
SOURCES += src/main.cpp \
    src/MainWindow.cpp \
    src/SearchView.cpp \
    src/MediaView.cpp \
    src/AboutView.cpp \
    src/youtubesearch.cpp \
    src/youtubeinforeader.cpp\
    src/youtubestreamreader.cpp \
    src/searchlineedit.cpp \
    src/urllineedit.cpp \
    src/spacer.cpp \
    src/video.cpp \
    src/iconloader/qticonloader.cpp \
    src/faderwidget/FaderWidget.cpp \
    src/ListModel.cpp \
    src/playlist/PrettyItemDelegate.cpp \
    src/videomimedata.cpp \
    src/updatechecker.cpp \
    src/networkaccess.cpp \
    src/playlistwidget.cpp \
    src/searchparams.cpp \
    src/minisplitter.cpp \
    src/loadingwidget.cpp \
    src/videoareawidget.cpp \
    src/googlesuggest.cpp \
    src/videowidget.cpp \
    src/flickcharm.cpp \
    src/videodefinition.cpp \
    src/constants.cpp \
    src/fontutils.cpp \
    src/thlibrary/thblackbar.cpp \
    src/globalshortcuts.cpp \
    src/globalshortcutbackend.cpp
RESOURCES += resources.qrc
DESTDIR = build/target/
OBJECTS_DIR = build/obj/
MOC_DIR = build/moc/
RCC_DIR = build/rcc/

# Tell Qt Linguist that we use UTF-8 strings in our sources
CODECFORTR = UTF-8
CODECFORSRC = UTF-8
include(locale/locale.pri)

# deploy
DISTFILES += CHANGES \
    COPYING

unix:!mac {
    QT += dbus

    HEADERS += src/gnomeglobalshortcutbackend.h
    SOURCES += src/gnomeglobalshortcutbackend.cpp

    isEmpty(PREFIX):PREFIX = /usr
    BINDIR = $$PREFIX/bin
    INSTALLS += target
    target.path = $$BINDIR
    DATADIR = $$PREFIX/share
    PKGDATADIR = $$DATADIR/minitube
    DEFINES += DATADIR=\\\"$$DATADIR\\\" \
        PKGDATADIR=\\\"$$PKGDATADIR\\\"
    INSTALLS += translations \
        desktop \
        iconsvg \
        icon16 \
        icon22 \
        icon32 \
        icon48 \
        icon64 \
        icon128 \
        icon256 \
        icon512
    translations.path = $$PKGDATADIR
    translations.files += $$DESTDIR/locale
    desktop.path = $$DATADIR/applications
    desktop.files += minitube.desktop
    iconsvg.path = $$DATADIR/icons/hicolor/scalable/apps
    iconsvg.files += data/minitube.svg
    icon16.path = $$DATADIR/icons/hicolor/16x16/apps
    icon16.files += data/16x16/minitube.png
    icon22.path = $$DATADIR/icons/hicolor/22x22/apps
    icon22.files += data/22x22/minitube.png
    icon32.path = $$DATADIR/icons/hicolor/32x32/apps
    icon32.files += data/32x32/minitube.png
    icon48.path = $$DATADIR/icons/hicolor/48x48/apps
    icon48.files += data/48x48/minitube.png
    icon64.path = $$DATADIR/icons/hicolor/64x64/apps
    icon64.files += data/64x64/minitube.png
    icon128.path = $$DATADIR/icons/hicolor/128x128/apps
    icon128.files += data/128x128/minitube.png
    icon256.path = $$DATADIR/icons/hicolor/256x256/apps
    icon256.files += data/256x256/minitube.png
    icon256.path = $$DATADIR/icons/hicolor/512x512/apps
    icon256.files += data/256x256/minitube.png
    icon512.path = $$DATADIR/icons/hicolor/512x512/apps
    icon512.files += data/512x512/minitube.png
}
mac|win32:include(local/local.pri)
