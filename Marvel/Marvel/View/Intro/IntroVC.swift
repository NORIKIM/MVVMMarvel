//
//  IntroVC.swift
//  Marvel
//
//  Created by 김지나 on 2023/09/01.
//

import UIKit
import AVFoundation

class IntroVC: UIViewController, Storyboarded {
    @IBOutlet weak var videoView: UIView!
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setVideo()
        moveToMainVC()
    }

    func setVideo() {
        if let filePath:String = Bundle.main.path(forResource: "intro", ofType: "mp4") {
            let url = NSURL(fileURLWithPath: filePath)
            let player = AVPlayer(url: url as URL)
            
            player.actionAtItemEnd = .none
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect
            
            playerLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            videoView.layer.addSublayer(playerLayer)
            player.play()
        }
    }
    
    func moveToMainVC() {
        let time = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.coordinator?.moveToMainVC()
        }
    }
}
