//
//  Sprites.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RealmSwift

class Sprites: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var frontDefault: String?
    @objc dynamic var frontFemale: String?
    @objc dynamic var frontShiny: String?
    @objc dynamic var frontShinyFemale: String?
    @objc dynamic var backDefault: String?
    @objc dynamic var backFemale: String?
    @objc dynamic var backShiny: String?
    @objc dynamic var backShinyFemale: String?

    var all: [String?] {
        return [frontDefault, frontFemale, frontShiny, frontShinyFemale, backDefault, backFemale, backShiny, backShinyFemale]
    }

    var firstAvalable: String? {
        return (all.filter { $0 != nil } as? [String])?.first
    }

    override static func primaryKey() -> String? {
        return "id"
    }

    private enum SpritesCodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case frontFemale = "front_female"
        case frontShiny = "front_shiny"
        case frontShinyFemale = "front_shiny_female"
        case backDefault = "back_default"
        case backFemale = "back_femalee"
        case backShiny = "back_shiny"
        case backShinyFemale = "back_shiny_female"
    }

    convenience init(frontDefault: String?, frontFemale: String?, frontShiny: String?, frontShinyFemale: String?, backDefault: String?, backFemale: String?, backShiny: String?, backShinyFemale: String?) {
        self.init()
        self.frontDefault = frontDefault
        self.frontFemale = frontFemale
        self.frontShiny = frontShiny
        self.frontShinyFemale = frontShinyFemale
        self.backDefault = backDefault
        self.backFemale = backFemale
        self.backShiny = backShiny
        self.backShinyFemale = backShinyFemale
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SpritesCodingKeys.self)
        let frontDefault = try? container.decode(String.self, forKey: .frontDefault)
        let frontFemale = try? container.decode(String.self, forKey: .frontFemale)
        let frontShiny = try? container.decode(String.self, forKey: .frontShiny)
        let frontShinyFemale = try? container.decode(String.self, forKey: .frontShinyFemale)
        let backDefault = try? container.decode(String.self, forKey: .backDefault)
        let backFemale = try? container.decode(String.self, forKey: .backFemale)
        let backShiny = try? container.decode(String.self, forKey: .backShiny)
        let backShinyFemale = try? container.decode(String.self, forKey: .backShinyFemale)

        self.init(frontDefault: frontDefault, frontFemale: frontFemale, frontShiny: frontShiny, frontShinyFemale: frontShinyFemale, backDefault: backDefault, backFemale: backFemale, backShiny: backShiny, backShinyFemale: backShinyFemale)
    }
}
