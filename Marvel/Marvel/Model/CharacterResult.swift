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
    
    let path: String?
    let extensionString: String?
}

// comicList, seriesList, storyList, eventList
struct CSSEList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [CSSESummary]?
}
struct CSSESummary: Codable {
    let resourceURI: String?
    let name: String
    let type: String?
}

struct Url: Codable {
    let type: String?
    let url: String?
}
