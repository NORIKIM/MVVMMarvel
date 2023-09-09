//
//  ImageManager.swift
//  Marvel
//
//  Created by 김지나 on 2023/09/01.
//

import UIKit
import Toaster
import Photos

class ImageManager: NSObject {
    private var isPermissionDenied = false
    private var imageSavedHandler: (() -> Void)?
    private var viewController: UIViewController?
    
    func saveImage(_ image: UIImage, target: UIViewController? = nil, handler: (() -> Void)? = nil) {
        imageSavedHandler = handler
        viewController = target
        
        isPermissionDenied = hasAuthorizeAccessPhotoAlbum()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(didFinishSaveImage(_:saveError:contextInfo:)),nil)
    }
    
    @objc func didFinishSaveImage(_ image: UIImage, saveError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            let hasAuthorizeAccessPhotoAlbum = hasAuthorizeAccessPhotoAlbum()
            if hasAuthorizeAccessPhotoAlbum {
                self.authRequest()
            }
        } else {
            showToast(message: "사진을 앨범에 저장하였습니다.", duration: Delay.short)
        }
    }
    
    func authRequest() {
        let alert = UIAlertController(title: "사진첩 권한 요청", message: "사진첩 권한을 허용해야 이미지를 저장할 수 있습니다.", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) { action in
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting, options: [:], completionHandler: nil)
            }
        }
        
        alert.addAction(confirm)
        
        viewController!.present(alert, animated: true)
    }
    
    func showToast(message: String, duration: TimeInterval) {
        Toast(text: message, duration: duration).show()
    }
    
    func hasAuthorizeAccessPhotoAlbum() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        return status == .denied
    }
}
