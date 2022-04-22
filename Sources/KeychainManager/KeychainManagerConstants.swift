//
//  KeychainManagerConstants.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 19/04/22.
//

import Foundation

public struct KeychainManagerConstants {
    
    static var classType: String {return asString(kSecClass)}
    
    static var service: String {return asString(kSecAttrService)}
    
    static var account: String {return asString(kSecAttrAccount)}
    
    static var valueData: String {return asString(kSecValueData)}
    
    static var returnData: String {return asString(kSecReturnData)}
  
    static var returnReference: String {return asString(kSecReturnRef)}
    
    static var returnAttributes: String {return asString(kSecReturnAttributes)}
    
    static var matchLimit: String {return asString(kSecMatchLimit)}
    
    static var accessGroup: String {return asString(kSecAttrAccessGroup)}
    
    static var server: String {return asString(kSecAttrServer)}
    
    static func asString(_ value: CFString) -> String {
        return value as String
    }
}
