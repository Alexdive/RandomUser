//
//  UserModel.swift
//  RandomUser
//
//  Created by Aleksei Permiakov on 19.04.2023.
//

import Foundation

// MARK: - User
public struct User: Codable {
    public let results: [UserDetails]
    public let info: Info
}

// MARK: - Info
public struct Info: Codable {
    public let seed: String
    public let results: Int
    public let page: Int
    public let version: String
}

// MARK: - Result
public struct UserDetails: Codable {
    public let gender: String
    public let name: Name
    public let location: Location
    public let email: String
    public let login: Login
    public let dob, registered: Dob
    public let phone, cell: String
    public let id: ID
    public let picture: Picture
    public let nat: String
}

// MARK: - Dob
public struct Dob: Codable {
    let date: String
    let age: Int
}

// MARK: - ID
public struct ID: Codable {
    let name: String
    let value: String?
}

// MARK: - Location
public struct Location: Codable {
    let street: Street
    let city, state, country: String
    let postcode: PostCode
    let coordinates: Coordinates
    let timezone: Timezone
   
}

public struct PostCode: Codable {
    let stringValue: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let intValue = try? container.decode(Int.self) {
            self.stringValue = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self.stringValue = stringValue
        } else {
            self.stringValue = "Unknown"
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.stringValue)
    }
}

// MARK: - Coordinates
public struct Coordinates: Codable {
    let latitude, longitude: String
}

// MARK: - Street
public struct Street: Codable {
    let number: Int
    let name: String
}

// MARK: - Timezone
public struct Timezone: Codable {
    let offset, description: String
}

// MARK: - Login
public struct Login: Codable {
    let uuid, username, password, salt: String
    let md5, sha1, sha256: String
}

// MARK: - Name
public struct Name: Codable {
    public let title, first, last: String
}

// MARK: - Picture
public struct Picture: Codable {
    let large, medium, thumbnail: String
}

extension UserDetails {
    var formattedDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: dob.date)
    }
    
    var stringDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        if let formattedDate {
            return dateFormatter.string(from: formattedDate)
        } else {
            return "Unknown"
        }
    }
}
