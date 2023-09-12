//
//  MainVM.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import Foundation
import Combine

protocol MainVMDelegate: AnyObject {
    func didFinishCharacterLoad()
    func showLastPageToast()
}

class MainVM {
    weak var delegate: MainVMDelegate?
    private var cancellables = Set<AnyCancellable>()
    private var characterData = PassthroughSubject<CharacterDataWrapper?, Never>()
    var characters = CurrentValueSubject<[Character], Never>([Character]())
    var isFirstLoad: Bool {
        return currentPage == -1
    }
    var isLoading = false
    private let itemsPerPage: Int = 20
    private var currentPage: Int = -1
    private var isLastPage = false
    private var totalCharacter = 0
        
    func reload() {
        reset()
        loadCharacters()
    }
    
    private func reset() {
        currentPage = -1
        characterData.send(nil)
//        characterData = nil
    }
    
    func loadCharacters() {
        guard isFirstLoad else {
            return
        }
        
        requestCharacter(page: 0)
    }
    
    private func didUpdateCharacterData() {
        if currentPage >= 1 {
            if characters.value.count == totalCharacter {
                isLastPage = true
                delegate?.showLastPageToast()
            } else {
                characterData.sink { data in
                    let results = data?.data?.results
                    self.characters.value.append(contentsOf: results ?? [])
//                    self.characters.send(results ?? [])
//                    self.characters.append(contentsOf: results ?? [])
                }.store(in: &cancellables)
            }
        } else {
            characterData.sink { data in
                let results = data?.data?.results
                self.characters.send(results ?? [])
//                self.characters.append(contentsOf: results ?? [])
            }.store(in: &cancellables)
        }
    }
    
    func requestCharacter(page: Int) {
        if !canLoadPage(page: page) {
            return
        }
        
        if isLoading { return }
        
        isLoading = true
    
        Service.shared.requestCharacter(page: page)
            .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                print("api Finished")
            case .failure(let err):
                print("Error is \(err.localizedDescription)")
            }
        }, receiveValue: { data in
            self.totalCharacter = (data.data?.total)!
            self.currentPage = page
            self.characterData.send(data)
        }).store(in: &cancellables)
        
        self.didUpdateCharacterData()
        isLoading = false
    }
    
    func canLoadPage(page: Int) -> Bool {
        return self.currentPage != page && !isLastPage
    }
    
    func character(at indexPath: IndexPath) -> Character {
        return characters.value[indexPath.item]
    }
    
    func character(at id: Int) -> IndexPath? {
        if let index = characters.value.firstIndex(where: { $0.id == id }) {
            let indexPath = IndexPath(item: index, section: 0)
            return indexPath
        }
        return nil
    }
    
    func loadNextPage() {
        requestCharacter(page: currentPage + 1)
    }
}
