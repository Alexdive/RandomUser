//
//  UserDefaultPersister.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 22.04.2023.
//

import Foundation

struct UserDefaultsPersister: Persistence {
    let userDefaults: UserDefaults
    
    func saveObject<T: Codable>(_ object: T, for key: PersistenceKey) throws {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(object)
            userDefaults.set(data, forKey: key.key)
        } catch {
            throw PersistenceError.codableError(error)
        }
    }
    
    func getObject<T: Codable>(for key: PersistenceKey) throws -> T {
        if let data = userDefaults.data(forKey: key.key) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw PersistenceError.codableError(error)
            }
        }
        throw PersistenceError.noDataForKey
    }
    
    func removeObject(for key: PersistenceKey) {
        userDefaults.removeObject(forKey: key.key)
    }
    
    func hasObject(for key: PersistenceKey) -> Bool {
        userDefaults.data(forKey: key.key) != nil
    }
}
