//
//  BaseNetworkManager.swift
//  WeatherPal
//
//  Created by Gehad V on 11/10/2024.
//

import Foundation

enum ManagerErrors: Error {
    case invalidResponse
    case invalidStatusCode(Int)
    case invalidUrl
}

enum HttpMethod: String {
    case get
    case post
    
    var method: String { rawValue.uppercased() }
}

final class BaseNetworkManager {
    static let shared  = BaseNetworkManager()
    
    private init(){}
    
    func request<T: Decodable>(router: Routable, completion: @escaping (Result<T, Error>) -> Void) {
        
        let completionOnMain: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        guard let url = URL(string: router.path) else {
            completionOnMain(.failure(ManagerErrors.invalidUrl))
            return
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = router.queryItems
        guard let updatedUrl = components?.url else {
            completionOnMain(.failure(ManagerErrors.invalidUrl))
            return
        }
        print(updatedUrl.absoluteString)
        var request = URLRequest(url: updatedUrl)
        request.httpMethod = router.httpMethod
        request.cachePolicy = .returnCacheDataElseLoad
        let urlSession = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionOnMain(.failure(error))
                return
            }
            
            guard let urlResponse = response as? HTTPURLResponse else { return completionOnMain(.failure(ManagerErrors.invalidResponse)) }
            if !(200..<300).contains(urlResponse.statusCode) {
                return completionOnMain(.failure(ManagerErrors.invalidStatusCode(urlResponse.statusCode)))
            }
            
            guard let data = data else { return }
            do {
                let weatherData = try JSONDecoder().decode(T.self, from: data)
                completionOnMain(.success(weatherData))
            } catch {
                completionOnMain(.failure(error))
            }
        }
        
        urlSession.resume()
    }
    
}
