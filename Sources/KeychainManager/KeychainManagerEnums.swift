//
//  File.swift
//  
//
//  Created by Gokul Nair on 25/04/22.
//

import Foundation

//MARK: - Keychain Error Type Enum

enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
    case noPassword
}

//MARK: - Keychain Security Class Type Enum

public enum secureClassType {
    
    case webCredentials
    case genericPassword

    func value() -> String {
        switch self {
        case .webCredentials:
            return KMConstants.internetPassword.value()
        case .genericPassword:
            return KMConstants.genericPassword.value()
        }
    }
}
