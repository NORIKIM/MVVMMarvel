//
//  Network.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation
import Moya

enum Network {
    case characters
    case comics(id: Int)
    case series(id: Int)
    case stories(id: Int)
    case events(id: Int)
}

extension Network: TargetType {
    var baseURL: URL {
        let url = URL(string: "https://gateway.marvel.com:443/v1/public")
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
        let apiPublicKey = Bundle.main.apiPublicKey
        let param = ["apikey": apiPublicKey]
        return .requestParameters(parameters: param, encoding: URLEncoding.default)
//        switch self {
//        case .characters:
//            <#code#>
//        case .comics:
//            <#code#>
//        case .series:
//            <#code#>
//        case .stories:
//            <#code#>
//        case .events:
//            <#code#>
//        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    
}
