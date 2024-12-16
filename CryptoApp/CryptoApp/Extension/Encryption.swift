//
//  Encryption.swift
//  CryptoApp
//
//  Created by Rockz on 19/11/24.
//

import Foundation
import CryptoKit
import CoreData

// Generate a symmetric key for AES encryption

//let key = SymmetricKey(size: .bits256)
//
//func encryptData(_ data: String) -> String? {
//    guard let data = data.data(using: .utf8) else { return nil }
//    do {
//        let sealedBox = try AES.GCM.seal(data, using: key)
//        return sealedBox.combined?.base64EncodedString()
//    } catch {
//        print("Encryption error: \(error.localizedDescription)")
//        return nil
//    }
//}
//
//func decryptData(_ base64String: String) -> String? {
//    guard let data = Data(base64Encoded: base64String) else {
//        print("Invalid Base64 string.")
//        return nil
//    }
//
//    do {
//        let sealedBox = try AES.GCM.SealedBox(combined: data)
//        let decryptedData = try AES.GCM.open(sealedBox, using: key)
//        return String(data: decryptedData, encoding: .utf8)
//    } catch {
//        print("Decryption error: \(error.localizedDescription)")
//        return nil
//    }
//}


import CryptoKit
import Foundation

private let passphrase = "YourSecurePassphraseHere"

private var key: SymmetricKey {
    let keyData = passphrase.data(using: .utf8)!
    return SymmetricKey(data: SHA256.hash(data: keyData))
}

func encryptData(_ data: String) -> String? {
    guard let data = data.data(using: .utf8) else { return nil }
    do {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined?.base64EncodedString()
    } catch {
        print("Encryption error: \(error.localizedDescription)")
        return nil
    }
}

func decryptData(_ base64String: String) -> String? {
    guard let data = Data(base64Encoded: base64String) else { return nil }
    do {
        let sealedBox = try AES.GCM.SealedBox(combined: data)
        let decryptedData = try AES.GCM.open(sealedBox, using: key)
        return String(data: decryptedData, encoding: .utf8)
    } catch {
        print("Decryption error: \(error.localizedDescription)")
        return nil
    }
}
