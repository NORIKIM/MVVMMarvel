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
        if let error = error {
            let hasAuthorizeAccessPhotoAlbum = hasAuthorizeAccessPhotoAlbum()
            if hasAuthorizeAccessPhotoAlbum {
                showToast(message: "사진 저장에 실패하였습니다. 앨범 접근 권한을 허용해주세요.", duration: Delay.long)
            }
        } else {
            showToast(message: "사진을 앨범에 저장하였습니다.", duration: Delay.short)
        }
    }
    
    func showToast(message: String, duration: TimeInterval) {
        Toast(text: message, duration: duration).show()
    }
    
    func hasAuthorizeAccessPhotoAlbum() -> Bool {
        var status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        return status == .denied
    }
}
