//
//  KeychainSecClassEnum.swift
//  
//
//  Created by Gokul Nair on 22/04/22.
//

import Foundation

//MARK: - Keychain Security Class Types

public enum secureClassType: String {
    
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
