#ifndef GLOBAL_H
#define GLOBAL_H

#include <QtGui>
#include <QStringList>
#include <QNetworkProxy>
#include <QNetworkAccessManager>
#include <QNetworkProxyFactory>
#include <cstdlib>
#include "networkaccess.h"

namespace The {

    static QMap<QString, QAction*> *g_actions = 0;

    QMap<QString, QAction*>* globalActions() {
        if (!g_actions)
            g_actions = new QMap<QString, QAction*>;
        return g_actions;
    }

    static QMap<QString, QMenu*> *g_menus = 0;

    QMap<QString, QMenu*>* globalMenus() {
        if (!g_menus)
            g_menus = new QMap<QString, QMenu*>;
        return g_menus;
    }

    void maybeSetSystemProxy() {

        QNetworkProxyQuery proxyQuery(QUrl("http://www"));
        proxyQuery.setProtocolTag("http");
        QList<QNetworkProxy> proxylist = QNetworkProxyFactory::systemProxyForQuery(proxyQuery);

        for (int i = 0; i < proxylist.count(); i++) {
            QNetworkProxy proxy = proxylist.at(i);

            /*
            qDebug() << i << " type:"<< proxy.type();
            qDebug() << i << " host:" << proxy.hostName();
            qDebug() << i << " port:" << proxy.port();
            qDebug() << i << " user:" << proxy.user();
            qDebug() << i << " pass:" << proxy.password();
            */

            if (!proxy.hostName().isEmpty()) {
                qDebug() << "Using proxy:" << proxy.hostName() << proxy.port();
                QNetworkProxy::setApplicationProxy(proxy);
                return;
            }
        }
    }

    void networkHttpProxySetting() {
        char *http_proxy_env;
        http_proxy_env = std::getenv("http_proxy");
        if (!http_proxy_env) {
            http_proxy_env = std::getenv("HTTP_PROXY");
        }

        if (http_proxy_env) {
            QString proxy_host = "";
            QString proxy_port = "";
            QString proxy_user = "";
            QString proxy_pass = "";
            QString http_proxy = QString(http_proxy_env);
            http_proxy.remove(QRegExp("^http://"));

            // Remove trailing slash, if any
            // Fix by Eduardo Suarez-Santana
            http_proxy.remove(QRegExp("/$"));

            // parse username and password
            if (http_proxy.contains(QChar('@'))) {
                QStringList http_proxy_list = http_proxy.split(QChar('@'));
                QStringList http_proxy_user_pass = http_proxy_list[0].split(QChar(':'));
                if (http_proxy_user_pass.size() > 0) {
                    proxy_user = http_proxy_user_pass[0];
                }
                if (http_proxy_user_pass.size() == 2) {
                    proxy_pass = http_proxy_user_pass[1];
                }
                if (http_proxy_list.size() > 1) {
                    http_proxy = http_proxy_list[1];
                }
            }

            // parse hostname and port
            QStringList http_proxy_list = http_proxy.split(QChar(':'));
            if (http_proxy_list.size() > 0) {
                proxy_host = http_proxy_list[0];
            }
            if (http_proxy_list.size() > 1) {
                proxy_port = http_proxy_list[1];
            }

            /*
            qDebug() << "proxy_host: " << proxy_host;
            qDebug() << "proxy_port: " << proxy_port;
            qDebug() << "proxy_user: " << proxy_user;
            qDebug() << "proxy_pass: " << proxy_pass;
            */

            // set proxy setting
            if (!proxy_host.isEmpty()) {
                QNetworkProxy proxy;
                proxy.setType(QNetworkProxy::HttpProxy);
                proxy.setHostName(proxy_host);
                if (!proxy_port.isEmpty()) {
                    proxy.setPort(proxy_port.toUShort());
                }
                if (!proxy_user.isEmpty()) {
                    proxy.setUser(proxy_user);
                }
                if (!proxy_pass.isEmpty()) {
                    proxy.setPassword(proxy_pass);
                }

                qDebug() << "Using HTTP proxy:" << http_proxy_env;
                QNetworkProxy::setApplicationProxy(proxy);
            }
        }
    }

    static QNetworkAccessManager *nam = 0;

    QNetworkAccessManager* networkAccessManager() {
        if (!nam) {
            networkHttpProxySetting();
            maybeSetSystemProxy();
            nam = new QNetworkAccessManager();

            // A simple disk based cache
            /*
            QNetworkDiskCache *cache = new QNetworkDiskCache();
            QString cacheLocation = QDesktopServices::storageLocation(QDesktopServices::DataLocation);
            qDebug() << cacheLocation;
            cache->setCacheDirectory(cacheLocation);
            nam->setCache(cache);
            */
        }
        return nam;
    }

    static NetworkAccess *g_http = 0;
    NetworkAccess* http() {
        if (!g_http) {
            // qDebug() << "Creating NetworkAccess";
            g_http = new NetworkAccess();
        }
        return g_http;
    }

}

#endif // GLOBAL_H
