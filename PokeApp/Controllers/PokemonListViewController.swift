//
//  PokemonListViewController.swift
//  PokeApp
//
//  Created by ahmad zen on 28/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

class PokemonListViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    var viewModel: PokemonListViewModel!
    
    // MARK: - View Life Cycle
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        let bundle = Bundle(for: PokemonListViewController.classForCoder())
        super.init(nibName: PokemonListViewController.identifier, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFunctionalities()
        configureVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getFunctionalities()

    }
    
    // MARK: - Private Methods
    
    /// Configure VC
    private func configureVC() {
        viewModel.delegate = self
        configureNavigationBar()
        configureTableView()
    }
    
    /// Configure Navigation Bar
    private func configureNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        //Setup Search Controller
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        navigationBar.backgroundColor = .white
        navigationBar.tintColor = .black
    }
    
    /// Configure tableview
    private func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension;
        tableView.separatorStyle = .none
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        tableView.addGestureRecognizer(longPress)
        Utilities.registerCellsFor(tableView: tableView)
    }
    
    /// Apply filter
    /// - Parameter searchText: text for filter
    private func filterFunction(searchText: String?) {
        viewModel.applyFilter(searchText: searchText)
    }
    
    @objc private func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint), let cellViewModel = viewModel.viewModel(for: indexPath) {                 
                let popOverViewController = WeaknessesPopOverViewController(viewModel: WeaknessesPopOverViewModel(pokemon: cellViewModel))
                popOverViewController.modalPresentationStyle = .overCurrentContext
                popOverViewController.modalTransitionStyle = .crossDissolve
                present(popOverViewController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension PokemonListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pokemon = viewModel.viewModel(for: indexPath) {
            let pokemonDetailViewController = PokemonDetailViewController(viewModel: PokemonDetailViewModel(pokemon: pokemon))
            navigationController?.pushViewController(pokemonDetailViewController, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension PokemonListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfPokemonRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cellViewModel = viewModel.viewModel(for: indexPath),  let cell = tableView.dequeueReusableCell(withIdentifier: PokemonTableViewCell.cellIdentifier, for: indexPath) as? PokemonTableViewCell {
            cell.configureCellWith(dataSource: cellViewModel)
            return cell
        }
        
        return UITableViewCell()
    }
}


extension PokemonListViewController: PokemonListViewModelDelegate {
    func refreshList() {
        tableView.reloadData()
    }
}


extension PokemonListViewController: UISearchBarDelegate{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar)
    {
        //Show Cancel
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.tintColor = .white
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Filter function
        self.filterFunction(searchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        
        guard let term = searchBar.text , term.isEmpty == false else {
            //Notification "White spaces are not permitted"
            return
        }
        
        //Filter function
        self.filterFunction(searchText: term)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //Hide Cancel
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text = String()
        searchBar.resignFirstResponder()
        
        //Filter function
        self.filterFunction(searchText: searchBar.text)
    }
}
