//
//  PokemonDetailTitleTableViewCell.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

class PokemonDetailTitleTableViewCell: UITableViewCell {
    @IBOutlet fileprivate var mainImageView: UIImageView!
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var type1ImageView: UIImageView!
    @IBOutlet fileprivate var type2ImageView: UIImageView!
    @IBOutlet fileprivate var descriptionLabel: UILabel!

    func setup(pokemon: Pokemon, detail: PokemonDetail?, tableMode: PokemonDetailViewController.Mode) {
        nameLabel.text = pokemon.name

        mainImageView.image = nil
        type1ImageView.image = nil
        type1ImageView.isHidden = true
        type2ImageView.image = nil
        type2ImageView.isHidden = true

        descriptionLabel.text = ""

        if let detail = detail {
            if let type1 = detail.types.filter({ $0.slot == 1 })[safe: 0] {
                type1ImageView.isHidden = false
                type1ImageView.image = UIImage(named: "Tag-\(type1.name.capitalized)")
            }
            if let type2 = detail.types.filter({ $0.slot == 2 })[safe: 0] {
                type2ImageView.isHidden = false
                type2ImageView.image = UIImage(named: "Tag-\(type2.name.capitalized)")
            }

            descriptionLabel.text = detail.pokemonDescription

            mainImageView.set(imageUrl: detail.mainImageUrl, placeholder: UIImage(named: "loader")) { imageLoaded in
                if let sprites = detail.sprites, let img = sprites.firstAvalable, !imageLoaded {
                    self.mainImageView.set(imageUrl: img)
                }
            }
        }
    }
}
