#ifndef SETTINGSMODEL_H
#define SETTINGSMODEL_H

#include <QObject>
#include <QSettings>
#include "inc/logmgr.h"

class SettingsModel : public QObject
{
    Q_OBJECT
private:
    QSettings settings;
public:
    explicit SettingsModel(QObject *parent = nullptr);

    // --------------------------------------------------------------------------
    Q_INVOKABLE int getRegionIdxQML() {
        LogMgr::debug(Q_FUNC_INFO);
        if(settings.contains("RegionIdx")) {
            return settings.value("RegionIdx").toInt();
        }
        return 0;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getTimeoutIdxQML() {
        LogMgr::debug(Q_FUNC_INFO);
        if(settings.contains("TimeoutIdx")) {
            return settings.value("TimeoutIdx").toInt();
        }
        return 0;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getAccesKeyQML() { return settings.value("AccessKey").toString();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getSecretKeyQML() { return settings.value("SecretKey").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getStartPathQML() { return settings.value("StartPath", "s3://").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getEndpointQML() { return settings.value("Endpoint").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getLogsDirQML() { return settings.value("LogsDir").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool getLogsEnabledQML() { return settings.value("LogsEnabled").toBool(); }
};

#endif // SETTINGSMODEL_H
