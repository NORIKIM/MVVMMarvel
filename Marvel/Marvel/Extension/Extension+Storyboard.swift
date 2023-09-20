//
//  Extension+Storyboard.swift
//  Marvel
//
//  Created by 김지나 on 2023/09/01.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        // 스토리보드에서 설정한 스토리보드ID를 클래스명과 동일하게 설정 후 그대로 사용할 수 있도록 처리
        let fullName = NSStringFromClass(self)
        let className = fullName.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
