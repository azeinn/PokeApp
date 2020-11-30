//
//  PokemonListViewController.swift
//  PokeApp
//
//  Created by ahmad zen on 30/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD

class PokemonListViewController: BaseViewController {
    @IBOutlet var tableView: UITableView!

    var viewModel: PokemonListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 1000.0

        title = "Pokemon"

        dataBinding()

        SVProgressHUD.show()
        viewModel.getAll()

        addPullToRefresh()
    }

    func dataBinding() {
        viewModel.pokemonListRelay.asObservable().subscribe(onNext: { [weak self] list in
            SVProgressHUD.dismiss()
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

        viewModel.error.asObservable().subscribe(onNext: { [weak self] error in
            if let _ = error {
                SVProgressHUD.dismiss()
                let alert: UIAlertController = UIAlertController(title: "Opps!", message: "Something went wrong, try again!", preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(OKAction)
                self?.present(alert, animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
    }

    var refreshControl: UIRefreshControl?
    func addPullToRefresh() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl!)
    }

    @objc func refresh(_ sender: AnyObject) {
        SVProgressHUD.show()
        viewModel.getAll()
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pokemonList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonListTableViewCell", for: indexPath) as! PokemonListTableViewCell
        let pokemon = viewModel.pokemonList[indexPath.row]
        cell.setup(pokemon: pokemon)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.pokemonList[indexPath.row]
        viewModel.openDetail(pokemon: pokemon)
    }
}
