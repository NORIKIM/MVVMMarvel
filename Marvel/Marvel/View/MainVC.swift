//
//  MainVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/26.
//

import UIKit

class MainVC: UIViewController {
    private let viewModel = MainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.reset()
        viewModel.reload()
    }

}

