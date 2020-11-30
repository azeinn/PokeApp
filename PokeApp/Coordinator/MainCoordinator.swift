//
//  MainCoordinator.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import SVProgressHUD

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = PokemonListViewController.instantiate()
        vc.viewModel = PokemonListViewModel(coordinator: self)
        navigationController.pushViewController(vc, animated: false)
    }

    func openDetail(pokemon: Pokemon) {
        let vc = PokemonDetailViewController.instantiate()
        vc.viewModel = PokemonDetailViewModel(coordinator: self)
        vc.viewModel.pokemon = pokemon
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        navigationController.present(nav, animated: false)
    }
}
