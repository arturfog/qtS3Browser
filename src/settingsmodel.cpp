#include "inc/settingsmodel.h"
#include <QTextStream>

// ----------------------------------------------------------------------------
SettingsModel::SettingsModel(QObject *parent) : QObject(parent) {}
// ----------------------------------------------------------------------------
QString SettingsModel::extractKey(const QString& line) {
    if(!line.isEmpty()) {
        const int startIdx = line.indexOf('=');
        if(startIdx > 0) {
            const QString key = line.mid(startIdx + 1).trimmed();
            return key;
        }
    }
    return "Empty";
}
// ----------------------------------------------------------------------------
void SettingsModel::parseCLIConfig(const QString& credentialsFilePath) {
    LogMgr::debug(Q_FUNC_INFO, credentialsFilePath);

    if(credentialsFilePath.isEmpty()) { return; }
    QFile file(credentialsFilePath);
    if(!file.exists()) { return; }
    file.open(QIODevice::ReadOnly);
    if(file.isReadable()) {
        QTextStream in(&file);
        while (!in.atEnd()) {
            QString line = in.readLine();
            if(!line.isEmpty() && line.contains("access_key_id")) {
                settings.setValue("AccessKey", extractKey(line));
            } else if(!line.isEmpty() && line.contains("secret_access_key")) {
                settings.setValue("SecretKey", extractKey(line));
            }
        }
    }
}
// ----------------------------------------------------------------------------
void SettingsModel::readCLIConfig()
{
    LogMgr::debug(Q_FUNC_INFO);
    // credentials sample contents
    //
    // [default]
    // aws_access_key_id = abc
    // aws_secret_access_key = 1234
    //
    static const QString winDefaultLocation("%UserProfile%\\.aws\\credentials");
    static const QString nixDefaultLocation(fsm.getHomePath() + "/.aws/credentials");
    // don't overwrite custom access/secret key set in app with those set in awscli
    if(settings.contains("AccessKey") && settings.contains("SecretKey")) {
        return;
    }
    QString os(QSysInfo::productType());
    if(os == "windows") {
         // Windows location is "%UserProfile%\.aws"
        parseCLIConfig(winDefaultLocation);
    } else {
        // MacOS/Linux/BSD location is $HOME/.aws
        parseCLIConfig(nixDefaultLocation);
    }
}
