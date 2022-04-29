//
//  KeychainManager.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 18/04/22.
//

import Foundation

open class KeychainManager {
    
    fileprivate var keyPrefix: String = ""
    
    /// Bool which specifies if synchronizable data
    open var synchronizable: Bool = false
    
    open var accessibility: accessibilityType? = nil
    
    /// Initialiser to use only KeyPrefix
    public init(keyPrefix: String) {
        self.keyPrefix = keyPrefix
    }
    
    /// Initialiser to set  synchronizable
    public init(synchronizable: Bool) {
        self.synchronizable = synchronizable
    }
    
    /// Initialiser to set keyPrefix and synchronizable
    public init(keyPrefix: String, synchronizable: Bool) {
        self.keyPrefix = keyPrefix
        self.synchronizable = synchronizable
    }
    
    /// Empty Initialiser to use generic keyChain
    public init() {}

}

//MARK: - SET
extension KeychainManager {
    
    //MARK: SET DRIVER CODE
    fileprivate func set(value: Data, service: String, account: String) throws {
       
        var query: [String: AnyObject] = [
            KMConstants.classType  :  kSecClassGenericPassword,
            KMConstants.service    :  service as AnyObject,
            KMConstants.account    :  (keyPrefix + account) as AnyObject,
            KMConstants.valueData  :  value as AnyObject,
        ]
        
        query = addAccessibility(queryItems: query, accessType: accessibility)
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
    
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    // MARK: Method to save boolean values
    public func set(value: Bool, service: String, account: String) {
        let bytes: [UInt8] = value ? [1] : [0]
        
        do {
            try set(value:  Data(bytes), service: service, account: account)
        }catch {
            print(error)
        }
    }
    
    // MARK: Method to store String directly to keychain
    public func set(value: String, service: String, account: String) {
        
        do {
            try set(value: value.data(using: .utf8) ?? Data(), service: service, account: account)
        }catch {
            print(error)
        }
    }
    
    // MARK: Method to save Custom Data Object
    public func set <T: Codable> (object: T, service: String, account: String) {
        
        guard let userData = try? JSONEncoder().encode(object) else { return }
        
        do {
            try? KeychainManager().set(value: userData, service: service, account: account)
        }
    }
    
    //MARK: SET WEB CREDENTIALS DRIVER
    fileprivate func set(server: String, user: String, password: String) throws {
       
        let encryptedPassword = password.data(using: .utf8)
        
        var query: [String : AnyObject] = [
            KMConstants.classType  :  kSecClassInternetPassword,
            KMConstants.account    :  user as AnyObject,
            KMConstants.server     :  server as AnyObject,
            KMConstants.valueData  :  encryptedPassword as AnyObject,
        ]
        
        query = addAccessibility(queryItems: query, accessType: accessibility)
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
    }
    
    //MARK: Method to store web credentials
    public func set(server: String, account: String, password: String) {
        
        do {
            try set(server: server, user: account, password: password)
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
            KMConstants.classType   :  kSecClassGenericPassword,
            KMConstants.service     :  service as AnyObject,
            KMConstants.account     :  (keyPrefix + account) as AnyObject,
            KMConstants.returnData  :  kCFBooleanTrue,
            KMConstants.matchLimit  :  kSecMatchLimitOne,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read Status: \(status)")
        
        return result as? Data
    }
    
    //MARK: Method to fetch bool values
    @discardableResult
    public func getBool(service: String, account: String) -> Bool{
        guard let data = get(service: service, account: account) else {return false}
        guard let firstBit = data.first else {return false}
        
        return firstBit == 1
    }
    
    //MARK: Method to get custom object type
    @discardableResult
    public func get<T: Codable> (object: T, service: String, account: String) -> T? {
        
        guard let userData = KeychainManager().get(service: service, account: account) else {return nil}
        
        guard let decodedData = try? JSONDecoder().decode(T.self, from: userData) else { return nil}
        
        return decodedData
    }
    
    //MARK: Method to get String value
    @discardableResult
    public func get(service: String, account: String) -> String {
        
        let rawData: Data? = get(service: service, account: account)
        
        let userData = String(decoding: rawData ?? Data(), as: UTF8.self)
        
        return userData
    }
    
    //MARK: GET WEB CREDENTIALS DRIVER
    fileprivate func get(server: String, account: String) -> Data? {
        
        var query: [String: AnyObject] = [
            KMConstants.classType   :  kSecClassInternetPassword,
            KMConstants.account     :  account as AnyObject,
            KMConstants.server      :  server as AnyObject,
            KMConstants.returnData  :  kCFBooleanTrue,
            KMConstants.matchLimit  :  kSecMatchLimitOne,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print("Read Status: \(status)")
        
        return result as? Data
    }
    
    //MARK: Method to get Web Credential value
    @discardableResult
    public func get(server: String, account: String) -> String {
        
        let rawData: Data? = get(server: server, account: account)
        
        let userData = String(decoding: rawData ?? Data(), as: UTF8.self)
        
        return userData
    }
    
    //MARK: - GET ALL VALUES
    @discardableResult
    public func getAllValues(secClass: secureClassType) -> [String:String] {
        
        var query: [String: AnyObject] = [
            KMConstants.classType as String        :  secClass.value() as AnyObject,
            KMConstants.returnData as String       :  kCFBooleanTrue,
            KMConstants.returnAttributes as String :  kCFBooleanTrue,
            KMConstants.returnReference as String  :  kCFBooleanTrue,
            KMConstants.matchLimit as String       :  kSecMatchLimitAll
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
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
            KMConstants.account    :  (keyPrefix + account) as AnyObject,
            KMConstants.valueData  :  value
        ]
        
        var query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
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
            
            KMConstants.account    :  account as AnyObject,
            KMConstants.valueData  :  password as AnyObject,
        ]
        
        var query: [String: AnyObject] = [
            KMConstants.classType : kSecClassInternetPassword,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
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
            KMConstants.classType  :  kSecClassGenericPassword,
            KMConstants.service    :  service as AnyObject,
            KMConstants.account    :  (keyPrefix + account) as AnyObject,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
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
            KMConstants.classType  :  kSecClassInternetPassword,
            KMConstants.server     :  server as AnyObject,
            KMConstants.account    :  account as AnyObject,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status) }
    }
}

//MARK: - Tools
extension KeychainManager {
    
    /// Method to enable iCloud Sync
    func addSyncIfRequired(queryItems: [String: AnyObject], isSynchronizable: Bool) -> [String: AnyObject] {
       
        if isSynchronizable {
            print("sync ✅")
            var result: [String: AnyObject] = queryItems
            result[KMConstants.synchronizable] = isSynchronizable ? kCFBooleanTrue as AnyObject : kSecAttrSynchronizableAny as AnyObject
            return result
        }
        
        return queryItems
    }
    
    /// Method to add accessibility type
    func addAccessibility(queryItems: [String: AnyObject], accessType: accessibilityType? = nil) -> [String: AnyObject] {
        print("access ⭐️")
        if accessType != nil {
            var result: [String: AnyObject] = queryItems
            let selectedAccess = SecAccessControlCreateWithFlags(kCFAllocatorDefault, accessType!.value(), [], nil)
            result[KMConstants.accessType] = selectedAccess as AnyObject
            return result
        }
        
        return queryItems
    }
}
