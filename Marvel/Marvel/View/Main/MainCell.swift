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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        characterIMG.image = UIImage(named: "emptyCharacter")
        characterNameLB.text = ""
        urlLB.text = "url 0"
        comicLB.text = "comic 0"
        seriesLB.text = "series 0"
        storyLB.text = "story 0"
        eventLB.text = "event 0"
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
