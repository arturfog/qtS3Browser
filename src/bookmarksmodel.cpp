#include "inc/bookmarksmodel.h"
#include "inc/logmgr.h"

#include <QFile>
#include <QDataStream>

// --------------------------------------------------------------------------
BookmarksModel::BookmarksModel(QObject *parent) : QObject(parent), bookmarks()
{
    loadBookmarks();
}
// --------------------------------------------------------------------------
void BookmarksModel::addBookmark(const QString &name, const QString &path)
{
    LogMgr::debug(Q_FUNC_INFO, name);

    if(!name.isEmpty() && !path.isEmpty())
    {
        if(!bookmarks.contains(name)) {
            bookmarks[name] = path;
            saveBookmarks(bookmarks);
        }
    }
}
// --------------------------------------------------------------------------
void BookmarksModel::removeBookmark(const QString& name)
{
    LogMgr::debug(Q_FUNC_INFO, name);

    if(!name.isEmpty())
    {
        if(bookmarks.contains(name)) {
            bookmarks.remove(name);
            saveBookmarks(bookmarks);
        }
    }
}
// --------------------------------------------------------------------------
void BookmarksModel::saveBookmarks(QMap<QString, QString> &bookmarks)
{
    LogMgr::debug(Q_FUNC_INFO);

    QFile file("bookmarks.dat");
    file.open(QIODevice::WriteOnly);
    QDataStream out(&file);
    out << bookmarks;
    file.close();
}
// --------------------------------------------------------------------------
void BookmarksModel::loadBookmarks()
{
    LogMgr::debug(Q_FUNC_INFO);

    QFile file("bookmarks.dat");
    if(file.exists()) {
        file.open(QIODevice::ReadOnly);
        QDataStream in(&file);
        in >> bookmarks;
    }
}
