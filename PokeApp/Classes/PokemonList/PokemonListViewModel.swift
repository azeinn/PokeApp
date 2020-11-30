//
//  PokemonListViewModel.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay
import Alamofire

class PokemonListViewModel {
    weak var coordinator: MainCoordinator!

    let error = BehaviorRelay<AFError?>(value: nil)
    let pokemonListRelay = BehaviorRelay<[Pokemon]>(value: [])
    var pokemonList: [Pokemon] {
        get {
            return pokemonListRelay.value
        }
        set {
            pokemonListRelay.accept(newValue)
        }
    }

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    func getAll() {
        Pokemon.getAll { pokemons, error in
            if let pokemons = pokemons {
                self.pokemonListRelay.accept(pokemons)
            } else {
                self.error.accept(error)
            }
        }
    }

    func openDetail(pokemon: Pokemon) {
        coordinator.openDetail(pokemon: pokemon)
    }
}
