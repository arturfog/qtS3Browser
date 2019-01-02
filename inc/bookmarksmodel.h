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
    Q_INVOKABLE inline void addBookmarkQML(const QString &name, const QString &path) { addBookmark(name, path); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline bool hasBookmarkQML(const QString &name) const { return bookmarks.contains(name); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline void removeBookmarkQML(const QString &name) { removeBookmark(name); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline int getBookmarksNumQML() const { return bookmarks.size(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QList<QString> getBookmarksKeysQML() const { return bookmarks.keys(); }
    // --------------------------------------------------------------------------
    Q_INVOKABLE inline QList<QString> getBookmarksLinksQML() const { return bookmarks.values(); }
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
