#include "labcore2.h"
#include <Qca-qt6/QtCrypto/QtCrypto>
#include <QDebug>

LabCore2::LabCore2(QObject *parent)
    : QObject{parent}, qRandomGenerator()
{}

QByteArray LabCore2::addPadding(QByteArray text, QString mode) {
    int blockSize = mode.contains("AES") ? 16 : 8;
    int newSize = (text.size() / blockSize + 1) * blockSize;
    int tailSize = newSize - text.size();
    if (mode == "PKCS5") {
        return text.append(tailSize, tailSize);
    }
    if (mode == "1&0s") {
        return text.append(0x80).append(tailSize - 1, 0);
    }
    if (mode == "ANSIX") {
        return text.append(tailSize - 1, 0).append(tailSize);
    }
    if (mode == "W3C") {
        QRandomGenerator rand;
        for (int i = 0; i < tailSize - 1; ++i) {
            text.append(rand.bounded(0x100));
        }
        return text.append(tailSize);
    }
    qWarning() << "INCORRECT PADDING";
    return text;
}

QByteArray LabCore2::removePadding(QByteArray text, QString mode) {
    if (mode == "PKCS5" || mode == "ANSIX" || mode == "W3C") {
        return text.chopped(text[text.size() - 1]);
    }
    if (mode == "1&0s") {
        int i = text.size() - 1;
        while (text[i] != char(0x80)) { --i; }
        return text.chopped(text.size() - i);
    }
    qWarning() << "INCORRECT PADDING";
    return text;
}

QString LabCore2::process(QString typeStr, QString modeStr, QString paddingModeStr, QString initVectorStr, QString keyStr, QString textStr, QString directionStr) {
    QString type;
    if (typeStr == "3DES") type = "tripledes";
    else if (typeStr == "AES128") type = "aes128";
    else {
        qWarning() << "INCORRECT TYPE";
        return "";
    }
    QCA::Cipher::Mode mode;
    if (modeStr == "CBC") mode = QCA::Cipher::CBC;
    else if (modeStr == "ECB") mode = QCA::Cipher::ECB;
    else if (modeStr == "OFB") mode = QCA::Cipher::OFB;
    else if (modeStr == "CFB") mode = QCA::Cipher::CFB;
    else {
        qWarning() << "INCORRECT MODE";
        return "";
    }
    QCA::Cipher::Padding paddingMode = QCA::Cipher::NoPadding;
    QCA::InitializationVector initVector(QCA::hexToArray(initVectorStr));
    QCA::SymmetricKey key(QCA::hexToArray(keyStr));
    QCA::Direction direction;
    if (directionStr == "ENCRYPT") direction = QCA::Encode;
    else if (directionStr == "DECRYPT") direction = QCA::Decode;
    else {
        qWarning() << "INCORRECT DIRECTION";
        return "";
    }
    QByteArray text;
    if (!direction) text = addPadding(textStr.toLatin1(), paddingModeStr);
    else text = QCA::hexToArray(textStr);

    QCA::Cipher cipher(type, mode, paddingMode, direction, key, initVector);
    QByteArray result = cipher.process(text).toByteArray();
    if (!direction) return QCA::arrayToHex(result);
    else return QString::fromLatin1(removePadding(result, paddingModeStr));
}

QString LabCore2::genInitVector(QString type) {
    return type.contains("AES") ? genKey(16) : genKey(8);
}

QString LabCore2::genKey(QString type) {
    if (type == "DES") return genKey(8);
    if (type == "3DES") return genKey(16);
    if (type == "AES128") return genKey(16);
    if (type == "AES256") return genKey(32);
    qWarning() << "INCORRECT TYPE";
    return "";
}

QString LabCore2::genKey(int bytes) {
    QByteArray key(bytes, 0);
    for (int i = 0; i < bytes; ++i) {
        key[i] = qRandomGenerator.bounded(0x100);
    }
    return QCA::arrayToHex(key);
}

void we();

