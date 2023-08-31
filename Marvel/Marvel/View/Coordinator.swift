//
//  Coordinator.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navi: UINavigationController { get set }
    
    func start()
}
