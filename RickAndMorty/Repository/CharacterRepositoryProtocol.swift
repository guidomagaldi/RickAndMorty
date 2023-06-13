//
//  CharacterRepositoryProtocolo.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 13/6/23.
//

import Foundation
import UIKit

protocol CharacterRepositoryProtocol {
    func getCharacters(page: Int, completion: @escaping (Result<([CharacterData], String?), NetworkError>) -> Void)
    func loadMoreCharacters(from url: String, completion: @escaping (Result<[CharacterData], NetworkError>) -> Void)
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
    func fetchSearchResults(query: String, completion: @escaping (Result<[CharacterData], NetworkError>) -> Void)
}
