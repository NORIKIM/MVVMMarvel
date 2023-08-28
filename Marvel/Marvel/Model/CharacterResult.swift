//
//  CharacterResult.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation

struct Thumbnail: Codable {
    enum CodingKeys: String, CodingKey {
        case path
        case extensionString = "extension"
    }
    
    let path: String
    let extensionString: String
}



// Comics, Series, Stories, Events
struct CSSE: Codable {
    let available: Int
    let collectionURL: String
    let items: [Item]
    let returned: Int
}
struct Item: Codable {
    let resourceURI: String
    let name: String
    let type: String?
}




struct Urls: Codable {
    let type: String
    let url: String
}

