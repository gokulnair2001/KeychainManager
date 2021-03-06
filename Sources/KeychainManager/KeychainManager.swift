//
//  KeychainManager.swift
//  KeyChain-Test
//
//  Created by Gokul Nair on 18/04/22.
//

import Foundation

open class KeychainManager {
    
    /// KeyPrefix: Prefix used to append to the account id.
    /// Such Prefix are best used when performing tests. Eg: test_account1_
    fileprivate var keyPrefix: String = ""
    
    /// AccessGroup: Unique access group ID
    /// Used to sync data among same ID devices
    fileprivate var accessGroup: String = ""
    
    /// Synchronizable: Bool which specifies if synchronizable data.
    /// When enabled all the keychains will be saved on the users iCloud account.
    fileprivate var synchronizable: Bool = false
    
    /// Initialiser to pre set KeyPrefix
    public init(keyPrefix: String) {
        self.keyPrefix = keyPrefix
    }
    
    /// Initialiser to pre set  access group and iCloud sync state of Keychain
    public init(accessGroup:String, synchronizable: Bool) {
        self.accessGroup = accessGroup
        self.synchronizable = synchronizable
    }
    
    /// Initialiser to pre set keyPrefix, access group and sync state of Keychain
    public init(keyPrefix: String, accessGroup:String, synchronizable: Bool) {
        self.keyPrefix = keyPrefix
        self.accessGroup = accessGroup
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
            KMConstants.classType.value()      :  kSecClassGenericPassword,
            KMConstants.service.value()        :  service as AnyObject,
            KMConstants.account.value()        :  (keyPrefix + account) as AnyObject,
            KMConstants.valueData.value()      :  value as AnyObject,
            KMConstants.dataProtection.value() :  kCFBooleanTrue as AnyObject,
        ]
        
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
    /// Function to SET/SAVE keychain values as Bool
    /// - Parameters:
    ///   - value: Bool value to save
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    public func set(value: Bool, service: String, account: String) {
        let bytes: [UInt8] = value ? [1] : [0]
        
        do {
            try set(value:  Data(bytes), service: service, account: account)
        }catch {
            print(error)
        }
    }
    
    // MARK: Method to store String directly to keychain
    /// Function to SET/SAVE keychain values as String
    /// - Parameters:
    ///   - value: String value to save
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    public func set(value: String, service: String, account: String) {
        
        do {
            try set(value: value.data(using: .utf8) ?? Data(), service: service, account: account)
        }catch {
            print(error)
        }
    }
    
