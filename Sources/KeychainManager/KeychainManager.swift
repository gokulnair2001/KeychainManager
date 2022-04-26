//
//  KeychainManager.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 18/04/22.
//

import Foundation

open class KeychainManager {
    
    fileprivate var accessGroup: String = ""
    fileprivate var keyPrefix: String = ""
    fileprivate var accessibility: accessibilityType = .accessibleWhenUnlocked
    
    /// Initialiser to use only KeyPrefix
    public init(keyPrefix: String) {
        self.keyPrefix = keyPrefix
    }
    
    /// Initialiser to use only Access Group
    public init (accessGroup: String) {
        self.accessGroup = accessGroup
    }
    
    /// Initialiser to use only accessibility type
    public init(accessibility: accessibilityType) {
        self.accessibility = accessibility
    }
    
    /// Initialiser to use KeyPrefix and Access Group
    public init (accessGroup: String, keyPrefix: String) {
        self.accessGroup = accessGroup
        self.keyPrefix = keyPrefix
    }
   
    /// Initialiser to use keyPrefix & accessibility
    public init(keyPrefix: String, accessibility: accessibilityType) {
        self.keyPrefix = keyPrefix
        self.accessibility = accessibility
    }
    
    /// Initialiser to use Access group & accessibility
    public init(accessGroup: String, accessibility: accessibilityType) {
        self.accessGroup = accessGroup
        self.accessibility = accessibility
    }
    
    /// Initialiser to use Access group, keyPrefix & accessibility
    public init(accessGroup: String, keyPrefix: String, accessibility: accessibilityType) {
        self.accessGroup = accessGroup
        self.keyPrefix = keyPrefix
        self.accessibility = accessibility
    }
    
    /// Empty Initialiser to use generic keyChain
    public init() {}
}

//MARK: - SET
extension KeychainManager {
    
