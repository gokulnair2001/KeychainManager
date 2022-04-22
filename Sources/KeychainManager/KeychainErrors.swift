//
//  KeychainErrors.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 19/04/22.
//

import Foundation

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
    case noPassword
}

enum secureClassType: String {
    
    case webCredentials
    case genericPassword

    func value() -> String {
        switch self {
        case .webCredentials:
            return kSecClassInternetPassword as String
        case .genericPassword:
            return kSecClassGenericPassword as String
        }
    }
}
