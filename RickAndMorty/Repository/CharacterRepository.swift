//
//  CharacterRepository.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 12/6/23.
//

import Foundation
import UIKit

final class CharacterRepository: CharacterRepositoryProtocol {
    
    private var APICaller: NetworkProtocol
    
    init(APICaller: NetworkProtocol) {
        self.APICaller = APICaller
    }
    
    func getCharacters(page: Int, completion: @escaping (Result<([CharacterData], String?), NetworkError>) -> Void) {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.charactersEndpoint + "?page=\(page)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        APICaller.fetchData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    if let characters = characterResponse.results {
                        completion(.success((characters, characterResponse.info?.next)))
                    }
                } catch {
                    completion(.failure(NetworkError.dataConversionFailed))
                }
            case .failure(let error):
                completion(.failure(NetworkError.requestFailed(error)))
            }
        }
    }

    
    func loadMoreCharacters(from url: String, completion: @escaping (Result<[CharacterData], NetworkError>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        APICaller.fetchData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    if let newCharacters = characterResponse.results {
                        completion(.success(newCharacters))
                    }
                } catch {
                    completion(.failure(NetworkError.dataConversionFailed))
                }
            case .failure(let error):
                completion(.failure(NetworkError.requestFailed(error)))
            }
        }
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        if let cachedImage = ImageCache.shared.getImage(forKey: urlString) {
            completion(.success(cachedImage))
            return
        }
        
        let request = URLRequest(url: url)
        APICaller.fetchData(with: request) { result in
            switch result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCache.shared.saveImage(image, forKey: urlString)
                    }
                    completion(.success(image))
                } else {
                    completion(.failure(NetworkError.dataConversionFailed))
                }
            case .failure(let error):
                completion(.failure(NetworkError.requestFailed(error)))
            }
        }
    }
    
    func fetchSearchResults(query: String, completion: @escaping (Result<[CharacterData], NetworkError>) -> Void) {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.charactersEndpoint + "/?name=\(query)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        APICaller.fetchData(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
                    if let searchResults = characterResponse.results {
                        completion(.success(searchResults))
                    }
                } catch {
                    completion(.failure(NetworkError.dataConversionFailed))
                }
            case .failure(let error):
                completion(.failure(NetworkError.requestFailed(error)))
            }
        }
    }
}
