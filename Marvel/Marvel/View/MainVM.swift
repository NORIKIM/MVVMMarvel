//
//  MainVM.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import Foundation

class MainVM {
    private var characters = [Character]()
    private var characterData: CharacterDataWrapper? {
        didSet { self.didUpdateCharacterData() }
    }
    var isFirstLoad: Bool {
        return currentPage == -1
    }
    private let itemsPerPage: Int = 20
    private var currentPage: Int = -1
    
    func loadCharacters() {
        guard isFirstLoad else {
            return
        }
        
        requestCharacter(page: 0)
    }
    
    func reload() {
        reset()
        loadCharacters()
    }
    
    func reset() {
        currentPage = -1
        characterData = nil
    }
    
    private func didUpdateCharacterData() {
        if currentPage >= 1 {
            characters.append(contentsOf: characterData?.data?.results ?? [])
        } else {
            characters = characterData?.data?.results ?? []
        }
    }
    
    func requestCharacter(page: Int) {
        guard self.currentPage != page else {
            return
        }
        
        Service.shared.requestCharacter(page: page) { isSuccess, result in
            if isSuccess {
                self.currentPage = page
                self.characterData = result as? CharacterDataWrapper
                print(result as? CharacterDataWrapper)
            }
        }
    }
}
