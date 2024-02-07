#ifndef LABCORE1_H
#define LABCORE1_H

#include <QObject>

class LabCore1 : public QObject
{
    Q_OBJECT
    const float progressStep = 0.005;
    class RestoreTask;
public:
    explicit LabCore1(QObject *parent = nullptr);
    Q_INVOKABLE QString validateKey(QString key);
    Q_INVOKABLE QString validateHash(QString hashType, QString hash);
    Q_INVOKABLE QString hash(QString mode, QString key);
    Q_INVOKABLE void restore(QString mode, QString tasrgetHash);

signals:
    void progressChanged(float progress);
    void keyFound(QString key);

signals:
};

#endif // LABCORE1_H
