#ifndef SETTINGSMODEL_H
#define SETTINGSMODEL_H

#include <QObject>
#include <QSettings>

#include "inc/logmgr.h"
#include "inc/filesystemmodel.h"

class SettingsModel : public QObject
{
    Q_OBJECT
private:
    QSettings settings;
    FilesystemModel fsm;
    /**
     * @brief parseCLIConfig
     * @param credentialsFilePath
     */
    void parseCLIConfig(const QString &credentialsFilePath);
    /**
     * @brief extractKey
     * @param line
     * @return
     */
    static const QString extractKey(const QString& line);
    //
    static const constexpr int MAX_TIMEOUT_IDX = 6;
    static const constexpr int MAX_REGION_IDX = 5;
public:
    explicit SettingsModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getRegionIdxQML() const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getTimeoutIdxQML() const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QString getAccesKeyQML() const { return settings.value("AccessKey").toString();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QString getSecretKeyQML() const { return settings.value("SecretKey").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QString getStartPathQML() const { return settings.value("StartPath", "s3://").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QString getEndpointQML() const { return settings.value("Endpoint").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QString getLogsDirQML() const { return settings.value("LogsDir").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline bool getLogsEnabledQML() const { return settings.value("LogsEnabled").toBool(); }
    /**
     * @brief readCLIConfig
     */
    void readCLIConfig();
};

#endif // SETTINGSMODEL_H
