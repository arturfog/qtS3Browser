#include "inc/filetransfersmodel.h"

QMap<QString, QList<unsigned long>> FileTransfersModel::transfersProgress;
std::mutex FileTransfersModel::mut;
// --------------------------------------------------------------------------
FileTransfersModel::FileTransfersModel(QObject *parent) : QObject(parent) {}
