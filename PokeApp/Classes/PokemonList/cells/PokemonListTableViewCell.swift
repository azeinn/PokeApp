//
//  PokemonListTableViewCell.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import AlamofireImage

class PokemonListTableViewCell: UITableViewCell {
    @IBOutlet fileprivate var avatarImageView: UIImageView!
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var numberLabel: UILabel!
    @IBOutlet fileprivate var type1ImageView: UIImageView!
    @IBOutlet fileprivate var type2ImageView: UIImageView!

    var pokemon: Pokemon?

    func setup(pokemon: Pokemon) {
        self.pokemon = pokemon

        nameLabel.text = pokemon.name.capitalized

        // part of the detail
        avatarImageView.cancelImageRequest()
        avatarImageView.image = nil
        type1ImageView.cancelImageRequest()
        type1ImageView.image = nil
        type2ImageView.cancelImageRequest()
        type2ImageView.image = nil

        numberLabel.text = ""

        PokemonDetail.get(forUrl: pokemon.urlDetail) { [weak self] detail, error in
            if let self = self, let detail = detail, detail.url == self.pokemon!.urlDetail {
                self.avatarImageView.set(imageUrl: detail.mainImageUrl, placeholder: UIImage(named: "loader")) { imageLoaded in
                    if let sprites = detail.sprites, let img = sprites.firstAvalable, !imageLoaded {
                        self.avatarImageView.set(imageUrl: img)
                    }
                }
                self.numberLabel.text = String(format: "#%03d", detail.id)

                if let type = Array(detail.types)[safe: 0] {
                    self.type1ImageView.image = type.image
                }

                if let type = Array(detail.types)[safe: 1] {
                    self.type2ImageView.image = type.image
                }
            }
        }
    }
}
