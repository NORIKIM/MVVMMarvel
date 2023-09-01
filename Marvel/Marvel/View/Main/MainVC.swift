//
//  MainVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/26.
//

import UIKit
import Toaster
import Photos

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MainVMDelegate, MainCellDelegate, Storyboarded {
    
    @IBOutlet weak var characterCV: UICollectionView!
    
    weak var coordinator: MainCoordinator?
    let cellID = "MainCell"
    var scrollingByUser = false
    private let viewModel = MainVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollection()
        self.viewModel.reset()
        self.viewModel.reload()
    }
    
    func setUI() {
        let favoriteBTN = UIBarButtonItem(image: UIImage(named: "favorite")!, style: .done, target: self, action: #selector(moveToFavoriteVC(_:)))
        self.navigationItem.rightBarButtonItem = favoriteBTN
        self.navigationItem.rightBarButtonItem?.tintColor = .red
        
        viewModel.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didiUnFavoriteFromFavoriteVC(_:)), name: Notification.Name.favorite, object: nil)
    }
    
    func setCollection() {
        characterCV.delegate = self
        characterCV.dataSource = self
        characterCV.register(UINib(nibName: cellID, bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    // viewModel delegate method
    func didFinishCharacterLoad() {
        DispatchQueue.main.async {
            self.characterCV.reloadData()
        }
    }
    func showLastPageToast() {
        showToast(message: "마지막 페이지 입니다.", duration: Delay.short)
    }
    
    func showToast(message: String, duration: TimeInterval) {
        Toast(text: message, duration: duration).show()
    }
    
    // 즐겨찾기
    @objc func moveToFavoriteVC(_ sender: UIBarButtonItem) {
        self.coordinator?.moveToFavoriteVC()
    }
    
    // Action Sheet
    func showActionSheet(_ character: Character, characterImage: UIImage) {
        let actionSheet = UIAlertController(title: character.name, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "이미지 저장", style: .default, handler: { _ in self.saveCharacterImage(characterImage) }))
        actionSheet.addAction(UIAlertAction(title: "wiki", style: .default, handler: { _ in self.openWiki(url: character.urls) }))
        actionSheet.addAction(UIAlertAction(title: "더보기 ...", style: .default, handler: { _ in self.moveToCharacterDetailVC() }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func saveCharacterImage(_ image: UIImage) {
        ImageManager().saveImage(image)
    }
    
    func openWiki(url: [Url]?) {
        if let characterUrls = url {
            let wiki = characterUrls.filter { $0.type == "wiki" }.first
            var link = characterUrls[0].url!
            
            if wiki != nil {
                link = wiki!.url!
            }
            
            if let wikiUrl = URL(string: link), UIApplication.shared.canOpenURL(wikiUrl) {
                UIApplication.shared.open(wikiUrl)
            }
        }
    }
    
    func moveToCharacterDetailVC() {
        
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
        let cell = collectionView.cellForItem(at: indexPath) as! MainCell
        let character = viewModel.character(at: indexPath)
        
        showActionSheet(character, characterImage: cell.characterIMG.image!)
    }
    
    // MainCell delegate method
    func didFinishSelectFavoriteButton(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.characterCV.reloadItems(at: [indexPath])
        }
    }
    @objc func didiUnFavoriteFromFavoriteVC(_ noti: Notification) {
        guard let id = noti.userInfo?[NotificationKey.favorite] as? Int else { return }
        if let indexPath = viewModel.character(at: id) {
            DispatchQueue.main.async {
                self.characterCV.reloadItems(at: [indexPath])
            }
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
