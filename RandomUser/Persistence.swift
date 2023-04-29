//
//  Persistence.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import Foundation

struct PersistenceKey {
    let key: String
}

enum PersistenceError: Error {
    case codableError(Error)
    case noDataForKey
}

protocol Persistence {
    func saveObject<T: Codable>(_ object: T, for key: PersistenceKey) throws
    func getObject<T: Codable>(for key: PersistenceKey) throws -> T
    func removeObject(for key: PersistenceKey)
}
