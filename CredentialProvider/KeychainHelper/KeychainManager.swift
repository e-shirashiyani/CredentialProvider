//
//  KeychainManager.swift
//  CredentialProvider
//
//  Created by e.shirashiyani on 5/4/24.
//

import Foundation
import Security

class KeychainManager {
    func saveCredential(user: String, password: String, service: String) {
        let attributes: [String: Any] = [kSecValueData as String: password.data(using: .utf8)!, kSecAttrAccount as String: user, kSecAttrService as String: service, kSecClass as String: kSecClassGenericPassword]
        SecItemAdd(attributes as CFDictionary, nil)
    }

    func getCredential(service: String) -> (user: String, password: String)? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service, kSecReturnAttributes as String: true, kSecReturnData as String: true]
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) == noErr {
            let existingItem = item as? [String: Any]
            let passwordData = existingItem?[kSecValueData as String] as? Data
            let password = String(data: passwordData!, encoding: .utf8)!
            let user = existingItem?[kSecAttrAccount as String] as? String ?? ""
            return (user, password)
        }
        return nil
    }
}
