//
//  MainCell.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import UIKit

class MainCell: UICollectionViewCell {
    @IBOutlet weak var characterIMG: ImageCacheManager!
    @IBOutlet weak var characterNameLB: UILabel!
    @IBOutlet weak var urlLB: UILabel!
    @IBOutlet weak var comicLB: UILabel!
    @IBOutlet weak var seriesLB: UILabel!
    @IBOutlet weak var storyLB: UILabel!
    @IBOutlet weak var eventLB: UILabel!
    @IBOutlet weak var favoriteBTN: UIButton!
    
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
    
    func loadImage(url: String?) {
        if let urlString = url {
            let urlData = URL(string: urlString)!
            characterIMG.loadImage(from: urlData) { _ in
                DispatchQueue.main.async {
                    
                }
            }
        }
    }
}