    //MARK: SET DRIVER CODE
    fileprivate func set(value: Data, service: String, account: String, access: accessibilityType) throws {
        var accessErrorUnmanaged: Unmanaged<CFError>? = nil
        
        let selectedAccess = SecAccessControlCreateWithFlags(kCFAllocatorDefault, access.value(), [], &accessErrorUnmanaged)
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType  :  kSecClassGenericPassword,
            KeychainManagerConstants.service    :  service as AnyObject,
            KeychainManagerConstants.account    :  (keyPrefix + account) as AnyObject,
            KeychainManagerConstants.accessType :  selectedAccess as AnyObject,
            KeychainManagerConstants.valueData  :  value as AnyObject,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard accessErrorUnmanaged != nil else {
            throw KeychainError.accessError
        }
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: Method to save boolean values
    public func set(value: Bool, service: String, account: String, withAccess: accessibilityType? = nil) {
        let bytes: [UInt8] = value ? [1] : [0]
        
        do {
            try set(value:  Data(bytes), service: service, account: account, access: withAccess ?? accessibility)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Method to store String directly to keychain
    public func set(value: String, service: String, account: String, withAccess: accessibilityType? = nil) {
        
        do {
            try set(value: value.data(using: .utf8) ?? Data(), service: service, account: account, access: withAccess ?? accessibility)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Method to save Custom Data Object
    public func set <T: Codable> (object: T, service: String, account: String, withAccess: accessibilityType? = nil) {
        
        guard let userData = try? JSONEncoder().encode(object) else { return }
        
        do {
            try? KeychainManager().set(value: userData, service: service, account: account, access: withAccess ?? accessibility)
        }
    }
    
    //MARK: SET WEB CREDENTIALS DRIVER
    fileprivate func set(server: String, user: String, password: String, access: accessibilityType) throws {
        var accessErrorUnmanaged: Unmanaged<CFError>? = nil
        
        let encryptedPassword = password.data(using: .utf8)
        let selectedAccess = SecAccessControlCreateWithFlags(kCFAllocatorDefault, access.value(), [], &accessErrorUnmanaged)
        
        var query: [String : AnyObject] = [
            KeychainManagerConstants.classType  :  kSecClassInternetPassword,
            KeychainManagerConstants.account    :  user as AnyObject,
            KeychainManagerConstants.server     :  server as AnyObject,
            KeychainManagerConstants.accessType :  selectedAccess as AnyObject,
            KeychainManagerConstants.valueData  :  encryptedPassword as AnyObject,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
        }
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard accessErrorUnmanaged != nil else {
            throw KeychainError.accessError
        }
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    //MARK: Method to store web credentials
    public func set(server: String, account: String, password: String, withAccess: accessibilityType? = nil) {
        
        do {
            try set(server: server, user: account, password: password, access: withAccess ?? accessibility)
        }catch {
            print(error.localizedDescription)
        }
    }
    
}

//MARK: - GET
extension KeychainManager {
    
    //MARK: GET DRIVER CODE
    fileprivate func get(service: String, account: String) -> Data? {
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType   :  kSecClassGenericPassword,
            KeychainManagerConstants.service     :  service as AnyObject,
            KeychainManagerConstants.account     :  (keyPrefix + account) as AnyObject,
            KeychainManagerConstants.returnData  :  kCFBooleanTrue,
            KeychainManagerConstants.matchLimit  :  kSecMatchLimitOne,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
            query.updateValue(kCFBooleanTrue, forKey: KeychainManagerConstants.returnAttributes)
        }
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read Status: \(status)")
        
        return result as? Data
    }
    
    //MARK: Method to fetch bool values
    public func getBool(service: String, account: String) -> Bool{
        guard let data = get(service: service, account: account) else {return false}
        guard let firstBit = data.first else {return false}
        
        return firstBit == 1
    }
    
    //MARK: Method to get custom object type
    public func get<T: Codable> (object: T, service: String, account: String) -> T? {
        
        guard let userData = KeychainManager().get(service: service, account: account) else {return nil}
        
        guard let decodedData = try? JSONDecoder().decode(T.self, from: userData) else { return nil}
        
        return decodedData
    }
    
    //MARK: Method to get String value
    public func get(service: String, account: String) -> String {
        
        let rawData: Data? = get(service: service, account: account)
        
        let userData = String(decoding: rawData ?? Data(), as: UTF8.self)
        
        return userData
    }
    
    //MARK: GET WEB CREDENTIALS DRIVER
    fileprivate func get(server: String, account: String) -> Data? {
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType   :  kSecClassInternetPassword,
            KeychainManagerConstants.account     :  account as AnyObject,
            KeychainManagerConstants.server      :  server as AnyObject,
            KeychainManagerConstants.returnData  :  kCFBooleanTrue,
            KeychainManagerConstants.matchLimit  :  kSecMatchLimitOne,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
            query.updateValue(kCFBooleanTrue, forKey: KeychainManagerConstants.returnAttributes)
        }
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read Status: \(status)")
        
        return result as? Data
    }
    
    //MARK: Method to get Web Credential value
    public func get(server: String, account: String) -> String {
        
        let rawData: Data? = get(server: server, account: account)
        
        let userData = String(decoding: rawData ?? Data(), as: UTF8.self)
        
        return userData
    }
    
    //MARK: - GET ALL VALUES
    public func getAllValues(secClass: secureClassType) -> [String:String] {
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType as String        :  secClass.value() as AnyObject,
            KeychainManagerConstants.returnData as String       :  kCFBooleanTrue,
            KeychainManagerConstants.returnAttributes as String :  kCFBooleanTrue,
            KeychainManagerConstants.returnReference as String  :  kCFBooleanTrue,
            KeychainManagerConstants.matchLimit as String       :  kSecMatchLimitAll
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
            query.updateValue(kCFBooleanTrue, forKey: KeychainManagerConstants.returnAttributes)
        }
        
        var result: AnyObject?
        
        let lastResultCode = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        var values = [String:String]()
        if lastResultCode == noErr {
            let array = result as? Array<Dictionary<String, Any>>
            
            for item in array! {
                if let key = item[kSecAttrAccount as String] as? String,
                   let value = item[kSecValueData as String] as? Data {
                    values[key] = String(data: value, encoding:.utf8)
                }
            }
        }
        
        return values
    }
}

//MARK: - UPDATE
extension KeychainManager {
    
    //MARK: UPDATE DRIVER CODE
    fileprivate func update(value: Data, account: String)  throws {
        
        let attributes: [String: Any] = [
            KeychainManagerConstants.account    :  (keyPrefix + account) as AnyObject,
            KeychainManagerConstants.valueData  :  value
        ]
        
        var query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
        }
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }
    
    //MARK: Update Bool Values
    public func update(value: Bool, account: String) {
        let bytes: [UInt8] = value ? [1] : [0]
        
        do {
            try update(value: Data(bytes), account: account)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Update String Value
    public func update(value: String, account: String) {
        do {
            print("⚠️ Val: \(value.data(using: .utf8) ?? Data()) | Acc: \(account)")
            try update(value: value.data(using: .utf8) ?? Data(), account: account)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Update Custom Objects
    public func update<T: Codable> (object: T, account: String) {
        
        guard let userData = try? JSONEncoder().encode(object) else { return }
        
        do {
            try update(value: userData, account: account)
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: UPDATE WEB CREDENTIALS DRIVER
    fileprivate func update(account: String, password: Data) throws {
        
        let attributes: [String: Any] = [
            
            KeychainManagerConstants.account    :  account as AnyObject,
            KeychainManagerConstants.valueData  :  password as AnyObject,
        ]
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType : kSecClassInternetPassword,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
            query.updateValue(kCFBooleanTrue, forKey: KeychainManagerConstants.returnAttributes)
        }
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }
    
    //MARK: Update Web Credentials
    public func update(account: String, newPassword: String) {
        do {
            let encryptedPassword = newPassword.data(using: .utf8) ?? Data()
            print(encryptedPassword)
            try update(account: account, password: encryptedPassword)
            
        }catch {
            print("⚠️ \(error.localizedDescription)")
        }
    }
}

//MARK: - DELETE
extension KeychainManager {
    
    //MARK: DELETE SELECTED ITEM
    public func delete(service: String, account: String) throws {
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType  :  kSecClassGenericPassword,
            KeychainManagerConstants.service    :  service as AnyObject,
            KeychainManagerConstants.account    :  (keyPrefix + account) as AnyObject,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status) }
    }
    
    //MARK: DELETE ALL ITEMS
    public func clearKeyChain() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status) }
    }
    
    //MARK: - DLETE WEB CREDENTIALS
    public func delete(server: String, account: String) throws {
        
        var query: [String: AnyObject] = [
            KeychainManagerConstants.classType  :  kSecClassInternetPassword,
            KeychainManagerConstants.server     :  server as AnyObject,
            KeychainManagerConstants.account    :  account as AnyObject,
        ]
        
        if isAccessSharing() {
            query.updateValue(accessGroup as AnyObject, forKey: KeychainManagerConstants.accessGroup)
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status) }
    }
}

//MARK: - Tools
extension KeychainManager {
    
    /// To check is access sharing allowed or not
    private func isAccessSharing() -> Bool {
        if accessGroup.isEmpty {
            return false
        }else {
            return true
        }
    }
}
