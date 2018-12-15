TEMPLATE = app
QT += quick widgets qml
CONFIG += c++11
TARGET = s3browser
# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += src/main.cpp \
    src/s3model.cpp \
    src/s3client.cpp \
    src/iconprovider.cpp \
    src/filesystemmodel.cpp \
    src/logmgr.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creators code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

unix {
  desktop.path = /usr/share/applications
  desktop.files += desktop-file/s3browser.desktop

  icon.path = /usr/share/icons
  icon.files += desktop-file/s3browser.png
}

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target icon desktop

# INCLUDEPATH += $$PWD/inc
# DEPENDPATH += $$PWD/inc

HEADERS += \
    inc/s3model.h \
    inc/s3client.h \
    inc/iconprovider.h \
    inc/filesystemmodel.h \
    inc/logmgr.h


LIBS += -laws-cpp-sdk-s3 -laws-cpp-sdk-transfer -laws-cpp-sdk-core

macx {
 LIBS += -L"$$PWD/build/."
}

unix {
  LIBS += -L"$$(HOME)/.local/usr/local/lib"
  INCLUDEPATH += "$$(HOME)/.local/usr/local/include"
}

win32 {
  LIBS += -L"$$PWD/../aws"
  INCLUDEPATH += "$$PWD/../aws"
}
