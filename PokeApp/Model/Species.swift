//
//  Specie.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class SpeciesDescription: Decodable {
    var text = ""
    var language = ""
    var version = ""

    private enum NameCodingKeys: String, CodingKey {
        case name
    }

    private enum CodingKeys: String, CodingKey {
        case text = "flavor_text"
        case language
        case version
    }

    convenience init(text: String, language: String, version: String) {
        self.init()
        self.text = text
        self.language = language
        self.version = version
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let text = try container.decode(String.self, forKey: .text)
        let languageContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .language)
        let language = try languageContainer.decode(String.self, forKey: .name)
        let versionContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .version)
        let version = try versionContainer.decode(String.self, forKey: .name)

        self.init(text: text, language: language, version: version)
    }
}

class Species: Decodable {
    var descriptions = [String: String]()
    var evolutionChainUrl = ""

    private enum CodingKeys: String, CodingKey {
        case evolutionChainUrl = "evolution_chain.url"
        case species = "flavor_text_entries"
    }

    convenience init(evolutionChainUrl: String, species: [SpeciesDescription]?) {
        self.init()
        self.evolutionChainUrl = evolutionChainUrl
        if let species = species {
            species.forEach { desc in
                if desc.version == "alpha-sapphire" {
                    descriptions[desc.language] = desc.text
                }
            }
        }
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let evolutionChainUrl = try container.decode(String.self, forKey: .evolutionChainUrl)
        let species = try? container.decode([SpeciesDescription].self, forKey: .species)

        self.init(evolutionChainUrl: evolutionChainUrl, species: species)
    }

    class func get(forUrl url: String, complete: @escaping (Species?, AFError?) -> Void) {
        AF.request(url).validate().responseDecodable { (response: DataResponse<Species, AFError>) in
            if let value = response.value {
                complete(value, nil)
            } else {
                complete(nil, response.error)
            }
        }
    }
}
