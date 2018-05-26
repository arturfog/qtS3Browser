#include "iconprovider.h"

IconProvider::IconProvider():QQuickImageProvider(QQuickImageProvider::Pixmap)
{ }
QPixmap IconProvider::requestPixmap(const QString &id, QSize *size, const QSize &requestedSize)
{
    int width = requestedSize.width() > 0 ? requestedSize.width() : 64;
    int height = width;
    if (size) *size = QSize(width, height);
    if (QFileInfo(id).isDir()) return m_provider.icon(QFileIconProvider::Folder).pixmap(width,height);
    else  {
        QMimeType mime = m_mimeDB.mimeTypeForFile(id);
        if (QIcon::hasThemeIcon(mime.iconName())) return QIcon::fromTheme(mime.iconName()).pixmap(width,height);
        return m_provider.icon(QFileIconProvider::File).pixmap(width,height);
    }
}
