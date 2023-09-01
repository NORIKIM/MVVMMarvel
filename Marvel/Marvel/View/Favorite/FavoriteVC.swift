//
//  FavoriteVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/31.
//

import UIKit

class FavoriteVC: UIViewController, Storyboarded, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MainCellDelegate {
    @IBOutlet weak var characterCV: UICollectionView!
    @IBOutlet weak var noListView: UIView!
    
    weak var coordinator: MainCoordinator?
    let cellID = "MainCell"
    var character: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "즐겨찾기"
        
        listView()
        settingCollection()
    }

    func listView() {
        let favoriteList = UserDefaultsManager.favoriteList
        
        if  favoriteList?.count != 0 {
            character = favoriteList!
            noListView.isHidden = true
        } else {
            noListView.isHidden = false
        }
    }
    
    func settingCollection() {
        characterCV.delegate = self
        characterCV.dataSource = self
        characterCV.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
}

// MARK: - collection
extension FavoriteVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return character.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MainCell else { return UICollectionViewCell() }
        let character = character[indexPath.item]
        
        cell.favoriteBTN.tag = indexPath.item
        cell.character = character
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width / 2) - 15, height: 305)
    }
    
    // MainCell delegate method
    func didFinishSelectFavoriteButton(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.characterCV.reloadData()
            self.listView()
        }
    }
}
