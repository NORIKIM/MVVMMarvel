//
//  Character.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation

struct Character: Codable {
    let code: Int
    let status: String
    let copyright: String
    let attrivutionText: String
    let attributionHTML: String
    let etag: String
    let data: CharaterData
}

struct CharaterData: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: [Results]
}

struct Results: Codable {
    let id: Int
    let name: String
    let description: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics: CSSE
    let seires: CSSE
    let stories: CSSE
    let events: CSSE
    let urls: Urls
}
