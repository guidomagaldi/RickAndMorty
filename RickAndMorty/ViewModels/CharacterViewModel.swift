//
//  CharacterViewModel.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 6/6/23.
//

import Foundation
import UIKit

final class CharacterViewModel: CharacterViewModelProtocol {
  
    private var characterRepository: CharacterRepositoryProtocol
    
    var characters: [CharacterData] = [] {
        didSet {
            onDataChanged?()
        }
    }
    
    var currentPage: Int = 1
    var nextPageURL: String?
    var onDataChanged: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    var onMoreDataLoaded: (() -> Void)?
    
    init(characterRepository: CharacterRepositoryProtocol) {
        self.characterRepository = characterRepository
    }
    
    public func getCharacters(resetPage: Bool? = false) {
        if resetPage ?? false {
            currentPage = 1
        }
        
        characterRepository.getCharacters(page: currentPage) { [weak self] result in
            switch result {
            case .success((let characters, let nextPageUrl)):
                self?.characters = characters
                self?.currentPage += 1
                self?.nextPageURL = nextPageUrl
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    public func loadMoreCharacters() {
        guard let nextPageURL = nextPageURL else {
            return
        }
        
        characterRepository.loadMoreCharacters(from: nextPageURL) { [weak self] result in
            switch result {
            case .success(let newCharacters):
                self?.characters += newCharacters
                self?.currentPage += 1
                self?.onMoreDataLoaded?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
  
    public func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        characterRepository.fetchImage(urlString: urlString, completion: completion)
    }
    
    public func fetchSearchResults(query: String) {
        characterRepository.fetchSearchResults(query: query) { [weak self] result in
            switch result {
            case .success(let searchResults):
                self?.characters = searchResults
            case .failure(let error):
                self?.onError?(error)
                self?.getCharacters(resetPage: true)
            }
        }
    }
}
