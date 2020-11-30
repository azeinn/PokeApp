//
//  PokemonDetailViewModel.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift

class PokemonDetailViewModel {
    weak var coordinator: MainCoordinator!
    var pokemon: Pokemon!
    let pokemonDetail = BehaviorRelay<PokemonDetail?>(value: nil)
    let evolutionChain = BehaviorRelay<[Evolution]>(value: [])

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
    }

    func detail() {
        pokemon.detail { detail, _ in
            if let detail = detail {
                self.pokemonDetail.accept(detail)
            }
        }
    }

    func getDescription() {
        if let detail = pokemonDetail.value {
            Species.get(forUrl: detail.speciesUrl) { species, error in
                if let species = species {
                    if let desc = species.descriptions["en"] {
                        self.pokemonDetail.value?.update { (detail: PokemonDetail) in
                            detail.pokemonDescription = desc
                        }
                        self.pokemonDetail.accept(self.pokemonDetail.value)
                    }

                    // evolution chain
                    Evolution.get(forUrl: species.evolutionChainUrl) { evolution, error in
                        if let evolution = evolution {
                            var flatEvolutions = self.flatEvolvolutions(from: evolution)
                            if flatEvolutions.count > 0 {
                                flatEvolutions.remove(at: 0)
                            }
                            self.evolutionChain.accept(flatEvolutions)
                        }
                    }
                }
            }
        }
    }

    func flatEvolvolutions(from evolution: Evolution) -> [Evolution] {
        var retVal = [evolution]
        for ev in evolution.evolvesTo {
            retVal.append(contentsOf: flatEvolvolutions(from: ev))
        }
        return retVal
    }
}
