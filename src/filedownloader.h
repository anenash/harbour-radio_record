#ifndef FILEDOWNLOADER_H
#define FILEDOWNLOADER_H

#include <QObject>
#include <QByteArray>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>

#include <QDebug>

class FileDownloader : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString m_fileUrl WRITE setFileUrl READ fileUrl NOTIFY fileUrlChanged)
public:
    explicit FileDownloader(QObject *parent = 0);
    virtual ~FileDownloader();
    QByteArray downloadedData() const;
    void setFileUrl(const QString &fileUrl);
    QString fileUrl() const;


signals:
    void downloaded();
    void newLoad(QUrl fileUrl);
    void fileUrlChanged();

private slots:
    void startLoad(QUrl fileUrl);
    void fileDownloaded(QNetworkReply* pReply);
    void writeFile(QByteArray data) const;

private:
    QString m_fileUrl;
    QString m_fileName;
    QNetworkAccessManager m_WebCtrl;
    QByteArray m_DownloadedData;
    QByteArray m_defaultHomePath;
};

#endif // FILEDOWNLOADER_H
