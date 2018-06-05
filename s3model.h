#ifndef S3MODEL_H
#define S3MODEL_H

#include <QList>
#include <QVariant>
#include <QAbstractListModel>
#include <QStringList>

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
    enum AnimalRoles {
        NameRole = Qt::UserRole + 1,
        PathRole
    };

    Q_INVOKABLE QString getS3Path() const { return s3Path(); }
    Q_INVOKABLE void getBuckets() const { getBuckets(); }
    Q_INVOKABLE void goBack() const { goBack(); }
    Q_INVOKABLE void getObjects(const QString &text) { getObjects(text.toStdString()); }
    Q_INVOKABLE void createBucket(const QString &bucket) { createBucket(bucket.toStdString()); }
    Q_INVOKABLE void createFolder(const QString &folder) { createFolder(folder.toStdString()); }
    Q_INVOKABLE void refresh() const { refresh(); }
    Q_INVOKABLE void remove(const int idx) {
        if (idx < m_s3items.count()) {
            if(getCurrentPathDepth() <= 1) {
                removeBucket(m_s3items.at(idx).fileName().toStdString());
            } else {
                removeObject(m_s3items.at(idx).fileName().toStdString());
            }

            refresh();
        }
    }

    S3Model(QObject *parent = 0);

    void addS3Item(const S3Item &item);

    void clearItems();

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QString s3Path() const;

    void goTo(const QString &path);

    void goBack();

    QString getCurrentBucket() const;

    QString getPathWithoutBucket() const;

    inline int getCurrentPathDepth() const { return m_s3Path.count(); }

    void getBuckets();

    void refresh();

    void createBucket(const std::string &bucket);

    void createFolder(const std::string &folder);

    void removeBucket(const std::string &bucket);

    void removeObject(const std::string &key);

    void getObjects(const std::string &item, bool refresh = false);

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;
    S3Client s3;
private:
    QList<S3Item> m_s3items;
    QStringList m_s3Path;
};

#endif // S3MODEL_H
