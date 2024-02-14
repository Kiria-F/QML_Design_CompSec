#include "labcore2.h"
#include <Qca-qt6/QtCrypto/QtCrypto>
#include <QDebug>

LabCore2::LabCore2(QObject *parent)
    : QObject{parent}
{}

QString LabCore2::process(QString typeStr, QString modeStr, QString paddingModeStr, QString initVectorStr, QString keyStr, QString textStr, QString directionStr) {
    QString type;
    if (typeStr == "3DES") type = "tripledes";
    else if (typeStr == "AES128") type = "aes128";
    else {
        qWarning() << "INCORRECT TYPE";
        return "";
    }
    QCA::Cipher::Mode mode;
    if (modeStr == "ECB") mode = QCA::Cipher::ECB;
    else if (modeStr == "CBC") mode = QCA::Cipher::CBC;
    else {
        qWarning() << "INCORRECT MODE";
        return "";
    }
    QCA::Cipher::Padding paddingMode;
    if (paddingModeStr == "ZEROS") paddingMode = QCA::Cipher::NoPadding;
    else if (paddingModeStr == "PKCS7") paddingMode = QCA::Cipher::PKCS7;
    else if (paddingModeStr == "DEFAULT") paddingMode = QCA::Cipher::DefaultPadding;
    else {
        qWarning() << "INCORRECT PADDING";
        return "";
    }
    QCA::InitializationVector initVector(QCA::hexToArray(initVectorStr));
    QCA::SymmetricKey key(QCA::hexToArray(keyStr));
    QByteArray text = QCA::hexToArray(textStr);
    QCA::Direction direction;
    if (directionStr == "ENCRYPT") direction = QCA::Encode;
    else if (directionStr == "DECRYPT") direction = QCA::Decode;
    else {
        qWarning() << "INCORRECT DIRECTION";
        return "";
    }

    // auto t = QCA::hexToArray(keyStr);
    // qDebug() << keyStr << " -> " << QCA::arrayToHex(t) << " -> " << QCA::arrayToHex(t);
    // return "";

    // char setup[] = "tripledes-ecb";
    // if (!QCA::isSupported(setup)) {
    //     qDebug() << setup << "is not supported";
    //     return "";
    // }
    QCA::Cipher cipher(type, mode, paddingMode, direction, key, initVector);

    return QCA::arrayToHex(cipher.process(text).toByteArray());
}

void we();

void LabCore2::test() {
    bool gowe = 0;
    if (gowe) {
        we();
    } else {
        // QString text = "0123456789abcde7";
        // QString textEnc = process("3DES", "ECB", "ZEROS", "2020202020202020", "0123456789abcdeffedcba9876543210", text, "ENCRYPT");
        // QString textEncDec = process("3DES", "ECB", "ZEROS", "2020202020202020", "0123456789abcdeffedcba9876543210", text, "DECRYPT");
        // qDebug() << text << "->" << textEnc << "->" << textEncDec;

        QString text = "123456abcd";
        QString textEnc = process("AES128", "CBC", "DEFAULT", "1234567812345678", "1234abc1234abc", text, "ENCRYPT");
        QString textEncDec = process("AES128", "CBC", "DEFAULT", "1234567812345678", "1234abc1234abc", textEnc, "DECRYPT");
        qDebug() << text << "->" << textEnc << "->" << textEncDec;

        qDebug() << "7F1DDA77826F8AFF";
    }
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
