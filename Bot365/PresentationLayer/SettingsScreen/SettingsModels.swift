//
//  SettingsModels.swift
//  Nacional
//
//  Created by Дмитрий Терехин on 23.11.2022.
//

import Foundation

enum SettingType: CaseIterable {
    case myTrains
    case turnOffAdds
    case rateUs
    case feedback
    case privacy
    case terms
    case restorePurchases
    case deleteAccount
    
    var title: String {
        switch self {
        case .myTrains:
            return "My trains"
        case .turnOffAdds:
            return "Turn-off ads"
        case .rateUs:
            return "Rate us"
        case .feedback:
            return "Send feedback"
        case .privacy:
            return "Privacy policy"
        case .terms:
            return "Terms of use"
        case .restorePurchases:
            return "Restore purchase"
        case .deleteAccount:
            return "Delete account"
        }
    }
}
