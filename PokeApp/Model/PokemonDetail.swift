//
//  PokemonDetail.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PokemonDetail: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var url = ""
    @objc dynamic var mainImageUrl = ""
    @objc dynamic var sprites: Sprites? = Sprites()
    var types = List<Type>()
    @objc dynamic var speciesUrl = ""
    @objc dynamic var pokemonDescription = ""
    var stats = List<Stat>()

    override static func primaryKey() -> String? {
        return "url"
    }

    private enum SpeciesUrlKeys: String, CodingKey {
        case url
    }

    private enum PokemonDetailCodingKeys: String, CodingKey {
        case id
        case types
        case sprites
        case speciesUrl = "species"
        case stats
    }

    convenience init(id: Int, sprites: Sprites?, types: List<Type>, speciesUrl: String, stats: List<Stat>) {
        self.init()
        self.id = id
        mainImageUrl = "https://pokeres.bastionbot.org/images/pokemon/\(id).png"
        self.types = types
        self.sprites = sprites
        self.sprites?.id = id
        self.speciesUrl = speciesUrl
        self.stats = stats
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PokemonDetailCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let types = try container.decode([Type].self, forKey: .types)
        var typeList = List<Type>()
        typeList.append(objectsIn: types)
        typeList.reverse()
        let sprites = try container.decode(Sprites.self, forKey: .sprites)
        let speciesContainer = try container.nestedContainer(keyedBy: SpeciesUrlKeys.self, forKey: .speciesUrl)
        let speciesUrl = try speciesContainer.decode(String.self, forKey: .url)

        let stats = try container.decode([Stat].self, forKey: .stats)
        var statList = List<Stat>()
        statList.append(objectsIn: stats)
        statList.reverse()

        self.init(id: id, sprites: sprites, types: typeList, speciesUrl: speciesUrl, stats: statList)
    }

    class func chache(forUrl url: String) -> PokemonDetail? {
        do {
            let realm = try Realm()
            let details = realm.objects(PokemonDetail.self).filter("url = %@", url)
            if details.count > 0 {
                return details.first!
            }
            return nil
        } catch _ {
            return nil
        }
    }

    class func get(for pokemon: Pokemon, complete: @escaping (PokemonDetail?, AFError?) -> Void) {
        get(forUrl: pokemon.urlDetail, complete: complete)
    }

    class func get(forUrl url: String, complete: @escaping (PokemonDetail?, AFError?) -> Void) {
        if let cached = chache(forUrl: url) {
            complete(cached, nil)
        }

        AF.request(url).validate().responseDecodable { (response: DataResponse<PokemonDetail, AFError>) in
            if let value = response.value {
                value.url = url
                value.save()
                complete(value, nil)
            } else {
                complete(nil, response.error)
            }
        }
    }
}
