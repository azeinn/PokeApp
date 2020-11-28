//
//  PokemonDetailViewController.swift
//  PokeApp
//
//  Created by ahmad zen on 28/11/20.
//  Copyright © 2020 ahmadzen. All rights reserved.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: PokemonDetailViewModel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cardScrollView: UIScrollView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var pokemonDetailView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleSecondaryLabel: UILabel!
    @IBOutlet weak var mainTagImage: UIImageView!
    @IBOutlet weak var secondaryTagImage: UIImageView!
    @IBOutlet weak var summaryDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureVC()
        viewModel.fillSections()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Actions
    @IBAction func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        hideNavigationBar(false)
    }
    
    @IBAction func sectionTapped(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            viewModel.load(section: .stats)
        case 2:
            viewModel.load(section: .evolutions)
        default:
            viewModel.load(section: .moves)
        }
    }
    
    // MARK: - Private Methods
    /// Configure Image list
    /// - Parameter typeImages: Names of Images Assets.
    private func configure(_ typeImages: [String]) {
        if !typeImages.isEmpty {
            configure(imageUrlType: typeImages.safeContains(0), imageView: mainTagImage)
            configure(imageUrlType: typeImages.safeContains(1), imageView: secondaryTagImage)
        }
    }
    
    /// Configure NavigationBar
    private func configureNavigationBar() {
        hideNavigationBar(true)
    }
    
    /// Configure ScrollView
    private func configureScrollView() {
        cardScrollView.delegate = self
        Utilities.addCornerRadiusTo(cardScrollView.layer, cornerRadius: 35)
    }
    
    /// Configure tableview
     private func configureTableView() {
         tableView.backgroundColor = .clear
         tableView.dataSource = self
         tableView.delegate = self
         tableView.sectionHeaderHeight = UITableView.automaticDimension;
         tableView.separatorStyle = .none
         Utilities.registerCellsFor(tableView: tableView)
     }
    
    /// configuration ViewController
    private func configureVC() {
        viewModel.delegate = self
        titleSecondaryLabel.isHidden = true
        configureNavigationBar()
        configureScrollView()
        configureTableView()
        Utilities.addCornerRadiusTo(cardView.layer, cornerRadius: 35)
    }
    
    /// Hide navigation bar.
    /// - Parameter state: state for show bar
    private func hideNavigationBar(_ state: Bool) {
        navigationController?.setNavigationBarHidden(state, animated: false)
    }
    
    /// Obtain Color List for specific type
    /// - Parameter mainType: type name
    private func loadBackground(mainType: String) -> [CGColor] {
        switch mainType {
        case "bug":
            return BackgroundColors.bug
        case "dark":
            return BackgroundColors.dark
        case "dragon":
            return BackgroundColors.dragon
        case "electric":
            return BackgroundColors.electric
        case "fairy":
            return BackgroundColors.fairy
        case "fighting":
            return BackgroundColors.fighting
        case "fire":
            return BackgroundColors.fire
        case "flying":
            return BackgroundColors.flying
        case "ghost":
            return BackgroundColors.ghost
        case "grass":
            return BackgroundColors.grass
        case "ground":
            return BackgroundColors.ground
        case "ice":
            return BackgroundColors.ice
        case "normal":
            return BackgroundColors.normal
        case "poison":
            return BackgroundColors.poison
        case "psychic":
            return BackgroundColors.psychic
        case "rock":
            return BackgroundColors.rock
        case "steel":
            return BackgroundColors.steel
        case "water":
            return BackgroundColors.water
        default:
            return BackgroundColors.water
        }
    }
}

// MARK: - PokemonDetailViewModelDelegate
extension PokemonDetailViewController: PokemonDetailViewModelDelegate {
    func load(description: String) {
        summaryDescriptionLabel.text = description
    }
    
    func loadMainInfo(type: GenericSummary) {
        let types = PokemonManager.share.getTypeImages(for: type.name ?? "")
        if let typeForBackground = types.first {
            Utilities.addGradient(backgroundView.layer, bounds: backgroundView.bounds, colors: loadBackground(mainType: typeForBackground))
        }
        titleSecondaryLabel.text = type.name
        mainTitleLabel.text = type.name
        configure(types.map({"Tag-\($0.capitalized)"}))
        if let pokemonIndex = PokemonManager.getPokemonIndex(from: type.url) {
            Utilities.setImageOf(url: PokemonManager.getPokemonImageUrl(for: pokemonIndex), to: avatarImage, placeholder: nil)
        }
    }
    
    func refreshList() {
        tableView.reloadData()
    }
}

extension PokemonDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfPokemonRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cellViewModel = viewModel.viewModel(for: indexPath) as? SkillsCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: SkillsTableViewCell.cellIdentifier, for: indexPath) as! SkillsTableViewCell
            return cell
        } else if let cellViewModel = viewModel.viewModel(for: indexPath) as? WeaknessesDetailViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: WeaknessesDetailTableViewCell.cellIdentifier, for: indexPath) as! WeaknessesDetailTableViewCell
            cell.config(viewModel: cellViewModel)
            return cell
        } else if let cellViewModel = viewModel.viewModel(for: indexPath) as? EvolutionCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: EvolutionTableViewCell.cellIdentifier, for: indexPath) as! EvolutionTableViewCell
            cell.config(viewModel: cellViewModel)
            return cell
        } else if let cellViewModel = viewModel.viewModel(for: indexPath) as? MoveDetailCellViewModel {
            let cell = tableView.dequeueReusableCell(withIdentifier: MoveDetailTableViewCell.cellIdentifier, for: indexPath) as! MoveDetailTableViewCell
            cell.config(viewModel: cellViewModel)
            return cell
        }
        return UITableViewCell()
    }
}

extension PokemonDetailViewController: UITableViewDelegate {
    
}

// MARK: - UIScrollViewDelegate
extension PokemonDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == cardScrollView else { return }
        let yContentOffset = scrollView.contentOffset.y
        if pokemonDetailView.isHidden {
            hideElementsFromView(state: yContentOffset > 0)
        } else {
            hideElementsFromView(state: yContentOffset > 60)
            if yContentOffset > 60 {
                avatarImage.layoutIfNeeded()
            }
        }
        view.layoutIfNeeded()
    }
    
    func hideElementsFromView(state: Bool) {
        avatarImage.isHidden = state
        titleSecondaryLabel.isHidden = !state
        pokemonDetailView.isHidden = state
        pokemonDetailView.layoutIfNeeded()
        cardView.layoutIfNeeded()
    }
}
