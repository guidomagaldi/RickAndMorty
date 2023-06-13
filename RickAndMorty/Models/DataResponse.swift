//
//  DataResponse.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 6/6/23.
//

import Foundation

// MARK: - Result
struct CharacterResponse: Codable {
    let info: Info?
    let results: [CharacterData]?
}

struct Info: Codable {
    let count, pages: Int?
    let next: String?
}

struct CharacterData: Codable, Identifiable {
    let id: Int?
    let name: String?
    let status: String?
    let species: String?
    let type: String?
    let gender: String?
    let origin, location: Location?
    let image: String?
    let episode: [String]?
    let url: String?
    let created: String?
}

struct Location: Codable {
    let name: String?
    let url: String?
}
