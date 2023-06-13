//
//  Networking.swift
//  RickAndMorty
//
//  Created by Guido Magaldi on 6/6/23.
//

import Foundation

final class Network: NetworkProtocol {
    
    public func fetchData(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(NetworkError.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            guard 200 ..< 300 ~= statusCode else {
                completion(.failure(NetworkError.responseError(statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.dataConversionFailed))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}



