//
//  UserDefaultsManager.swift
//  Marvel
//
//  Created by 김지나 on 2023/09/01.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultWrapper(key: "favoriteList", defaultValue: nil)
    static var favoriteList: [Character]?
}

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            // 언아카이빙 정의: JSONDecoder를 이용
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        
        set {
            // 아카이빙 정의: JSONEnocder를 이용
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
    
}
