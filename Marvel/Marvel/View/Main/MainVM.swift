//
//  MainVM.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import Foundation

protocol MainVMDelegate: AnyObject {
    func didFinishCharacterLoad()
    func showLastPageToast()
}

class MainVM {
    weak var delegate: MainVMDelegate?
    private var characters = [Character]()
    private var characterData: CharacterDataWrapper? {
        didSet { self.didUpdateCharacterData() }
    }
    var isFirstLoad: Bool {
        return currentPage == -1
    }
    var isLoading = false
    private let itemsPerPage: Int = 20
    private var currentPage: Int = -1
    private var isLastPage = false
    private var totalCharacter = 0
    var numberOfCharacters: Int {
        return characters.count
    }
        
    func reload() {
        reset()
        loadCharacters()
    }
    
    private func reset() {
        currentPage = -1
        characterData = nil
    }
    
    func loadCharacters() {
        guard isFirstLoad else {
            return
        }
        
        requestCharacter(page: 0)
    }
    
    private func didUpdateCharacterData() {
        if currentPage >= 1 {
            if characters.count == totalCharacter {
                isLastPage = true
                delegate?.showLastPageToast()
            } else {
                characters.append(contentsOf: characterData?.data?.results ?? [])
            }
        } else {
            characters = characterData?.data?.results ?? []
        }
    }
    
    func requestCharacter(page: Int) {
        if !canLoadPage(page: page) {
            return
        }
        
        if isLoading { return }
        
        isLoading = true
        
        Service.shared.requestCharacter(page: page) { isSuccess, result in
            print(page)
            if isSuccess {
                guard let result = result as? CharacterDataWrapper else { return }
                self.totalCharacter = (result.data?.total)!
                self.currentPage = page
                self.characterData = result
                self.delegate?.didFinishCharacterLoad()
            }
            self.isLoading = false
        }
    }
    
    func canLoadPage(page: Int) -> Bool {
        return self.currentPage != page && !isLastPage
    }
    
    func character(at indexPath: IndexPath) -> Character {
        return characters[indexPath.item]
    }
    
    func character(at id: Int) -> IndexPath? {
        if let index = characters.firstIndex(where: { $0.id == id }) {
            let indexPath = IndexPath(item: index, section: 0)
            return indexPath
        }
        return nil
    }
    
    func loadNextPage() {
        requestCharacter(page: currentPage + 1)
    }
}
