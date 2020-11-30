//
//  Pokemon.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import Alamofire
import Realm
import RealmSwift

class Pokemon: Object, Decodable {
    @objc dynamic var name = ""
    @objc dynamic var urlDetail = ""

    override static func primaryKey() -> String? {
        return "name"
    }

    private enum PokemonCodingKeys: String, CodingKey {
        case name
        case urlDetail = "url"
    }

    convenience init(name: String, urlDetail: String) {
        self.init()
        self.name = name
        self.urlDetail = urlDetail
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonCodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let urlDetail = try container.decode(String.self, forKey: .urlDetail)
        self.init(name: name, urlDetail: urlDetail)
    }

    class func getAll(complete: @escaping ([Pokemon]?, AFError?) -> Void) {
        let params = ["limit": 1000]
        AF.request(PokeApi("pokemon", parameters: params)).responseDecodable { (response: DataResponse<PokemonResult, AFError>) in
            // debugPrint("Response: \(response)")
            if let value = response.value {
                complete(value.results, response.error)
            } else {
                complete(nil, response.error)
            }
        }
    }

    func detail(complete: @escaping (PokemonDetail?, AFError?) -> Void) {
        debugPrint("urlDetail: \(urlDetail)")

        PokemonDetail.get(forUrl: urlDetail, complete: complete)
    }
}

struct PokemonResult: Decodable {
    var results: [Pokemon] = []
}
