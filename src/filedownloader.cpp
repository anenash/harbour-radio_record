#include "filedownloader.h"

#include <QFile>
#include <QFileInfo>

#include <QMimeType>
#include <QMimeDatabase>

FileDownloader::FileDownloader(QObject *parent) :
    QObject(parent)
{

    m_defaultHomePath = qgetenv("HOME");

    connect(
                &m_WebCtrl, SIGNAL (finished(QNetworkReply*)),
                this, SLOT (fileDownloaded(QNetworkReply*))
                );

}

FileDownloader::~FileDownloader() { }

void FileDownloader::startLoad(QUrl fileUrl)
{
    QNetworkRequest request(fileUrl);
    m_WebCtrl.get(request);
}

void FileDownloader::fileDownloaded(QNetworkReply* pReply)
{
//    qDebug() << "Get reply";

    if(pReply->header(QNetworkRequest::ContentLengthHeader).toInt() > 0)
    {
        int contentLength = pReply->header(QNetworkRequest::ContentLengthHeader).toInt();
        qDebug() << "ContentLengthHeader" << contentLength;
    }
    if(pReply->header(QNetworkRequest::ContentTypeHeader).toString().compare("text/plain") != 0)
    {
        QString contentType = pReply->header(QNetworkRequest::ContentTypeHeader).toString();
        qDebug() << "ContentTypeHeader" << contentType;
        m_DownloadedData = pReply->readAll();
        writeFile(m_DownloadedData);
        //emit a signal
        pReply->deleteLater();
        emit downloaded();
    }
    else
    {
        QString contentType = pReply->header(QNetworkRequest::ContentTypeHeader).toString();
        qDebug() << "ContentTypeHeader" << contentType;
        emit downloaded();
    }
//    QList<QByteArray> list = pReply->rawHeaderList();
//    foreach (QByteArray header, list)
//    {
//        QString qsLine = QString(header) + " = " + pReply->rawHeader(header);
//        qDebug() << "Header line" << qsLine;
//    }

}

QByteArray FileDownloader::downloadedData() const
{
    return m_DownloadedData;
}

void FileDownloader::writeFile(QByteArray data) const
{
    QString fileName = m_defaultHomePath + "/Music/" + m_fileName;
//    qDebug() << "Write file" << fileName;
    QFile file(fileName);
    if (!file.open(QIODevice::WriteOnly))
        return;

    file.write(data);
    file.close();
//    qDebug() << "Finish write file" << fileName;
    QMimeDatabase mimedatabase;
    QMimeType mimeType = mimedatabase.mimeTypeForName(fileName);
//    qDebug() << "Get local file type " << mimeType.comment();
}

QString FileDownloader::fileUrl() const
{
    return m_fileUrl;
}

void FileDownloader::setFileUrl(const QString &fileUrl)
{
//    qDebug() << "Set file url " << fileUrl;
    m_fileUrl = fileUrl;
    QUrl url(m_fileUrl);
    QFileInfo fileInfo(url.toString());
    m_fileName = fileInfo.fileName();
//    qDebug() << "Get file name " << m_fileName;
//    QMimeDatabase mimedatabase;
//    QMimeType mimeType = mimedatabase.mimeTypeForUrl(url);
//    qDebug() << "Get file type " << mimeType.comment();
//    qDebug() << "Create url " << url.toEncoded();
    QNetworkRequest request(url);
    m_WebCtrl.get(request);
//    qDebug() << "Send request";
}
