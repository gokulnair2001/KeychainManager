//
//  KeychainManagerConstants.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 19/04/22.
//

import Foundation

public struct KeychainManagerConstants {
    
    static var classType: String {return toString(kSecClass)}
    
    static var service: String {return toString(kSecAttrService)}
    
    static var account: String {return toString(kSecAttrAccount)}
    
    static var valueData: String {return toString(kSecValueData)}
    
    static var returnData: String {return toString(kSecReturnData)}
  
    static var returnReference: String {return toString(kSecReturnRef)}
    
    static var returnAttributes: String {return toString(kSecReturnAttributes)}
    
    static var matchLimit: String {return toString(kSecMatchLimit)}
    
    static var accessGroup: String {return toString(kSecAttrAccessGroup)}
    
    static var server: String {return toString(kSecAttrServer)}
    
    static var accessType: String {return toString(kSecAttrAccessControl)}
    
    //MARK: - Keychain Type
    
    static var internetPassword: String {return toString(kSecClassInternetPassword)}
    
    static var genericPassword: String {return toString(kSecClassGenericPassword)}
    
    //MARK: - Keychain Access Type
    
    static var passcodeSet: String {return toString(kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly)}
    
    static var unlocked: String {return toString(kSecAttrAccessibleWhenUnlocked)}
   
    static var unlockedTDO: String {return toString(kSecAttrAccessibleWhenUnlockedThisDeviceOnly)}
    
    static var firstUnlock: String {return toString(kSecAttrAccessibleAfterFirstUnlock)}
    
    static var firstUnlockTDO: String {return toString(kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly)}
    
    
    //MARK: - Method to return string type
    
    static func toString(_ value: CFString) -> String {
        return value as String
    }
}
