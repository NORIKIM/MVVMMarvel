//
//  Character.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation

struct CharacterDataWrapper: Codable {
    let code: Int?
    let status: String?
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let data: CharacterDataContainer?
    let etag: String?
}

struct CharacterDataContainer: Codable {
    let offset: Int?
    let limit: Int?
    let total: Int?
    let count: Int?
    let results: [Character]?
}

struct Character: Codable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let resourceURI: String?
    let urls: [Url]?
    let thumbnail: Thumbnail?
    let comics: ComicList?
    let stories: StoryList?
    let events: EventList?
    let series: SeriesList?  
}
