//
//  Network.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation
import Moya
import CryptoKit

enum Network {
    case characters(page: Int)
    case comics(id: Int)
    case series(id: Int)
    case stories(id: Int)
    case events(id: Int)
}

extension Network: TargetType {
    var baseURL: URL {
        let url = URL(string: "https://gateway.marvel.com/v1/public")
        return url!
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/characters"
        case .comics(let id):
            return "/comics/\(id)"
        case .series(let id):
            return "/series/\(id)"
        case .stories(let id):
            return "/stories/\(id)"
        case .events(let id):
            return "/events/\(id)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        let timestamp = "\(Date().timeIntervalSince1970)"
        let apiPrivateKey = Bundle.main.apiPrivateKey
        let apiPublicKey = Bundle.main.apiPublicKey
        let hash = MD5(string: "\(timestamp)\(apiPrivateKey)\(apiPublicKey)")
        var param = ["ts": timestamp, "apikey": apiPublicKey, "hash": hash]
        
        switch self {
        case .characters(let page):
            if page > 0 {
                param.updateValue("\(page * 20)", forKey: "offset")
            }
        case .comics, .series, .stories, .events:
            param = ["ts": timestamp, "apikey": apiPublicKey, "hash": hash]
        }
         
        return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    func MD5(string: String) -> String {
        let digest = Insecure.MD5.hash(data: string.data(using: .utf8) ?? Data())

        return digest.map {
            String(format: "%02hhx", $0)
        }.joined()
    }
}
