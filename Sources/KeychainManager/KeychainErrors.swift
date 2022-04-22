//
//  KeychainErrors.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 19/04/22.
//

import Foundation

//MARK: - Keychain Internal error types

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
    case noPassword
}
