//
//  NetworkService.swift
//  AprelTest
//
//  Created by Natalia Shevaldina on 25.04.2023.
//

import Foundation

class NetworkService {
    
    // Запрос к API
    func request<T: Codable>(_ urlRequestConvertibale: URLRequestConvertible,
                             responseType: T.Type,
                             completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let request = try urlRequestConvertibale.asURLRequest()
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                guard let resp = (response as? HTTPURLResponse)?.statusCode else {
                    completion(.failure(NSError()))
                    return }
                
                if resp < 300 {
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(result))
                        } catch {
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NSError()))
                }
            }
            task.resume()
        } catch (let error) {
            completion(.failure(error))
        }
    }
}
