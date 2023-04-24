    //
    //  DefaultNetworkService.swift
    //  RandomUser
    //
    //  Created by Aleksei Permiakov on 22.04.2023.
    //

import Foundation

final class DefaultNetworkService: NetworkService {
    @discardableResult func request<Request: DataRequest>(
        _ request: Request,
        completion: @escaping (Result<Request.Response, NetworkError>) -> Void) -> Cancellable? {
            
            guard var urlComponent = URLComponents(string: request.url) else {
                completion(.failure(.invalidEndpoint))
                return nil
            }
            
            var queryItems: [URLQueryItem] = []
            request.queryItems.forEach {
                let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
                urlComponent.queryItems?.append(urlQueryItem)
                queryItems.append(urlQueryItem)
            }
            urlComponent.queryItems = queryItems
            
            guard let url = urlComponent.url else {
                completion(.failure(.invalidEndpoint))
                return nil
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = request.method.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    completion(.failure(.error(error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      200..<300 ~= response.statusCode else {
                    completion(.failure(.badResponse((response as? HTTPURLResponse)?.statusCode ?? 200)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.corruptedData))
                    return
                }
                
                do {
                    let object = try request.decode(data)
                    completion(.success(object))
                } catch {
                    completion(.failure(.error(error)))
                }
            }
            
            dataTask.resume()
            
            return dataTask
        }
}
