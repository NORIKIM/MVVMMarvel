//
//  Service.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation
import Moya

struct Service {
    static let shared = Service()
    private let provider = MoyaProvider<Network>()
    typealias callback = (_ isSuccess: Bool, _ result: Any?) -> ()

    func requestCharacter(completion: @escaping callback) {
        provider.request(.characters) { result in
            switch result {
            case .success(let response):
//                let character = try? response.map(CharacterDataWrapper.self)
//                print(character)
//                completion(true, character)
                do {
                    let character = try response.map(CharacterDataWrapper.self)
                    print(character)
                } catch(let err) {
                    print(err.localizedDescription)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, nil)
            }
        }
        
    }
}
