//
//  CharacterFactory.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 13/6/23.
//

import Foundation

struct CharacterFactory {
    static func makeCharacterViewModel() -> CharacterViewModelProtocol {
        let network: NetworkProtocol = Network()
        let repository: CharacterRepositoryProtocol = CharacterRepository(APICaller: network)
        let viewModel: CharacterViewModelProtocol = CharacterViewModel(characterRepository: repository)
        return viewModel
    }
}
