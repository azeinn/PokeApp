//
//  PokemonDetailEvolutionTableViewCell.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

class PokemonDetailEvolutionTableViewCell: UITableViewCell {
    @IBOutlet var evolutionFromLabel: UILabel!
    @IBOutlet var evolutionToLabel: UILabel!

    func setup(evolution: Evolution) {
        evolutionFromLabel.text = evolution.evolvesFrom
        evolutionToLabel.text = evolution.name
    }
}
