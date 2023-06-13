//
//  NetworkMock.swift
//  RickAndMortyTests
//
//  Created by Guido Magaldi on 12/6/23.
//

import Foundation
import UIKit

@testable import RickAndMorty

final class MockAPICaller: NetworkProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func fetchData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        if let mockData = mockData {
            completion(.success(mockData))
        } else if let mockError = mockError {
            completion(.failure(mockError))
        } else {
            completion(.failure(NetworkError.invalidURL))
        }
    }
}

extension MockAPICaller {
    func loadFromBundle() -> Data {
        guard let image = UIImage(named: "launchImage") else {
            fatalError("Failed to load launchImage from asset catalog")
        }
        guard let imageData = image.pngData() else {
            fatalError("Failed to retrieve PNG data from the image")
        }
        return imageData
    }
}

