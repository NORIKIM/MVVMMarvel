//
//  Service.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/28.
//

import Foundation
import Moya
import Combine

/*struct Service {
    static let shared = Service()
    private let provider = MoyaProvider<Network>()
    typealias callback = (_ isSuccess: Bool, _ result: Any?) -> ()

    func requestCharacter(page: Int, completion: @escaping callback) {
        provider.request(.characters(page: page)) { result in
            switch result {
            case .success(let response):
                do {
                    let character = try response.map(CharacterDataWrapper.self)
                    completion(true, character)
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(false, nil)
                }
  
            case .failure(let error):
                print(error.localizedDescription)
                completion(false, nil)
            }
        }
        
    }
}*/

class Service {
    static let shared = Service()
    private init() {}
    
    private let provider = MoyaProvider<Network>()
    private var subsription = Set<AnyCancellable>()
    
    func requestCharacter(page: Int) -> Future<CharacterDataWrapper, Error> {
        return Future<CharacterDataWrapper, Error> { [weak self] promise in
            guard let self = self else { return }
            
            self.provider.requestPublisher(.characters(page: page))
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print(error.localizedDescription)
                        promise(.failure(error))
                    case .finished:
                        print("request finished")
                    }
                }, receiveValue: { result in
                    guard let character = try? result.map(CharacterDataWrapper.self) else { return }
                    promise(.success(character))
                }).store(in: &self.subsription)
        }
        
    }
}
