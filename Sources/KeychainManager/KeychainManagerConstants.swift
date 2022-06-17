//
//  KeychainManagerConstants.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 19/04/22.
//

import Foundation

//MARK: - Keychain Manager Secure Storage Items
/// The KMConstants enum returns the String value of CFString based Items
enum KMConstants {
    
    case classType
    case service
    case account
    case valueData
    case returnData
    case returnReference
    case returnAttributes
    case matchLimit
    case accessGroup
    case server
    case synchronizable
    case dataProtection
    case internetPassword
    case genericPassword
    
    /// Method to cast CFString to String
    private func castToString(_ value: CFString) -> String {
        return value as String
    }

    /// Method to return value of KMConstants Selected
    func value() -> String {
        switch self {
        case .classType:
            return castToString(kSecClass)
        case .service:
            return castToString(kSecAttrService)
        case .account:
            return castToString(kSecAttrAccount)
        case .valueData:
            return castToString(kSecValueData)
        case .returnData:
            return castToString(kSecReturnData)
        case .returnReference:
            return castToString(kSecReturnRef)
        case .returnAttributes:
            return castToString(kSecReturnAttributes)
        case .matchLimit:
            return castToString(kSecMatchLimit)
        case .accessGroup:
            return castToString(kSecAttrAccessGroup)
        case .server:
            return castToString(kSecAttrServer)
        case .synchronizable:
            return castToString(kSecAttrSynchronizable)
        case .dataProtection:
            return castToString(kSecUseDataProtectionKeychain)
        case .internetPassword:
            return castToString(kSecClassInternetPassword)
        case .genericPassword:
            return castToString(kSecClassGenericPassword)
        }
    }
}
