//
//  Extension+Notification.swift
//  Marvel
//
//  Created by 김지나 on 2023/09/01.
//

import Foundation

extension Notification.Name {
    static let favorite = Notification.Name("favorite")
}

enum NotificationKey {
    case favorite
}
