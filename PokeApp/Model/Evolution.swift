//
//  Evolution.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class Evolution: Decodable {
    var evolvesFrom = ""
    var name = ""
    var speciesUrl = ""
    var evolvesTo = [Evolution]()

    private enum NameCodingKeys: String, CodingKey {
        case name
    }

    private enum UrlCodingKeys: String, CodingKey {
        case url
    }

    private enum CodingKeys: String, CodingKey {
        case species
        case evolvesTo = "evolves_to"
    }

    convenience init(name: String, speciesUrl: String, evolvesTo: [Evolution]?) {
        self.init()
        self.name = name
        self.speciesUrl = speciesUrl
        if let evolvesTo = evolvesTo {
            for ev in evolvesTo {
                ev.evolvesFrom = name
            }
        }
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let speciesNameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .species)
        let name = try speciesNameContainer.decode(String.self, forKey: .name)
        let speciesUrlContainer = try container.nestedContainer(keyedBy: UrlCodingKeys.self, forKey: .species)
        let speciesUrl = try speciesUrlContainer.decode(String.self, forKey: .url)

        let evolvesTo = try? container.decode([Evolution].self, forKey: .evolvesTo)

        self.init(name: name, speciesUrl: speciesUrl, evolvesTo: evolvesTo)
    }

    class func get(forUrl url: String, complete: @escaping (Evolution?, AFError?) -> Void) {
        AF.request(url).validate().responseDecodable { (response: DataResponse<EvolutionResult, AFError>) in
            debugPrint("evolution response: \(response)")
            if let value = response.value {
                complete(value.chain, nil)
            } else {
                complete(nil, response.error)
            }
        }
    }
}

struct EvolutionResult: Decodable {
    var chain: Evolution?
}