QString LabCore2::test() {
    int scenario = 2;
    switch (scenario) {
    case 0:
        we();
        break;

    case 1:
    {
        QString text = "0123456789abcde7";
        QString textEnc = process("3DES", "ECB", "ZEROS", "2020202020202020", "0123456789abcdeffedcba9876543210", text, "ENCRYPT");
        QString textEncDec = process("3DES", "ECB", "ZEROS", "2020202020202020", "0123456789abcdeffedcba9876543210", textEnc, "DECRYPT");
        qDebug() << text << "->" << textEnc << "->" << textEncDec;

        text = "hello";
        textEnc = process("AES128", "CBC", "PKCS7", "1234567812345678", "1234abc1234abc", text, "ENCRYPT");
        textEncDec = process("AES128", "CBC", "PKCS7", "1234567812345678", "1234abc1234abc", textEnc, "DECRYPT");
        qDebug() << text << "->" << textEnc << "->" << textEncDec;

        qDebug() << "7F1D0A77826F8AFF";

        return textEncDec;
    }

    case 2:
        QList<QString> examples { "a0b1c2d3e4", "a0b1c2d3e4f5a6", "a0b1c2d3e4f5a6b7" };
        QList<QString> modes {"PKCS5", "1&0s", "ANSIX", "W3C"};
        for (const QString& mode : modes) {
            qDebug() << "MODE" << mode << ":";
            for (const QString& example : examples) {
                QByteArray exampleMod1 = addPadding(QCA::hexToArray(example), mode);
                QByteArray exampleMod2 = removePadding(exampleMod1, mode);
                qDebug() << example << "->" << QCA::arrayToHex(exampleMod1) << "->" << QCA::arrayToHex(exampleMod2);
            }
            qDebug() << QString(20, '_');
        }
        break;
    }
    return "eww";
}

void we() {
    QCA::SecureArray text = "hello";
    qDebug() << "WE have" << text.data();

    // AES128 testing
    if (!QCA::isSupported("aes128-cbc-pkcs7"))
        printf("AES128-CBC not supported!\n");
    else {
        // Create a random key - you'd probably use one from another
        // source in a real application
        QCA::SymmetricKey key(16);

        // Create a random initialisation vector - you need this
        // value to decrypt the resulting cipher text, but it
        // need not be kept secret (unlike the key).
        QCA::InitializationVector iv(16);

        // create a 128 bit AES cipher object using Cipher Block Chaining (CBC) mode
        QCA::Cipher cipher(QStringLiteral("aes128"),
                           QCA::Cipher::CBC,
                           // use Default padding, which is equivalent to PKCS7 for CBC
                           QCA::Cipher::DefaultPadding,
                           // this object will encrypt
                           QCA::Encode,
                           key,
                           iv);

        // we use the cipher object to encrypt the argument we passed in
        // the result of that is returned - note that if there is less than
        // 16 bytes (1 block), then nothing will be returned - it is buffered
        // update() can be called as many times as required.
        QCA::SecureArray u = cipher.update(text);

        // We need to check if that update() call worked.
        if (!cipher.ok()) {
            printf("Update failed\n");
        }
        // output the results of that stage
        printf("AES128 encryption of %s is [%s]\n", text.data(), qPrintable(QCA::arrayToHex(u.toByteArray())));

        // Because we are using PKCS7 padding, we need to output the final (padded) block
        // Note that we should always call final() even with no padding, to clean up
        QCA::SecureArray f = cipher.final();

        // Check if the final() call worked
        if (!cipher.ok()) {
            printf("Final failed\n");
        }
        qDebug() << "WE have crypted it into" << (u.append(f)).data();

        // and output the resulting block. The ciphertext is the results of update()
        // and the result of final()
        printf("Final block for AES128 encryption is [0x%s]\n", qPrintable(QCA::arrayToHex(f.toByteArray())));

        // re-use the Cipher t decrypt. We need to use the same key and
        // initialisation vector as in the encryption.
        cipher.setup(QCA::Decode, key, iv);

        // Build a single cipher text array. You could also call update() with
        // each block as you receive it, if that is more useful.
        QCA::SecureArray cipherText = u.append(f);

        // take that cipher text, and decrypt it
        QCA::SecureArray plainText = cipher.update(cipherText);

        // check if the update() call worked
        if (!cipher.ok()) {
            printf("Update failed\n");
        }

        // output results
        printf("Decryption using AES128 of [0x%s] is %s\n",
               qPrintable(QCA::arrayToHex(cipherText.toByteArray())),
               plainText.data());

        // Again we need to call final(), to get the last block (with its padding removed)
        plainText.append(cipher.final());
        qDebug() << "WE have decrypted it into" << plainText.data();

        // check if the final() call worked
        if (!cipher.ok()) {
            printf("Final failed\n");
        }

        // output results
        printf("Final decryption block using AES128 is %s\n", plainText.data());
        // instead of update() and final(), you can do the whole thing
        // in one step, using process()
        printf("One step decryption using AES128: %s\n", QCA::SecureArray(cipher.process(cipherText)).data());
    }
}
