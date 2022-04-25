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
    
     func value() -> String {
        switch self {
        case .passcodeSet:
            return KeychainManagerConstants.passcodeSet
        case .unlocked:
            return KeychainManagerConstants.unlocked
        case .unlockedTDO:
            return KeychainManagerConstants.unlockedTDO
        case .firstUnlock:
            return KeychainManagerConstants.firstUnlock
        case .firstUnlockTDO:
            return KeychainManagerConstants.firstUnlockTDO
        }
    }
}
