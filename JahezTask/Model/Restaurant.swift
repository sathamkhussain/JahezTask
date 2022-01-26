//
//  Restaurant.swift
//  JahezTask
//
//  Created by Satham Hussain on 1/25/22.
//

import Foundation

struct Restaurant : Codable {
    let id: Int?
    let name:String?
    let description: String?
    let hours: String?
    let image: String?
    let rating: Int?
    let distance: Double?
    let hasOffer: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case hours
        case image
        case rating
        case distance
        case hasOffer
    }
}

extension Restaurant : Hashable{}
