//
//  File.swift
//  
//
//  Created by Gokul Nair on 25/04/22.
//

import Foundation

public enum accessibilityType {
    case passCodeSet
    case unlocked
    case unlockedTDO
    case firstUnlock
    case firstUnlockTDO
    
    //MARK: - Method to return Enum value
    
    private func value() -> String {
        switch self {
        case .passCodeSet:
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
