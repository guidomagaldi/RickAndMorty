//
//  NetworkProtocol.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 6/6/23.
//

import Foundation

protocol NetworkProtocol {
    func fetchData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case dataConversionFailed
    case responseError(Int)
}
