//
//  Stat.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RealmSwift

class Stat: Object, Decodable {
    @objc dynamic var value: Int = 0
    @objc dynamic var name: String = ""

    var visualName: String {
        switch name {
        case "hp":
            return "HP"
        case "speed":
            return "SPD"
        case "attack":
            return "ATK"
        case "special-defense":
            return "SDEF"
        case "special-attack":
            return "SATK"
        case "defense":
            return "DEF"
        default:
            return name
        }
    }

    private enum NameCodingKeys: String, CodingKey {
        case name
    }

    private enum CodingKeys: String, CodingKey {
        case value = "base_stat"
        case stat
    }

    convenience init(name: String, value: Int) {
        self.init()
        self.name = name
        self.value = value
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .stat)
        let name = try nameContainer.decode(String.self, forKey: .name)
        let value = try container.decode(Int.self, forKey: .value)

        self.init(name: name, value: value)
    }
}
