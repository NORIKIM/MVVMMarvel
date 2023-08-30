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
    
    func settingCell() {
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
    
    func loadImage(url: String?) {
        if let urlString = url {
            let urlData = URL(string: urlString)!
            characterIMG.loadImage(from: urlData) { _ in
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
    
    @objc func didSelectFavoriteButton(_ sender: UIButton) {
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
    
    func settingFavorite(character: Character) -> UIImage {
        let unFavoriteImage = UIImage(named: "emptyFavorite")!
        let favoriteImage = UIImage(named: "favorite")!
        let isFavorite = isFavorited(character)
        
        if isFavorite == true {
            return favoriteImage
        } else {
            return unFavoriteImage
        }
    }
    
    func isFavorited(_ character: Character) -> Bool {
        if let id = character.id {
           return (UserDefaults.standard.object(forKey: "\(id)") as? Bool) ?? false
        } else {
            return false
        }
    }
    
    func favorite(_ character: Character) {
        if let id = character.id {
            UserDefaults.standard.set(true, forKey: "\(id)")
        }
    }
    
    func unfavorite(_ character: Character) {
        if let id = character.id {
            UserDefaults.standard.removeObject(forKey: "\(id)")
        }
    }
}
