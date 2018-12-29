#include "inc/filetransfersmodel.h"

QMap<QString, QList<unsigned long>> FileTransfersModel::transfersProgress;

FileTransfersModel::FileTransfersModel(QObject *parent) : QObject(parent) {}
