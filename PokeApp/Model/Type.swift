//
//  Type.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RealmSwift

class Type: Object, Decodable {
    @objc dynamic var name = ""
    @objc dynamic var slot = 0

    var image: UIImage? {
        if let img = UIImage(named: "Types-\(name.capitalized)") {
            return img
        }
        print("Types-\(name.capitalized)")
        return nil
    }

    override static func primaryKey() -> String? {
        return "name"
    }

    private enum TypeNameCodingKeys: String, CodingKey {
        case name
    }

    private enum TypeCodingKeys: String, CodingKey {
        case type
        case slot
    }

    convenience init(name: String, slot: Int) {
        self.init()
        self.name = name
        self.slot = slot
    }

    required convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TypeCodingKeys.self)
        let typeContainer = try container.nestedContainer(keyedBy: TypeNameCodingKeys.self, forKey: .type)
        let name = try typeContainer.decode(String.self, forKey: .name)
        let slot = try container.decode(Int.self, forKey: .slot)

        self.init(name: name, slot: slot)
    }
}
