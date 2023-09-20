//
//  MainVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/26.
//

import UIKit
import Toaster
import Photos
import Combine

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, MainCellDelegate, Storyboarded, MainVMDelegate {
    
    @IBOutlet weak var characterCV: UICollectionView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    weak var coordinator: MainCoordinator?
    let cellID = "MainCell"
    var scrollingByUser = false
    private let viewModel = MainVM()
    private var cancellables: Set<AnyCancellable> = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setCollection()
        viewModel.reload()
        viewModel.characters
               .sink { [unowned self] _ in
                   self.characterCV.reloadData()
                   self.indicator.stopAnimating()
               }
               .store(in: &cancellables)
    }
    
    func setUI() {
        indicator.startAnimating()
        
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
    func showActionSheet(_ character: Character, characterImage: UIImage?) {
        guard let characterImage = characterImage else { return }
        
        let actionSheet = UIAlertController(title: character.name, message: nil, preferredStyle: .actionSheet)
        
        // 이미지 저장
        guard let thumbnail = character.thumbnail, let path = thumbnail.path else { return }
        if path.contains("image_not_available") == false {
            actionSheet.addAction(UIAlertAction(title: "이미지 저장", style: .default, handler: { _ in self.saveCharacterImage(characterImage) }))
        }
        
        // wiki
        actionSheet.addAction(UIAlertAction(title: "wiki", style: .default, handler: { _ in self.openWiki(url: character.urls) }))
        
        // 더보기
        guard let comic = character.comics, let comicCount = comic.returned else { return }
        guard let seies = character.series, let seiesCount = seies.returned else { return }
        guard let story = character.stories, let storyCount = story.returned else { return }
        guard let event = character.events, let eventCount = event.returned else { return }
        let sum = comicCount + seiesCount + storyCount + eventCount
        
        if sum > 0 {
            actionSheet.addAction(UIAlertAction(title: "더보기 ...", style: .default, handler: { _ in self.moveToCharacterDetailVC(character) }))
        }
        
        // 취소
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func saveCharacterImage(_ image: UIImage) {
        ImageManager().saveImage(image, target: self)
    }

    func openWiki(url: [Url]?) {
        if let characterUrls = url {
            let wiki = characterUrls.filter { $0.type == "wiki" }.first
            var link = characterUrls[0].url
            
            if let wiki = wiki {
                link = wiki.url
            }
            
            if let url = link, let wikiUrl = URL(string: url), UIApplication.shared.canOpenURL(wikiUrl) {
                UIApplication.shared.open(wikiUrl)
            }
        }
    }
    
    func moveToCharacterDetailVC(_ character: Character) {
        coordinator?.moveToCharacterDetailListVC(character)
    }
}

// MARK: - collection
extension MainVC {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.value.count
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
        
        showActionSheet(character, characterImage: cell.characterIMG.image)
    }
    
    // MainCell delegate method
    func didFinishSelectFavoriteButton(at indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.characterCV.reloadItems(at: [indexPath])
        }
    }
    // 즐겨찾기 화면에서 즐겨찾기 해제 후 호출
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
            indicator.startAnimating()
            viewModel.loadNextPage()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollingByUser = true
    }
}
