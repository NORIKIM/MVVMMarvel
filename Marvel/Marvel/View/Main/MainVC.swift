//
//  MainVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/26.
//

import UIKit
import Toaster

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MainVMDelegate, MainCellDelegate, Storyboarded {
    
    @IBOutlet weak var characterCV: UICollectionView!
    
    weak var coordinator: MainCoordinator?
    let cellID = "MainCell"
    var scrollingByUser = false
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
        let favoriteBTN = UIBarButtonItem(image: UIImage(named: "favorite")!, style: .done, target: self, action: #selector(moveToFavoriteVC(_:)))
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
    func showLastPageToast() {
        Toast(text: "마지막 페이지 입니다.", duration: Delay.short).show()
    }
    
    @objc func moveToFavoriteVC(_ sender: UIBarButtonItem) {
        self.coordinator?.moveToFavoriteVC()
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
        
        cell.favoriteBTN.tag = indexPath.item
        cell.character = character
        cell.delegate = self
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.size.width / 2) - 15, height: 305)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //
    }
    
    // MainCell delegate method
    func didFinishSelectFavoriteButton(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.characterCV.reloadItems(at: [indexPath])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollingByUser else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.height
        
        if offsetY >= (contentHeight - height) {
            viewModel.loadNextPage()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingByUser = true
    }
}
