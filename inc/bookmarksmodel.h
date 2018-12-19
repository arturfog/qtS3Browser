#ifndef BOOKMARKSMODEL_H
#define BOOKMARKSMODEL_H

#include <QObject>
#include <QMap>
class BookmarksModel : public QObject
{
    Q_OBJECT
public:
    explicit BookmarksModel(QObject *parent = nullptr);
    // --------------------------------------------------------------------------
    Q_INVOKABLE void addBookmarkQML(const QString &name, const QString &path) { addBookmark(name, path); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE bool hasBookmarkQML(const QString &name) { return bookmarks.contains(name); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE void removeBookmarkQML(const QString &name) {removeBookmark(name);}
    // --------------------------------------------------------------------------
    Q_INVOKABLE int getBookmarksNumQML() {return bookmarks.size();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getBookmarksKeysQML() {return bookmarks.keys();}
    // --------------------------------------------------------------------------
    Q_INVOKABLE QList<QString> getBookmarksLinksQML() { return bookmarks.values(); }
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
private:
    QMap<QString, QString> bookmarks;
};

#endif // BOOKMARKSMODEL_H
