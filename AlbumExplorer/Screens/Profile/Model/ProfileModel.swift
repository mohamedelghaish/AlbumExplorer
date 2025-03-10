//
//  ProfileModel.swift
//  AlbumExplorer
//
//  Created by Mohamed Kotb Saied Kotb on 09/03/2025.
//

import Foundation
struct User: Codable {
    let id: Int
    let name: String
    let address: Address
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
}

struct Album: Codable {
    let id: Int
    let title: String
    let userId: Int
}
