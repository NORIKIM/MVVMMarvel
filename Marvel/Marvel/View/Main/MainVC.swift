//
//  MainVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/26.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MainVMDelegate {
    
    @IBOutlet weak var characterCV: UICollectionView!
    
    let cellID = "MainCell"
    lazy var favoriteBTN: UIBarButtonItem = {
        let img = UIImage(named: "favorite")!
        let button = UIBarButtonItem(image: img, style: .done, target: self, action: #selector(moveToFavorite(_:)))
        
        return button
    }()
    private let viewModel = MainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingUI()
        settingCollection()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reset()
        self.viewModel.reload()
        
    }
    
    func settingUI() {
        self.navigationItem.rightBarButtonItem = favoriteBTN
        self.navigationItem.rightBarButtonItem?.tintColor = .red
        
        viewModel.delegate = self
    }
    
    func settingCollection() {
        characterCV.delegate = self
        characterCV.dataSource = self
        characterCV.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    //viewModel delegate method
    func didFinishCharacterLoad() {
        DispatchQueue.main.async {
            self.characterCV.reloadData()
        }
    }
    
    @objc func moveToFavorite(_ sender: UIBarButtonItem) {
        
    }
}

// MARK: - collection
extension MainVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCharacters
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MainCell else { return UICollectionViewCell() }
        let character = viewModel.character(at: indexPath)
        
        if let path = character.thumbnail?.path, let extensionString = character.thumbnail?.extensionString {
            let characterImageURL = "\(path).\(extensionString)"
            cell.loadImage(url: characterImageURL)
        }

        cell.characterNameLB.text = character.name
        
        let urlCount = character.urls?.count
        cell.urlLB.text! += String(urlCount ?? 0)
        
        let comicCount = character.comics?.items?.count
        cell.comicLB.text! += String(comicCount ?? 0)
        
        let seriesCount = character.series?.items?.count
        cell.seriesLB.text! += String(seriesCount ?? 0)
        
        let storyCount = character.stories?.items?.count
        cell.storyLB.text! += String(storyCount ?? 0)
        
        let eventCount = character.events?.items?.count
        cell.eventLB.text! += String(eventCount ?? 0)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width / 2) - 15, height: 305)
    }
}
