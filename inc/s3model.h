/*
# Copyright (C) 2018  Artur Fogiel
# This file is part of qtS3Browser.
#
# qtS3Browser is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# qtS3Browser is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with qtS3Browser.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef S3MODEL_H
#define S3MODEL_H

#include <QList>
#include <QVariant>
#include <QAbstractListModel>
#include <QStringList>
#include <QSettings>
#include <QDebug>
#include "s3client.h"

class S3Item
{
public:
    S3Item(const QString &name, const QString &path);

    QString filePath() const;
    QString fileName() const;

private:
    QString m_name;
    QString m_path;
};

class S3Model : public QAbstractListModel
{
    Q_OBJECT
public:
    enum S3Roles {
        NameRole = Qt::UserRole + 1,
        PathRole
    };

    Q_SIGNAL void addItemSignal(const QString& item, const QString& path);
    // --------------------------------------------------------------------------
    Q_SLOT void addItemSlot(const QString& item, const QString& path) {
        setConnectedQML(true);
        if(!item.isEmpty()) {
            addS3Item(S3Item(item, path));
        } else {
            if(getCurrentPathDepthQML() <= 0) {
                emit noBucketsSignal();
            }
        }
    }
    // --------------------------------------------------------------------------
    Q_SIGNAL void showErrorSignal(const QString& msg);
    // --------------------------------------------------------------------------
    Q_SIGNAL void setProgressSignal(const QVariant current, const QVariant total);
    // --------------------------------------------------------------------------
    Q_SIGNAL void noBucketsSignal();
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool isConnectedQML() const { return isConnected; }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool isTransferring() const { return s3.isTransferring(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void setConnectedQML(const bool state) { isConnected = state; }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getS3PathQML() const { return s3Path(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getItemsCountQML() const { return m_s3items.count(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void getBucketsQML() { getBuckets(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void setFileBrowserPath(const QString& path);
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool canDownload() const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getFileBrowserPath() const;
    // --------------------------------------------------------------------------
    Q_INVOKABLE void goBackQML() { goBack(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void gotoQML(const QString &path);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void getObjectsQML(const QString &text) { getObjects(text.toStdString()); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void createBucketQML(const QString &bucket) { createBucket(bucket.toStdString()); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool createFolderQML(const QString &folder);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void uploadFileQML(const QString &file) { upload(file, false); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void uploadDirQML(const QString &file) { upload(file, true); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void downloadQML(const int idx);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void refreshQML() { refresh(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getCurrentPathDepthQML() {
        return getCurrentPathDepth(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeQML(const int idx);
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getObjectSizeQML(const QString& name) {
        auto search = s3.objectInfoVec.find(name.toStdString().c_str());
        if (search != s3.objectInfoVec.end()) {
            return QString::number(s3.objectInfoVec.at(name.toStdString().c_str()).size);
        } else {
            return "0";
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void clearItemsQML() {
        clearItems();
        m_s3Path.clear();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getAccesKeyQML() {return getAccessKey();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getSecretKeyQML() {return getSecretKey();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getStartPathQML() {return getStartPath();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE void saveSettingsQML(const QString& startPath,
                                     const QString& accessKey,
                                     const QString& secretKey,
                                     const int regionIdx,
                                     const QString& region,
                                     const int timeoutIdx,
                                     const QString& timeout,
                                     const QString& endpoint) {
        settings.setValue("StartPath", startPath);
        settings.setValue("AccessKey", accessKey);
        settings.setValue("SecretKey", secretKey);
        settings.setValue("RegionIdx", regionIdx);
        settings.setValue("Region", region);
        settings.setValue("Endpoint", endpoint);
        settings.setValue("TimeoutIdx", timeoutIdx);
        settings.setValue("Timeout", timeout);
        settings.sync();

        s3.reloadCredentials();
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getRegionIdxQML() {
        if(settings.contains("RegionIdx")) {
            return settings.value("RegionIdx").toInt();
        }
        return 0;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getTimeoutIdxQML() {
        if(settings.contains("TimeoutIdx")) {
            return settings.value("TimeoutIdx").toInt();
        }
        return 0;
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getEndpointQML() { return settings.value("Endpoint").toString(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void addBookmarkQML(const QString &name, const QString &path) { addBookmark(name, path); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeBookmarkQML(const QString &name) {removeBookmark(name);}
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getBookmarksNumQML() {return bookmarks.size();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getBookmarksKeysQML() {return bookmarks.keys();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getBookmarksLinksQML() { return bookmarks.values(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getCurrentFileQML() {return currentFile;}
    // --------------------------------------------------------------------------
    Q_INVOKABLE void cancelDownloadUploadQML() {cancelDownloadUpload();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getOwnerQML(const QString &name) { return s3.getOwner(name.toStdString().c_str()).c_str(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getEtagQML(const QString &name) { return s3.getETAG(name.toStdString().c_str()).c_str(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getModificationDateQML(const QString &name) { return s3.getModificationDate(name.toStdString().c_str()).c_str(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void search(const QString& txt) {
        if(m_s3itemsBackup.size() == 0) {
            m_s3itemsBackup.append(m_s3items);
        }
        if(m_s3itemsBackup.size() > 0) {
            clearItems();
            for(auto item : m_s3itemsBackup) {
                if(item.fileName().contains(txt)) {
                    emit addItemSignal(item.fileName(), item.filePath());
                }
            }
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void searchReset() {
        if(m_s3itemsBackup.size() > 0) {
            clearItems();

            beginInsertRows(QModelIndex(), 0, m_s3itemsBackup.size() - 1);
            m_s3items.append(m_s3itemsBackup);
            endInsertRows();

            qDebug() << "search reset";

            m_s3itemsBackup.clear();
        }
    }
    // --------------------------------------------------------------------------
    Q_INVOKABLE QString getItemNameQML(const int index) {
        if(index < m_s3items.count()) {
            return m_s3items.at(index).fileName();
        }
        return "";
    }
    /**
     * @brief S3Model
     * @param parent
     */
    S3Model(QObject *parent = nullptr);
    /**
     * @brief addS3Item
     * @param item
     */
    void addS3Item(const S3Item &item);
    /**
     * @brief clearItems
     */
    void clearItems();
    /**
     * @brief rowCount
     * @param parent
     * @return
     */
    int rowCount(const QModelIndex & parent = QModelIndex()) const;
    /**
     * @brief s3Path
     * @return
     */
    QString s3Path() const;
    /**
     * @brief goTo
     * @param path
     */
    void goTo(const QString &path);
    /**
     * @brief goBack
     */
    void goBack();
    /**
     * @brief getCurrentBucket
     * @return
     */
    QString getCurrentBucket() const;
    /**
     * @brief getPathWithoutBucket
     * @return
     */
    QString getPathWithoutBucket() const;
    /**
     * @brief getCurrentPathDepth
     * @return
     */
    inline int getCurrentPathDepth() const { return m_s3Path.count(); }
    /**
     * @brief getBuckets
     */
    void getBuckets();
    /**
     * @brief refresh
     */
    void refresh();
    /**
     * @brief createBucket
     * @param bucket
     */
    void createBucket(const std::string &bucket);
    /**
     * @brief removeBucket
     * @param bucket
     */
    void removeBucket(const std::string &bucket);
    /**
     * @brief removeObject
     * @param key
     */
    void removeObject(const QString &key, bool isDir);
    /**
     * @brief upload
     * @param file
     * @param isDir
     */
    void upload(const QString &file, bool isDir = false);
    /**
     * @brief download
     * @param key
     */
    void download(const QString& key, bool isDir);
    /**
     * @brief cancelDownloadUpload
     */
    inline void cancelDownloadUpload() {
        s3.cancelDownloadUpload();
    }
    /**
     * @brief getObjects
     * @param item
     * @param goBack
     */
    void getObjects(const std::string &item, bool goBack = false);
    /**
     * @brief getObjectInfo
     * @param key
     */
    void getObjectInfo(const QString &key);
    /**
     * @brief addBookmark
     * @param name
     * @param path
     */
    void addBookmark(const QString& name, const QString& path);
    /**
     * @brief removeBookmark
     * @param name
     */
    void removeBookmark(const QString &name);
    /**
     * @brief saveBookmarks
     * @param bookmarks
     */
    void saveBookmarks(QMap<QString, QString> &bookmarks);
    /**
     * @brief loadBookmarks
     */
    void loadBookmarks();

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;
    /**
     * @brief getAccessKey
     * @return
     */
    QString getAccessKey() const;
    /**
     * @brief getSecretKey
     * @return
     */
    QString getSecretKey() const;
    /**
     * @brief getStartPath
     * @return
     */
    QString getStartPath() const;
    /**
     * @brief readCLIConfig
     */
    void readCLIConfig();
protected:
    QHash<int, QByteArray> roleNames() const;
    S3Client s3;
private:
    QSettings settings;
    QString currentFile;
    QList<S3Item> m_s3items;
    QStringList m_s3Path;
    QMap<QString, QString> bookmarks;
    bool isConnected;
    QString mFileBrowserPath;
    QList<S3Item> m_s3itemsBackup;
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
    static QString extractKey(const QString& line);
};

#endif // S3MODEL_H
