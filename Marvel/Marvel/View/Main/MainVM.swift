//
//  MainVM.swift
//  Marvel
//
//  Created by 김지나 on 2023/08/29.
//

import Foundation
import Combine

protocol MainVMDelegate: AnyObject {
    func showLastPageToast()
}

class MainVM {
    weak var delegate: MainVMDelegate?
    private var cancellables = Set<AnyCancellable>()
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
        characters.value.removeAll()
    }
    
    func loadCharacters() {
        guard isFirstLoad else {
            return
        }
        
        requestCharacter(page: 0)
    }
    
    func requestCharacter(page: Int) {
        if !canLoadPage(page: page) {
            return
        }
        
        if isLoading { return }
        
        isLoading = true
        
        Service.shared.requestCharacter(page: page)
            .sink { completion in
                switch completion {
                case .finished:
                    print("api Finished")
                case .failure(let err):
                    print("Error is \(err.localizedDescription)")
                }
            } receiveValue: { [weak self] characterData in
                self?.totalCharacter = (characterData.data?.total)!
                self?.currentPage = page
                
                if self?.currentPage ?? 0 > -1 {
                    if self?.characters.value.count == self?.totalCharacter {
                        self?.isLastPage = true
                        self?.delegate?.showLastPageToast()
                    }
                }
                
                self?.characters.send((self?.characters.value ?? []) + (characterData.data?.results ?? []))
                self?.isLoading = false
            }.store(in: &self.cancellables)
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
