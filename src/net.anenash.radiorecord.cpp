#include <QtQuick>
#include <QGuiApplication>
#include <QQuickView>
#include <QQmlContext>
#include <sailfishapp.h>
#include "filedownloader.h"


int main(int argc, char *argv[])
{
//    QGuiApplication *app = SailfishApp::application(argc, argv);

//    app->setQuitOnLastWindowClosed(true);

//    FileDownloader *downloader = new FileDownloader();
////    SystemImei *imei = new SystemImei();
//    QQuickView *view = SailfishApp::createView();
////    view->rootContext()->setContextProperty("imei", imei);
//    view->rootContext()->setContextProperty("FileDownloader", downloader);
//    view->setSource(SailfishApp::pathTo("/qml/harbour-radiorecord.qml"));
//    view->showFullScreen();

    // SailfishApp::main() will display "qml/template.qml", if you need more
    // control over initialization, you can use:
    //
    //   - SailfishApp::application(int, char *[]) to get the QGuiApplication *
    //   - SailfishApp::createView() to get a new QQuickView * instance
    //   - SailfishApp::pathTo(QString) to get a QUrl to a resource file
    //
    // To display the view, call "show()" (will show fullscreen on device).
//    qmlRegisterType<Network>("harbour.network", 1, 0, "Network");
    qmlRegisterType<FileDownloader>("harbour.radiorecord", 1, 0, "FileDownloader");
    return SailfishApp::main(argc, argv);
//    return app->exec();
}

