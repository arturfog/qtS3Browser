CONAN_INCLUDEPATH += "/home/artur/.conan/data/aws-sdk-cpp/1.4.64/arturfog/release/package/518ef2ceb85f558a95fad2fd7bcb16c0a347e4ae/include"
CONAN_LIBS += -laws-cpp-sdk-s3 -laws-cpp-sdk-transfer -laws-cpp-sdk-core
CONAN_LIBDIRS += -L"/home/artur/.conan/data/aws-sdk-cpp/1.4.64/arturfog/release/package/518ef2ceb85f558a95fad2fd7bcb16c0a347e4ae/lib64"
CONAN_BINDIRS += 
CONAN_RESDIRS += 
CONAN_BUILDDIRS += "/home/artur/.conan/data/aws-sdk-cpp/1.4.64/arturfog/release/package/518ef2ceb85f558a95fad2fd7bcb16c0a347e4ae/"
CONAN_DEFINES += 
CONAN_QMAKE_CXXFLAGS += 
CONAN_QMAKE_CFLAGS += 
CONAN_QMAKE_LFLAGS += 
CONAN_QMAKE_LFLAGS += 

CONAN_INCLUDEPATH_AWS-SDK-CPP += "/home/artur/.conan/data/aws-sdk-cpp/1.4.64/arturfog/release/package/518ef2ceb85f558a95fad2fd7bcb16c0a347e4ae/include"
CONAN_LIBS_AWS-SDK-CPP += -laws-cpp-sdk-s3 -laws-cpp-sdk-transfer -laws-cpp-sdk-core
CONAN_LIBDIRS_AWS-SDK-CPP += 
CONAN_BINDIRS_AWS-SDK-CPP += 
CONAN_RESDIRS_AWS-SDK-CPP += 
CONAN_BUILDDIRS_AWS-SDK-CPP += "/home/artur/.conan/data/aws-sdk-cpp/1.4.64/arturfog/release/package/518ef2ceb85f558a95fad2fd7bcb16c0a347e4ae/"
CONAN_DEFINES_AWS-SDK-CPP += 
CONAN_QMAKE_CXXFLAGS_AWS-SDK-CPP += 
CONAN_QMAKE_CFLAGS_AWS-SDK-CPP += 
CONAN_QMAKE_LFLAGS_AWS-SDK-CPP += 
CONAN_QMAKE_LFLAGS_AWS-SDK-CPP += 
CONAN_AWS-SDK-CPP_ROOT = "/home/artur/.conan/data/aws-sdk-cpp/1.4.64/arturfog/release/package/518ef2ceb85f558a95fad2fd7bcb16c0a347e4ae"

CONFIG(conan_basic_setup) {
    INCLUDEPATH += $$CONAN_INCLUDEPATH
    LIBS += $$CONAN_LIBS
    LIBS += $$CONAN_LIBDIRS
    BINDIRS += $$CONAN_BINDIRS
    DEFINES += $$CONAN_DEFINES
    CONFIG(release, debug|release) {
        message("Release config")
        INCLUDEPATH += $$CONAN_INCLUDEPATH_RELEASE
        LIBS += $$CONAN_LIBS_RELEASE
        LIBS += $$CONAN_LIBDIRS_RELEASE
        BINDIRS += $$CONAN_BINDIRS_RELEASE
        DEFINES += $$CONAN_DEFINES_RELEASE
    } else {
        message("Debug config")
        INCLUDEPATH += $$CONAN_INCLUDEPATH_DEBUG
        LIBS += $$CONAN_LIBS_DEBUG
        LIBS += $$CONAN_LIBDIRS_DEBUG
        BINDIRS += $$CONAN_BINDIRS_DEBUG
        DEFINES += $$CONAN_DEFINES_DEBUG
    }
    QMAKE_CXXFLAGS += $$CONAN_QMAKE_CXXFLAGS
    QMAKE_CFLAGS += $$CONAN_QMAKE_CFLAGS
    QMAKE_LFLAGS += $$CONAN_QMAKE_LFLAGS
    QMAKE_CXXFLAGS_DEBUG += $$CONAN_QMAKE_CXXFLAGS_DEBUG
    QMAKE_CFLAGS_DEBUG += $$CONAN_QMAKE_CFLAGS_DEBUG
    QMAKE_LFLAGS_DEBUG += $$CONAN_QMAKE_LFLAGS_DEBUG
    QMAKE_CXXFLAGS_RELEASE += $$CONAN_QMAKE_CXXFLAGS_RELEASE
    QMAKE_CFLAGS_RELEASE += $$CONAN_QMAKE_CFLAGS_RELEASE
    QMAKE_LFLAGS_RELEASE += $$CONAN_QMAKE_LFLAGS_RELEASE
}
