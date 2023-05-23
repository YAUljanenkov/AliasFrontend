//
//  KeyChain.swift
//  AliasFrontend
//
//  Created by Ярослав Ульяненков on 21.05.2023.


import Foundation

// this is a modified code from https://stackoverflow.com/questions/68209016/store-accesstoken-in-ios-keychain

/// Errors that can be thrown when the Keychain is queried.
enum KeychainError: LocalizedError {
    /// The requested item was not found in the Keychain.
    case itemNotFound
    /// Attempted to save an item that already exists.
    /// Update the item instead.
    case duplicateItem
    /// The operation resulted in an unexpected status.
    case unexpectedStatus(OSStatus)
}

/// A service that can be used to group the tokens
/// as the kSecAttrAccount should be unique.

struct KeyChainService {
    let service = "ru.hse.alias.AliasFrontend.bearer-service"
    
    func insertToken(_ token: Data, identifier: String) throws {
        let attributes = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecValueData: token
        ] as [CFString : Any] as CFDictionary

        let status = SecItemAdd(attributes, nil)
        guard status == errSecSuccess else {
            if status == errSecDuplicateItem {
                throw KeychainError.duplicateItem
            }
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    func getToken(identifier: String) throws -> String {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true
        ] as [CFString : Any] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                // Technically could make the return optional and return nil here
                // depending on how you like this to be taken care of
                throw KeychainError.itemNotFound
            }
            throw KeychainError.unexpectedStatus(status)
        }
        // Lots of bang operators here, due to the nature of Keychain functionality.
        // You could work with more guards/if let or others.
        return String(data: result as! Data, encoding: .utf8)!
    }
    
    func updateToken(_ token: Data, identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier
        ] as [CFString : Any] as CFDictionary

        let attributes = [
            kSecValueData: token
        ] as CFDictionary

        let status = SecItemUpdate(query, attributes)
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            }
            throw KeychainError.unexpectedStatus(status)
        }
    }

    func upsertToken(_ token: Data, identifier: String) throws {
        do {
            _ = try getToken(identifier: identifier)
            try updateToken(token, identifier: identifier)
        } catch KeychainError.itemNotFound {
            try insertToken(token, identifier: identifier)
        }
    }

    func deleteToken(identifier: String) throws {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: identifier
        ] as [CFString : Any] as CFDictionary

        let status = SecItemDelete(query)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
}
