#ifndef LABCORE4_H
#define LABCORE4_H

#include <QMap>
#include <QObject>

// for cert in $(ls -h /etc/ssl/certs); do openssl verify /etc/ssl/certs/$cert; done

class LabCore4 : public QObject
{
    Q_OBJECT
    QMap<QString, QString> certsMap;
public:
    explicit LabCore4(QObject *parent = nullptr);
    Q_INVOKABLE QList<QString> getAll();
    Q_INVOKABLE QString getOne(QString certName);
    Q_INVOKABLE bool verify(QString certName);

signals:
};

#endif // LABCORE4_H
