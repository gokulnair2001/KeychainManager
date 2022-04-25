//
//  File.swift
//  
//
//  Created by Gokul Nair on 25/04/22.
//

import Foundation

public enum accessibilityType {
    case passcodeSet
    case unlocked
    case unlockedTDO
    case firstUnlock
    case firstUnlockTDO
    
    //MARK: - Method to return Enum value
    
     func value() -> CFString {
        switch self {
        case .passcodeSet:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .unlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .unlockedTDO:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .firstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .firstUnlockTDO:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        }
    }
}
