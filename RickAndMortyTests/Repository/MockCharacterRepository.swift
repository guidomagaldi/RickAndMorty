//
//  MockCharacterRepository.swift
//  RickAndMortyTests
//
//  Created by Guido Magaldi on 13/6/23.
//

import Foundation
import UIKit

@testable import RickAndMorty

class MockCharacterRepository: CharacterRepositoryProtocol {
    
    var mockCharactersResponse: Result<([CharacterData], String?), NetworkError> = .failure(.invalidURL)
    var mockMoreCharactersResponse: Result<[CharacterData], NetworkError> = .failure(.invalidURL)
    var mockImageResponse: Result<UIImage, NetworkError> = .failure(.invalidURL)
    var mockSearchResultsResponse: Result<[CharacterData], NetworkError> = .failure(.invalidURL)
    
    var getCharactersCalled = false
    var loadMoreCharactersCalled = false
    var fetchImageCalled = false
    var fetchSearchResultsCalled = false
    
    func getCharacters(page: Int, completion: @escaping (Result<([CharacterData], String?), NetworkError>) -> Void) {
        getCharactersCalled = true
        completion(mockCharactersResponse)
    }
    
    func loadMoreCharacters(from url: String, completion: @escaping (Result<[CharacterData], NetworkError>) -> Void) {
        loadMoreCharactersCalled = true
        completion(mockMoreCharactersResponse)
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        fetchImageCalled = true
        completion(mockImageResponse)
    }
    
    func fetchSearchResults(query: String, completion: @escaping (Result<[CharacterData], NetworkError>) -> Void) {
        fetchSearchResultsCalled = true
        completion(mockSearchResultsResponse)
    }
}
