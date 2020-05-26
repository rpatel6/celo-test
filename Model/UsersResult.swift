//
//  UsersResult.swift
//  Celo test
//
//  Created by Raj Patel on 16/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import Foundation
struct UsersResult: Codable {
    var info: Info
    var results: [User]
}

struct Info: Codable {
    var page: Int?
    var results: Int?
    var seed: String?
    var version: String?
}

struct User: Codable {
    var gender: String?
    var cell: String?
    var email: String?
    var name: Name?
    var picture: Picture?
    var location: Location?
    var dob: DOB?
}

struct Name: Codable {
    var first: String?
    var last: String?
    var title: String?
}

struct Picture: Codable {
    var large: String?
    var medium: String?
    var thumbnail: String?
}

struct Location: Codable {
    var city: String?
    var country: String?
    var state: String?
    var street: Street?
    var timezone: Timezone?
}

struct Coordinates: Codable {
    var latitude: String?
    var longitude: String?
}
struct Street: Codable {
    var name: String?
    var number: Int?
}
struct Timezone: Codable {
    var description: String?
    var offset: String?
}
struct DOB: Codable {
    var date: String?
    var age: Int?
}
