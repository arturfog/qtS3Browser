      #LD_LIBRARY_PATH: $LD_LIBRARY_PATH:$SNAP/opt/Qt5.15.0/lib:$SNAP/opt/Qt5.15.0/plugins/platforms
        export QML_IMPORT_PATH=/opt/Qt5.15.0/qml
        export QML2_IMPORT_PATH=/opt/Qt5.15.0/qml
        export QT_PLUGIN_PATH=/opt/Qt5.15.0/plugins
        export QT_QPA_PLATFORM_PLUGIN_PATH=/opt/Qt5.15.0/plugins/platforms
        #QT_XCB_GL_INTEGRATION: none
        export QT_STYLE_OVERRIDE=gtk
        export QT_FONT_DPI=96
        #QT_QPA_PLATFORMTHEME: gtk3
        #QT_XCB_GL_INTEGRATION: xcb_egl

