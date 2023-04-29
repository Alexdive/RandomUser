//
//  NetworkService.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import Foundation

protocol Cancelable {}

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

protocol DataRequest {
    associatedtype Response
    
    var url: String { get }
    var method: HTTPMethod { get }
    var headers: [String : String] { get }
    var queryItems: [String : String] { get }
    
    func decode(_ data: Data) throws -> Response
}

extension DataRequest where Response: Decodable {
    func decode(_ data: Data) throws -> Response {
        let decoder = JSONDecoder()
        return try decoder.decode(Response.self, from: data)
    }
}

extension DataRequest {
    var headers: [String : String] {
        [:]
    }
    
    var queryItems: [String : String] {
        [:]
    }
}

protocol NetworkService {
    @discardableResult func request<Request: DataRequest>(
        _ request: Request,
        completion: @escaping (Result<Request.Response, NetworkError>) -> Void) -> Cancellable?
}

enum NetworkError: Error {
    case invalidEndpoint
    case error(Error)
    case badResponse(Int)
    case corruptedData
}
