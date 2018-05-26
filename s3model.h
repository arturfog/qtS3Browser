#ifndef S3MODEL_H
#define S3MODEL_H

#include <QList>
#include <QVariant>
#include <QAbstractListModel>
#include <QStringList>

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
        PathRole,
        S3PathRole
    };

    Q_INVOKABLE QString getS3Path() const {
            return s3Path();
        }

    S3Model(QObject *parent = 0);

    void addS3Item(const S3Item &animal);

    int rowCount(const QModelIndex & parent = QModelIndex()) const;

    QString s3Path() const;

    QVariant data(const QModelIndex & index, int role = Qt::DisplayRole) const;

protected:
    QHash<int, QByteArray> roleNames() const;
private:
    QList<S3Item> m_s3items;
};

#endif // S3MODEL_H
