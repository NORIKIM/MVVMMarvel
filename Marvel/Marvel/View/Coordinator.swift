//
//  Coordinator.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import Foundation
import UIKit

class AppCoordinator {
    private var navi: UINavigationController!
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let mainVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "MainVC") as! MainVC
        navi.setViewControllers([mainVC], animated: true)
    }
}
