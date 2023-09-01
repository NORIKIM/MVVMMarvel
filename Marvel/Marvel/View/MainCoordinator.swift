//
//  MainCoordinator.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/31.
//

import UIKit

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navi: UINavigationController
    
    init(navi: UINavigationController) {
        self.navi = navi
    }
    
    func start() {
        let introVC = IntroVC.instantiate()
        introVC.coordinator = self
        navi.setViewControllers([introVC], animated: true)
    }
    
    func moveToMainVC() {
        let mainVC = MainVC.instantiate()
        mainVC.coordinator = self
        navi.setViewControllers([mainVC], animated: true)
    }
    
    func moveToFavoriteVC() {
        let favoriteVC = FavoriteVC.instantiate()
        favoriteVC.coordinator = self
        navi.pushViewController(favoriteVC, animated: true)
    }
}
