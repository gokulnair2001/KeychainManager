//
//  KeychainManagerConstants.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 19/04/22.
//

import Foundation

public struct KMConstants {
    
    static var classType: String {return castToString(kSecClass)}
    
    static var service: String {return castToString(kSecAttrService)}
    
    static var account: String {return castToString(kSecAttrAccount)}
    
    static var valueData: String {return castToString(kSecValueData)}
    
    static var returnData: String {return castToString(kSecReturnData)}
  
    static var returnReference: String {return castToString(kSecReturnRef)}
    
    static var returnAttributes: String {return castToString(kSecReturnAttributes)}
    
    static var matchLimit: String {return castToString(kSecMatchLimit)}
    
    static var accessGroup: String {return castToString(kSecAttrAccessGroup)}
    
    static var server: String {return castToString(kSecAttrServer)}
    
    static var synchronizable: String {return castToString(kSecAttrSynchronizable)}
    
    static var dataProtection: String {return castToString(kSecUseDataProtectionKeychain)}
    
    //MARK: - Keychain Type
    
    static var internetPassword: String {return castToString(kSecClassInternetPassword)}
    
    static var genericPassword: String {return castToString(kSecClassGenericPassword)}
    
    //MARK: - Method to cast string type
    
    static func castToString(_ value: CFString) -> String {
        return value as String
    }
}