    // MARK: Method to save Custom Data Object
    /// Function to SET/SAVE keychain values as Custom Objects
    /// - Parameters:
    ///   - object: Custom Codable object to save
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
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
            KMConstants.classType.value()      :  kSecClassInternetPassword,
            KMConstants.account.value()        :  user as AnyObject,
            KMConstants.server.value()         :  server as AnyObject,
            KMConstants.valueData.value()      :  encryptedPassword as AnyObject,
            KMConstants.dataProtection.value() : kCFBooleanTrue as AnyObject,
        ]
        
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
    /// Function to SET/SAVE Internet passwords on keychain
    /// - Parameters:
    ///   - server: Contains the server's domain name or IP address
    ///   - account: Account name of keychain holder
    ///   - password: Password to save in keychain
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
    fileprivate func get(service: String, account: String) -> (value: Data?, status: OSStatus) {
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value()   :  kSecClassGenericPassword,
            KMConstants.service.value()     :  service as AnyObject,
            KMConstants.account.value()     :  (keyPrefix + account) as AnyObject,
            KMConstants.returnData.value()  :  kCFBooleanTrue,
            KMConstants.matchLimit.value()  :  kSecMatchLimitOne
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return (result as? Data, status)
    }
    
    //MARK: Method to fetch bool values
    @discardableResult
    /// Function to GET/FETCH keychain values as stored as Bool
    /// - Parameters:
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    /// - Returns: Returns the Bool value stored
    public func getBool(service: String, account: String) -> Bool {
        guard let data = get(service: service, account: account).value else {return false}
        guard let firstBit = data.first else {return false}
        
        return firstBit == 1
    }
    
    //MARK: Method to get custom object type
    @discardableResult
    /// Function to GET/FETCH keychain values as stored as Custom Object
    /// - Parameters:
    ///   - object: Custom Codable object to save
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    /// - Returns: Returns the Codable object stored
    public func get<T: Codable> (object: T, service: String, account: String) -> T? {
        
        guard let userData = get(service: service, account: account).value else {return nil}
        
        guard let decodedData = try? JSONDecoder().decode(T.self, from: userData) else { return nil}
        
        return decodedData
    }
    
    //MARK: Method to get String value
    @discardableResult
    /// Function to GET/FETCH keychain values as stored as String
    /// - Parameters:
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    /// - Returns: Returns the String value stored
    public func get(service: String, account: String) -> String {
        
        let rawData: Data? = get(service: service, account: account).value
        
        let userData = String(decoding: rawData ?? Data(), as: UTF8.self)
        
        return userData
    }
    
    //MARK: GET WEB CREDENTIALS DRIVER
    fileprivate func get(server: String, account: String) -> (password: Data?, status: OSStatus) {
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value()   :  kSecClassInternetPassword,
            KMConstants.account.value()     :  account as AnyObject,
            KMConstants.server.value()      :  server as AnyObject,
            KMConstants.returnData.value()  :  kCFBooleanTrue,
            KMConstants.matchLimit.value()  :  kSecMatchLimitOne,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        return (result as? Data, status)
    }
    
    //MARK: Method to get Web Credential value
    @discardableResult
    /// Function to GET/FETCH internet password stored
    /// - Parameters:
    ///   - server: Contains the server's domain name or IP address
    ///   - account: Account name of keychain holder
    /// - Returns: Returns the password stored
    public func get(server: String, account: String) -> String {
        
        let rawData: Data? = get(server: server, account: account).password
        
        let userData = String(decoding: rawData ?? Data(), as: UTF8.self)
        
        return userData
    }
    
    //MARK: - VALIDATE SERVICE AND SERVER
    /// Function to validate the provided Service and Account combination
    /// - Parameters:
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    /// - Returns: Returns the validation result
    public func isValidService(service: String, account: String) -> Bool {
        
        let status = get(service: service, account: account).status
        
        if status == 0 {
            return true
        }
        
        return false
    }
    
    /// Function to validate the provided Server and Account combination
    /// - Parameters:
    ///   - server: Contains the server's domain name or IP address
    ///   - account: Account name of keychain holder
    /// - Returns: Returns the validation result
    public func isValidServer(server: String, account: String) -> Bool {
        
        let status = get(server: server, account: account).status
        
        if status == 0 {
            return true
        }
        
        return false
    }
    
    //MARK: - GET ALL VALUES
    @discardableResult
    /// Function to GET/FETCH all the values stored in keychain
    /// - Parameter secClass: Specifies the keychain security class to fetch
    /// - Returns: Returns all the values stored
    public func getAllValues(secClass: secureClassType) -> [String:String] {
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value()        :  secClass.value() as AnyObject,
            KMConstants.returnData.value()       :  kCFBooleanTrue,
            KMConstants.returnAttributes.value() :  kCFBooleanTrue,
            KMConstants.returnReference.value()  :  kCFBooleanTrue,
            KMConstants.matchLimit.value()       :  kSecMatchLimitAll
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
    
    //MARK: UPDATE DRIVER CODE FOR GENERIC PASSWORD
    fileprivate func update(value: Data, account: String, service: String, isCustomObjectType: Bool = false)  throws {
        
        let attributes: [String: Any] = [
            KMConstants.account.value()    :  (keyPrefix + account) as AnyObject,
            KMConstants.valueData.value()  :  value,
        ]
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value() : kSecClassGenericPassword,
            KMConstants.service.value()   : service as AnyObject
        ]
        if !isCustomObjectType {
            query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        }
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }
    
    //MARK: Update Bool Values
    /// Function to UPDATE any bool value stored in Keychain
    /// - Parameters:
    ///   - value: specifies the new bool value to be updated
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    public func update(value: Bool, service: String, account: String) {
        let bytes: [UInt8] = value ? [1] : [0]
        
        do {
            try update(value: Data(bytes), account: account, service: service)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Update String Value
    /// Function to UPDATE any string value stored in Keychain
    /// - Parameters:
    ///   - value: specifies the new string value to be updated
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    public func update(value: String, service: String, account: String) {
        do {
            try update(value: value.data(using: .utf8) ?? Data(), account: account, service: service)
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Update Custom Objects
    /// Function to UPDATE any codable object stored in Keychain
    /// - Parameters:
    ///   - object: specifies the new object to be updated
    ///   - service: String to specify the service associated with this item
    ///   - account: Account name of keychain holder
    public func update<T: Codable> (object: T, service: String, account: String) {
        
        guard let userData = try? JSONEncoder().encode(object) else { return }
        
        do {
            try update(value: userData, account: account, service: service, isCustomObjectType: true)
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: UPDATE WEB CREDENTIALS DRIVER
    fileprivate func update(server: String, account: String, password: Data) throws {
        
        let attributes: [String: Any] = [
            KMConstants.account.value()    :  (keyPrefix + account) as AnyObject,
            KMConstants.valueData.value()  :  password as AnyObject,
        ]
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value() : kSecClassInternetPassword,
            KMConstants.server.value()    : server as AnyObject,
        ]
        
        query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        
        guard status == errSecSuccess else { throw KeychainError.unknown(status) }
    }
    
    //MARK: Update Web Credentials
    /// Function to UPDATE any password stored in Keychain
    /// - Parameters:
    ///   - server: Contains the server's domain name or IP address
    ///   - account: Account name of keychain holder
    ///   - password: Specifies the new password to be updated
    public func update(server: String, account: String, password: String) {
        do {
            let encryptedPassword = password.data(using: .utf8) ?? Data()
            try update(server: server, account: account, password: encryptedPassword)
            
        }catch {
            print(error.localizedDescription)
        }
    }
}

//MARK: - DELETE
extension KeychainManager {
    
    //MARK: DELETE SELECTED ITEM
    /// Function to DELETE / REMOVE a keychain value
    /// - Parameters:
    ///   - service: String to specify the service associated with this item
    ///   - isCustomObjectType: Explicitly tells the item to delete is a custom value type
    public func delete(service: String, isCustomObjectType: Bool = false) throws {
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value()  :  kSecClassGenericPassword,
            KMConstants.service.value()    :  service as AnyObject,
        ]
        
        if !isCustomObjectType {
            query = addSyncIfRequired(queryItems: query, isSynchronizable: synchronizable)
        }
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status) }
    }
    
    //MARK: DELETE WEB CREDENTIALS
    /// FFunction to DELETE / REMOVE passwords saved on Keychain
    /// - Parameters:
    ///   - server: Contains the server's domain name or IP address
    ///   - account: Account name of keychain holder
    public func delete(server: String) throws {
        
        var query: [String: AnyObject] = [
            KMConstants.classType.value()  :  kSecClassInternetPassword,
            KMConstants.server.value()     :  server as AnyObject,
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
    private func addSyncIfRequired(queryItems: [String: AnyObject], isSynchronizable: Bool) -> [String: AnyObject] {
        
        if isSynchronizable {
            var result: [String: AnyObject] = queryItems
            result[KMConstants.accessGroup.value()] = accessGroup as AnyObject
            result[KMConstants.synchronizable.value()] = isSynchronizable ? kCFBooleanTrue as AnyObject : kSecAttrSynchronizableAny as AnyObject
            
            return result
        }
        
        return queryItems
    }
}
