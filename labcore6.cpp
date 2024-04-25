#include "labcore6.h"
#include <QCryptographicHash>
#include <Qca-qt6/QtCrypto/QtCrypto>

ChainNode::ChainNode(QString note, QByteArray prevHash) {
    char zeroChar = 0;
    this->nonce = QByteArray::fromRawData(&zeroChar, 1);
    this->note = note.toUtf8();
    this->prevHash = prevHash;
    recalcHash();
}

void ChainNode::recalcHash() {
    QByteArray head(nonce);
    head.append(note);
    head.append(prevHash);
    hash = QCryptographicHash::hash(head, QCryptographicHash::Algorithm::Md5);
}

bool ChainNode::validate(int targetPrefixLength) {
    for (int i = 0; i < targetPrefixLength; ++i) {
        int byteIndex = i / 2;
        int shift = 4 - (i & 1) * 4;
        if (hash[byteIndex] >> shift & 0xf) return false;
    }
    return true;
}

ChainNode& ChainNode::operator++() {
    for (int i = nonce.size() - 1; i >= 0; --i) {
        if (static_cast<unsigned char>(nonce[i]) < 255) {
            ++nonce[i];
            return *this;
        }
        else {
            nonce[i] = 0;
        }
    }
    nonce.prepend('\1');
    return *this;
}

ChainNodeWrapper::ChainNodeWrapper(QString nonce, QString note, QString prevHash, QString hash) :
    nonce(nonce),
    note(note),
    prevHash(prevHash),
    hash(hash) {}

ChainNodeWrapper::ChainNodeWrapper(ChainNode chainNode) :
    nonce(QCA::arrayToHex(chainNode.nonce)),
    note(QString::fromUtf8(chainNode.note)),
    prevHash(QCA::arrayToHex(chainNode.prevHash)),
    hash(QCA::arrayToHex(chainNode.hash)) {
    // qDebug() << nonce << '\n' << note << '\n' << prevHash << '\n' << hash;
}

Miner::Miner(QObject* parent) : QObject(parent) {}

void Miner::mine(QString prevHashStr, QString note, int targetPrefixLength) {
    QByteArray prevHash = QCA::hexToArray(prevHashStr);
    ChainNode node(note, prevHash);
    while (!node.validate(targetPrefixLength)) {
        (++node).recalcHash();
    }
    emit mined(ChainNodeWrapper(node));
}

LabCore6::LabCore6(QObject *parent) : QObject{parent} {
    miner.moveToThread(&minerThread);
    connect(this, &LabCore6::mine, &miner, &Miner::mine);
    connect(&miner, &Miner::mined, this, &LabCore6::mined);
    minerThread.start();
}

LabCore6::~LabCore6() {
    minerThread.quit();
    minerThread.wait();
}
