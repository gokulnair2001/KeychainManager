//
//  File.swift
//  
//
//  Created by Gokul Nair on 25/04/22.
//

import Foundation

//MARK: - Access Type Enum

public enum accessibilityType {
    case accessibleWhenPasscodeSet
    case accessibleWhenUnlocked
    case accessibleWhenUnlockedTDO
    case accessibleOnFirstUnlock
    case accessibleOnFirstUnlockTDO
    
    //MARK: - Method to return Enum value
    
     func value() -> CFString {
        switch self {
        case .accessibleWhenPasscodeSet:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .accessibleWhenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .accessibleWhenUnlockedTDO:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .accessibleOnFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .accessibleOnFirstUnlockTDO:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        }
    }
}

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
            return KMConstants.internetPassword
        case .genericPassword:
            return KMConstants.genericPassword
        }
    }
}
