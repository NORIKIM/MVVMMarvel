//
//  MainCell.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import UIKit

protocol MainCellDelegate: AnyObject {
    func didFinishSelectFavoriteButton(at indexPath: IndexPath)
}

class MainCell: UICollectionViewCell {
    @IBOutlet weak var characterIMG: ImageCacheManager!
    @IBOutlet weak var characterNameLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    @IBOutlet weak var comicLB: UILabel!
    @IBOutlet weak var seriesLB: UILabel!
    @IBOutlet weak var storyLB: UILabel!
    @IBOutlet weak var eventLB: UILabel!
    @IBOutlet weak var favoriteBTN: UIButton!
    
    weak var delegate: MainCellDelegate?
    var character: Character? {
        didSet {
            settingCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        characterIMG.image = nil
        characterNameLB.text = ""
        urlLB.text = "url "
        comicLB.text = "comic "
        seriesLB.text = "series "
        storyLB.text = "story "
        eventLB.text = "event "
    }
    
    private func settingCell() {
        if let character = character {
            if let path = character.thumbnail?.path, let extensionString = character.thumbnail?.extensionString {
                let characterImageURL = "\(path).\(extensionString)"
                loadImage(url: characterImageURL)
            }
            
            self.characterNameLB.text = character.name
            
            let urlCount = character.urls?.count
            urlLB.text! += String(urlCount ?? 0)
            
            let comicCount = character.comics?.items?.count
            comicLB.text! += String(comicCount ?? 0)
            
            let seriesCount = character.series?.items?.count
            seriesLB.text! += String(seriesCount ?? 0)
            
            let storyCount = character.stories?.items?.count
            storyLB.text! += String(storyCount ?? 0)
            
            let eventCount = character.events?.items?.count
            eventLB.text! += String(eventCount ?? 0)
            
            favoriteBTN.addTarget(self, action: #selector(didSelectFavoriteButton(_:)), for: .touchUpInside)
            let favoriteStatusImage = settingFavorite(character: character)
            favoriteBTN.setImage(favoriteStatusImage, for: .normal)
        }
    }
    
    private func loadImage(url: String?) {
        if let urlString = url, let urlData = URL(string: urlString) {
            characterIMG.loadImage(from: urlData) { _ in
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    @objc private func didSelectFavoriteButton(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let character = character {
            let isFavorite = isFavorited(character)
            
            if isFavorite {
                unfavorite(character)
            } else {
                favorite(character)
            }
            
            delegate?.didFinishSelectFavoriteButton(at: indexPath)
        }
    }
    
    private func settingFavorite(character: Character) -> UIImage {
        let unFavoriteImage = UIImage(named: "emptyFavorite")!
        let favoriteImage = UIImage(named: "favorite")!
        let isFavorite = isFavorited(character)
        
        if isFavorite == true {
            return favoriteImage
        } else {
            return unFavoriteImage
        }
    }
    
    private func isFavorited(_ character: Character) -> Bool {
        if let id = character.id {
           return (UserDefaults.standard.object(forKey: "\(id)") as? Bool) ?? false
        } else {
            return false
        }
    }
    
    private func favorite(_ character: Character) {
        if let id = character.id {
            UserDefaults.standard.set(true, forKey: "\(id)")
            appendFavoriteToList(character)
        }
    }
    
    private func unfavorite(_ character: Character) {
        if let id = character.id {
            UserDefaults.standard.removeObject(forKey: "\(id)")
            removeFavoriteFromList(character)
            NotificationCenter.default.post(name: Notification.Name.favorite, object: nil, userInfo: [NotificationKey.favorite: id])
        }
    }
    
    private func appendFavoriteToList(_ character: Character) {
        var favoriteList = UserDefaultsManager.favoriteList
        
        if favoriteList == nil {
            UserDefaultsManager.favoriteList = [character]
        } else {
            favoriteList?.append(character)
            UserDefaultsManager.favoriteList = favoriteList
        }
    }
    
    private func removeFavoriteFromList(_ character: Character) {
        if let favoriteList = UserDefaultsManager.favoriteList {
            var list = favoriteList
            let index = list.firstIndex(where: { $0.id == character.id })
            list.remove(at: Int(index!))
            UserDefaultsManager.favoriteList = list
        }
        
    }
}
