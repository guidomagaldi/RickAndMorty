//
//  CharacterViewModelProtocol.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 6/6/23.
//

import Foundation
import UIKit

protocol CharacterViewModelProtocol {
    var onDataChanged: (() -> Void)? { get set }
    var onMoreDataLoaded: (() -> Void)? { get set }
    var characters: [CharacterData] { get set }
    
    func getCharacters(resetPage: Bool?)
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void)
    func fetchSearchResults(query: String)
    func loadMoreCharacters()

}
