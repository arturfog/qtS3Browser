#ifndef ICONPROVIDER_H
#define ICONPROVIDER_H


// source: http://www.spaziocurvo.com/2015/09/simple-qml-file-browser/

#include <QQuickImageProvider>
#include <QFileIconProvider>
#include <QMimeDatabase>

class IconProvider : public QQuickImageProvider
{
public:
    IconProvider();
    QPixmap requestPixmap(const QString &id, QSize *size, const QSize &requestedSize);
protected:
    QFileIconProvider   m_provider;
    QMimeDatabase       m_mimeDB;
};

#endif // ICONPROVIDER_H
