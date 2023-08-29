//
//  Extension+Bundle.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation

extension Bundle {
    var networkInfoPlistFile: String {
        guard let path = self.path(forResource: "NetworkInfo", ofType: "plist") else { return "" }
        return path
    }
    var networkInfoResource: NSDictionary {
        guard let resource = NSDictionary(contentsOfFile: networkInfoPlistFile) else { return [:] }
        return resource
    }
    var apiPublicKey: String {
        guard let key = networkInfoResource["API_PUBLIC_KEY"] as? String else {
            fatalError("api key가 필요합니다.")
        }
        return key
    }
    var apiPrivateKey: String {
        guard let key = networkInfoResource["API_PRIVATE_KEY"] as? String else {
            fatalError("api key가 필요합니다.")
        }
        return key
    }
}
