//
//  File.swift
//  
//
//  Created by Gokul Nair on 25/04/22.
//

import Foundation

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
