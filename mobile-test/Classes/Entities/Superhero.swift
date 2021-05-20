//
//  SuperheroEntity.swift
//  mobile-test
//
//  Created by sergio.martin.leon on 19/05/2021.
//

import Foundation


struct Superhero: Codable {
    let data: SuperheroData?
}

struct SuperheroData: Codable {
    let results: [SuperheroEntity]?
}

struct SuperheroEntity: Codable {
    let id: Int?
    let name: String?
    let description: String?
    var thumbnail: SuperheroTumbnail?
    let comics: SuperheroItems?
    let series: SuperheroItems?
    let stories: SuperheroItems?
    let events: SuperheroItems?
    let urls: [SuperheroUrlItem]?
}

struct SuperheroTumbnail: Codable {
    enum CodingKeys: String, CodingKey {
        case path
        case extensionString = "extension"
    }

    let path: String?
    let extensionString: String?
    var data: Data?
}

struct SuperheroItems: Codable {
    let items: [SuperheroItem]?
}

struct SuperheroItem: Codable {
    let resourceURI: String?
    let name: String?
    let type: String?
}

struct SuperheroUrlItem: Codable {
    let url: String?
    let type: String?
}
