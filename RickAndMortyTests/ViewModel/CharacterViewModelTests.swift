//
//  CharacterViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Guido Magaldi on 6/6/23.
//

import XCTest
@testable import RickAndMorty

final class CharacterViewModelTests: XCTestCase {
    private var sut: CharacterViewModel!
    private var mockRepository: MockCharacterRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockCharacterRepository()
        sut = CharacterViewModel(characterRepository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    private func makeMockCharacterResponse() -> CharacterResponse {
        return CharacterResponse(info: Info(count: 2, pages: 1, next: "nextURL"), results: [
            CharacterData(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Scientist", gender: "Male", origin: Location(name: "Earth", url: "earthURL"), location: Location(name: "Earth", url: "earthURL"), image: "rickImageURL", episode: ["episode1URL", "episode2URL"], url: "rickURL", created: "timestamp"),
            CharacterData(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Teenager", gender: "Male", origin: Location(name: "Earth", url: "earthURL"), location: Location(name: "Earth", url: "earthURL"), image: "mortyImageURL", episode: ["episode1URL", "episode2URL"], url: "mortyURL", created: "timestamp")
        ])
    }
    
    private func makeMockCharacterLoadMoreResponse() -> CharacterResponse {
        return  CharacterResponse(info: Info(count: 2, pages: 2, next: "nextURL"), results: [
            CharacterData(id: 3, name: "Summer", status: "Alive", species: "Human", type: nil, gender: "Female", origin: nil, location: nil, image: nil, episode: nil, url: nil, created: nil),
            CharacterData(id: 4, name: "Jerry", status: "Alive", species: "Human", type: nil, gender: "Male", origin: nil, location: nil, image: nil, episode: nil, url: nil, created: nil)
        ])
    }
    
    private func makeMockCharacters() -> [CharacterData] {
        return [
            CharacterData(id: 1, name: "Rick", status: "Alive", species: "Human", type: "Scientist", gender: "Male", origin: Location(name: "Earth", url: "earthURL"), location: Location(name: "Earth", url: "earthURL"), image: "rickImageURL", episode: ["episode1URL", "episode2URL"], url: "rickURL", created: "timestamp"),
            CharacterData(id: 2, name: "Morty", status: "Alive", species: "Human", type: "Teenager", gender: "Male", origin: Location(name: "Earth", url: "earthURL"), location: Location(name: "Earth", url: "earthURL"), image: "mortyImageURL", episode: ["episode1URL", "episode2URL"], url: "mortyURL", created: "timestamp")
        ]
    }
    
    func testGetCharacters_Success() {
        // Given
        let mockCharacters = makeMockCharacters()
        mockRepository.mockCharactersResponse = .success((mockCharacters, "NextPage"))
        
        // When
        sut.getCharacters()
        
        // Then
        XCTAssertTrue(mockRepository.getCharactersCalled)
        XCTAssertEqual(sut.characters.count, 2)
    }
    
    func testLoadMoreCharacters_Success() {
        // Given
        let existingCharacters = makeMockCharacters()
        guard let newCharacters = makeMockCharacterLoadMoreResponse().results else {
            XCTFail("Failed to create mock characters")
            return
        }
        sut.characters = existingCharacters
        sut.nextPageURL = "nextURL"
        mockRepository.mockMoreCharactersResponse = .success(newCharacters)
        
        // When
        sut.loadMoreCharacters()
        
        // Then
        XCTAssertEqual(sut.characters.count, 4)
        XCTAssertEqual(sut.currentPage, 2)
        XCTAssertEqual(sut.nextPageURL, "nextURL")
    }
    
    
    func testFetchImage_Success() {
        // Given
        let expectedImage = UIImage(named: "launchImage")!
        mockRepository.mockImageResponse = .success(expectedImage)
        
        // When
        sut.fetchImage(urlString: "https://example.com/mockImage.jpg") { result in
            
        // Then
        switch result {
            case .success(let image):
                XCTAssertEqual(image.pngData(), expectedImage.pngData())
            case .failure(let error):
                XCTFail("Fetching image failed with error: \(error)")
            }
        }
    }
    
    func testFetchSearchResults_Success() {
        // Given
        let query = "Rick"
        let expectedCharacters = makeMockCharacters()
        mockRepository.mockSearchResultsResponse = .success(expectedCharacters)
        
        // When
        sut.fetchSearchResults(query: query)
        
        // Then
        XCTAssertTrue(mockRepository.fetchSearchResultsCalled)
        XCTAssertEqual(sut.characters.first?.name, expectedCharacters.first?.name)
    }
}
