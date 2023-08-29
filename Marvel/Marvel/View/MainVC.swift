//
//  MainVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/26.
//

import UIKit

class MainVC: UIViewController {
    
    lazy var favoriteBTN: UIBarButtonItem = {
        let img = UIImage(named: "favorite")!
        let button = UIBarButtonItem(image: img, style: .done, target: self, action: #selector(moveToFavorite(_:)))
        
        return button
    }()
    private let viewModel = MainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reset()
        viewModel.reload()
    }
    
    func setUI() {
        self.navigationItem.rightBarButtonItem = favoriteBTN
        self.navigationItem.rightBarButtonItem?.tintColor = .red
    }
    
    @objc func moveToFavorite(_ sender: UIBarButtonItem) {
        
    }
}

