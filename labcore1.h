#ifndef LABCORE1_H
#define LABCORE1_H

#include <QObject>
#include <QRunnable>

class LabCore1;

class RestoreTask : public QObject, public QRunnable {
    Q_OBJECT
    LabCore1 *core;
    QString mode;
    QString targetHash;
    bool displayProgress;

public:
    RestoreTask(LabCore1 *core, QString mode, QString targetHash, bool displayProgress)
        : core(core), mode(mode), targetHash(targetHash), displayProgress(displayProgress) {}
    void run() override;

signals:
    void restored(QString key, int ms, QString mode);
};

class LabCore1 : public QObject {
    Q_OBJECT
    friend RestoreTask;
    const float progressStep = 0.005;

public:
    explicit LabCore1(QObject *parent = nullptr);
    Q_INVOKABLE QString hash(QString mode, QString key);
    Q_INVOKABLE void restore(QString mode, QString tasrgetHash);

private slots:
    void calcGraphApprox(QString key, int ms, QString mode);

public slots:
    void calcGraph(QString mode);

signals:
    void progressChanged(float progress);
    void keyFound(QString key, int ms);
    void graphCalced(QString mode, QList<int> ys);
};

#endif // LABCORE1_H
