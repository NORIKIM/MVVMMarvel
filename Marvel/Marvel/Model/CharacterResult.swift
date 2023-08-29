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


struct ComicList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [ComicSummary]?
}
struct ComicSummary: Codable {
    let resourceURI: String?
    let name: String
}

struct SeriesList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [SeriesSummary]?
}
struct SeriesSummary: Codable {
    let resourceURI: String?
    let name: String
    let type: String?
}


struct StoryList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [StorySummary]?
}
struct StorySummary: Codable {
    let resourceURI: String?
    let name: String
    let type: String?
}

struct EventList: Codable {
    let available: Int?
    let returned: Int?
    let collectionURI: String?
    let items: [EventSummary]?
}
struct EventSummary: Codable {
    let resourceURI: String?
    let name: String
    let type: String?
}


struct Url: Codable {
    let type: String?
    let url: String?
}

